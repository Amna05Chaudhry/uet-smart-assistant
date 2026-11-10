import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models.dart';

class ChatReply {
  final String answer;

  /// "llm", "faq", "fallback" (server) or "local" (server unreachable).
  final String source;
  final bool llmOnline;
  final List<String> related;

  ChatReply(this.answer, this.source, this.llmOnline, this.related);

  bool get offline => source == 'local';
}

/// Talks to the FastAPI retrieval server; if it is unreachable, answers from the
/// FAQ bundled with the app using a small on-device keyword matcher.
class ChatService {
  ChatService(this.faq);

  final List<FaqItem> faq;

  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    // When the FastAPI server also serves the web build, use the same origin.
    if (kIsWeb && Uri.base.port == 8000) return Uri.base.origin;
    return 'http://localhost:8000';
  }

  Future<ChatReply> ask(String message) async {
    try {
      final res = await http
          .post(Uri.parse('$baseUrl/api/chat'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'message': message}))
          .timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final j = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final related = (j['matches'] as List)
            .skip(1)
            .where((m) => (m['score'] as num) > 0.35)
            .map((m) => m['question'] as String)
            .toList();
        return ChatReply(j['answer'], j['source'], j['llm_online'] == true, related);
      }
    } catch (_) {
      // fall through to the local matcher
    }
    return _local(message);
  }

  Future<bool> ping() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/api/health'))
          .timeout(const Duration(seconds: 3));
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ---- on-device fallback: char-trigram + word overlap -------------------
  static final _stop = {
    'the', 'a', 'an', 'is', 'are', 'do', 'i', 'to', 'of', 'in', 'for', 'and',
    'my', 'can', 'what', 'how', 'there', 'at', 'it', 'me', 'on', 'does', 'be',
  };

  static Set<String> _words(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .split(RegExp(r'\s+'))
      .where((w) => w.length > 1 && !_stop.contains(w))
      .toSet();

  static Set<String> _grams(String s) {
    final t = ' ${s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ')} ';
    return {for (var i = 0; i + 3 <= t.length; i++) t.substring(i, i + 3)};
  }

  static double _jaccard(Set<String> a, Set<String> b) {
    if (a.isEmpty || b.isEmpty) return 0;
    final inter = a.intersection(b).length;
    return inter / (a.length + b.length - inter);
  }

  ChatReply _local(String message) {
    final qw = _words(message), qg = _grams(message);
    final scored = <(FaqItem, double)>[];
    for (final f in faq) {
      var best = 0.0;
      for (final text in [f.question, ...f.alternatives]) {
        final s = 0.5 * _jaccard(qw, _words(text)) + 0.5 * _jaccard(qg, _grams(text));
        best = math.max(best, s);
      }
      scored.add((f, best));
    }
    scored.sort((a, b) => b.$2.compareTo(a.$2));
    if (scored.isEmpty || scored.first.$2 < 0.12) {
      return ChatReply(
          "I'm not sure about that one. Try asking about admissions, fees, hostels, transport, departments or exams.",
          'local',
          false,
          const []);
    }
    return ChatReply(scored.first.$1.answer, 'local', false,
        scored.skip(1).take(2).where((e) => e.$2 > 0.15).map((e) => e.$1.question).toList());
  }
}
