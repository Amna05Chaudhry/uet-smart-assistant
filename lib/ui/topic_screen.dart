import 'package:flutter/material.dart';

import '../app_state.dart';
import 'topics.dart';
import 'widgets.dart';

void openTopic(BuildContext context, Topic topic) {
  final app = AppScope.read(context);
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => AppScope(state: app, child: TopicScreen(topic: topic)),
  ));
}

/// Detail page for a Home quick card: key facts, (events), and the FAQ entries
/// of that category as expandable tiles.
class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final theme = Theme.of(context);
    final faqs = app.data.faqIn(topic.faqCategory);

    void backThen(VoidCallback action) {
      Navigator.of(context).pop();
      action();
    }

    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Constrained(
            maxWidth: 820,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                IconBadge(icon: topic.icon, color: topic.color, size: 56),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(topic.subtitle,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ),
              ]),
              const SizedBox(height: 16),
              if (topic.facts.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(children: [
                      for (final f in topic.facts)
                        ListTile(
                          dense: true,
                          leading: Icon(f.$1, color: topic.color),
                          title: Text(f.$2, style: theme.textTheme.bodyMedium),
                        ),
                    ]),
                  ),
                ),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                FilledButton.icon(
                  onPressed: () => backThen(() => app.ask('Tell me about ${topic.title.toLowerCase()}')),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Ask the assistant'),
                ),
                if (topic.building != null)
                  OutlinedButton.icon(
                    onPressed: () => backThen(() => app.showOnMap(topic.building!)),
                    icon: const Icon(Icons.place_outlined, size: 18),
                    label: const Text('Show on map'),
                  ),
              ]),
              if (topic.id == 'events') ...[
                const SectionTitle('Calendar (sample)', padding: EdgeInsets.fromLTRB(0, 24, 0, 12)),
                for (final e in app.data.events)
                  Padding(padding: const EdgeInsets.only(bottom: 10), child: EventTile(event: e)),
              ],
              SectionTitle('Frequently asked (${faqs.length})',
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 12)),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(children: [
                  for (final (i, f) in faqs.indexed) ...[
                    if (i > 0) const Divider(height: 1),
                    ExpansionTile(
                      shape: const Border(),
                      title: Text(f.question,
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(f.answer, style: theme.textTheme.bodyMedium)],
                    ),
                  ],
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
