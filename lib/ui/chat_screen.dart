import 'package:flutter/material.dart';

import '../app_state.dart';
import '../services/chat_service.dart';

class _Msg {
  final String text;
  final bool user;
  final ChatReply? reply;
  _Msg(this.text, this.user, [this.reply]);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  final List<_Msg> _messages = [];
  bool _typing = false;
  bool? _serverUp;
  bool _llmOnline = false;
  AppState? _app;

  static const _suggestions = [
    'How is the admission merit calculated?',
    'What is the semester fee?',
    'How do I apply for a hostel room?',
    'What are the bus routes?',
    'What scholarships are available?',
    'Where is the library?',
    'How many absences are allowed?',
    'What societies are there?',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_app == null) {
      _app = AppScope.read(context);
      _app!.pendingQuestion.addListener(_onPending);
      _checkServer();
    }
  }

  @override
  void dispose() {
    _app?.pendingQuestion.removeListener(_onPending);
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onPending() {
    final q = _app!.pendingQuestion.value;
    if (q != null) {
      _app!.pendingQuestion.value = null;
      _send(q);
    }
  }

  Future<void> _checkServer() async {
    final up = await _app!.chat.ping();
    if (mounted) setState(() => _serverUp = up);
  }

  Future<void> _send(String text) async {
    text = text.trim();
    if (text.isEmpty || _typing) return;
    _input.clear();
    setState(() {
      _messages.add(_Msg(text, true));
      _typing = true;
    });
    _scrollDown();
    final reply = await _app!.chat.ask(text);
    if (!mounted) return;
    setState(() {
      _typing = false;
      _serverUp = !reply.offline;
      _llmOnline = reply.llmOnline;
      _messages.add(_Msg(reply.answer, false, reply));
    });
    _scrollDown();
    _focus.requestFocus();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent + 200,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: scheme.primary,
            child: Icon(Icons.auto_awesome, color: scheme.onPrimary, size: 18),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Campus Assistant'),
            Text(
              _serverUp == null
                  ? 'Connecting...'
                  : _serverUp!
                      ? 'Online, answers from ${_app!.data.faq.length} curated FAQs'
                      : 'Offline mode, matching the bundled FAQ',
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ]),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _Badge(
              label: _llmOnline ? 'LLM online' : 'LLM offline',
              color: _llmOnline ? const Color(0xFF10B981) : scheme.outline,
              tooltip: _llmOnline
                  ? 'Answers are written by an LLM from the retrieved FAQ entries'
                  : 'No LLM key configured: the best matching FAQ answer is shown as-is',
            ),
          ),
          if (_messages.isNotEmpty)
            IconButton(
              tooltip: 'Clear chat',
              onPressed: () => setState(_messages.clear),
              icon: const Icon(Icons.refresh_rounded),
            ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: _messages.isEmpty ? _welcome(theme) : _list(),
            ),
          ),
        ),
        _composer(scheme),
      ]),
    );
  }

  Widget _welcome(ThemeData theme) {
    return ListView(padding: const EdgeInsets.all(24), children: [
      const SizedBox(height: 24),
      Icon(Icons.forum_rounded, size: 56, color: theme.colorScheme.primary),
      const SizedBox(height: 12),
      Text('Assalam o Alaikum! How can I help?',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text(
        'Ask about admissions, fees, hostels, transport, departments, exams or campus life.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 24),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final s in _suggestions)
            ActionChip(label: Text(s), onPressed: () => _send(s)),
        ],
      ),
    ]);
  }

  Widget _list() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length + (_typing ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == _messages.length) return const _TypingBubble();
        final m = _messages[i];
        return _Bubble(msg: m, onRelated: _send);
      },
    );
  }

  Widget _composer(ColorScheme scheme) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (_messages.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final s in _suggestions)
                        Padding(
                          padding: const EdgeInsets.only(right: 6, bottom: 6),
                          child: ActionChip(
                              visualDensity: VisualDensity.compact,
                              label: Text(s),
                              onPressed: () => _send(s)),
                        ),
                    ],
                  ),
                ),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    focusNode: _focus,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _send,
                    decoration: const InputDecoration(hintText: 'Type your question...'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _typing ? null : () => _send(_input.text),
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg, required this.onRelated});
  final _Msg msg;
  final ValueChanged<String> onRelated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = msg.user;
    final r = msg.reply;
    final sourceLabel = switch (r?.source) {
      'llm' => 'LLM answer grounded in the FAQ',
      'faq' => 'From the FAQ',
      'local' => 'Offline FAQ match',
      _ => null,
    };
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .78),
        child: Column(
          crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 4, top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: user ? scheme.primary : scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(user ? 20 : 4),
                  bottomRight: Radius.circular(user ? 4 : 20),
                ),
              ),
              child: SelectableText(msg.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: user ? scheme.onPrimary : scheme.onSurface, height: 1.4)),
            ),
            if (sourceLabel != null)
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 4),
                child: Text(sourceLabel,
                    style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
              ),
            if (r != null && r.related.isNotEmpty)
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final q in r.related)
                  ActionChip(
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.subdirectory_arrow_right, size: 16),
                    label: Text(q),
                    onPressed: () => onRelated(q),
                  ),
              ]),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => Row(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Opacity(
                  opacity: 0.3 + 0.7 * _dot(i),
                  child: Transform.translate(
                    offset: Offset(0, -3 * _dot(i)),
                    child: CircleAvatar(radius: 4, backgroundColor: scheme.onSurfaceVariant),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  double _dot(int i) {
    final t = (_c.value - i * 0.18) % 1.0;
    return t < 0.5 ? (t < 0.25 ? t * 4 : (0.5 - t) * 4) : 0;
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, required this.tooltip});
  final String label, tooltip;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: .5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 6),
          Text(label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
