import 'package:flutter/material.dart';

import '../app_state.dart';
import 'topic_screen.dart';
import 'topics.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 1100 ? 4 : (width >= 600 ? 3 : 2);
    final upcoming = app.data.events
        .where((e) => !e.date.isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .take(3)
        .toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Constrained(child: _Hero(app: app))),
          SliverToBoxAdapter(
            child: Constrained(
              child: const SectionTitle('Quick access', padding: EdgeInsets.fromLTRB(4, 24, 4, 12)),
            ),
          ),
          SliverToBoxAdapter(
            child: Constrained(
              child: GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: cols == 2 ? 1.05 : 1.35,
                children: [for (final t in topics) _TopicCard(topic: t)],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Constrained(
              child: SectionTitle('Upcoming events',
                  padding: const EdgeInsets.fromLTRB(4, 28, 4, 12),
                  trailing: TextButton(
                    onPressed: () => openTopic(context, topics.firstWhere((t) => t.id == 'events')),
                    child: const Text('See all'),
                  )),
            ),
          ),
          SliverToBoxAdapter(
            child: Constrained(
              child: Column(children: [
                for (final e in upcoming)
                  Padding(padding: const EdgeInsets.only(bottom: 10), child: EventTile(event: e)),
                if (upcoming.isEmpty) const Text('No upcoming events in the sample calendar.'),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Constrained(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 20, 4, 32),
                child: Text(
                  'Student project. Campus details are sample data and may be out of date. '
                  'Always confirm with the university offices.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const white = Colors.white;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text('UET NAROWAL',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: white.withValues(alpha: .8), letterSpacing: 2)),
            ),
            IconButton(
              tooltip: 'Toggle dark mode',
              onPressed: () => app.toggleTheme(theme.brightness),
              icon: Icon(
                  theme.brightness == Brightness.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: white),
            ),
          ]),
          const SizedBox(height: 4),
          Text('Smart Assistant',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Your guide to campus: ask questions, find buildings, explore departments.',
              style: theme.textTheme.bodyLarge?.copyWith(color: white.withValues(alpha: .9))),
          const SizedBox(height: 18),
          Material(
            color: white,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => app.goTo(2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF4F46E5)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Ask anything, e.g. "How much is the hostel fee?"',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: Color(0xFF4F46E5)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _HeroChip(icon: Icons.map_outlined, label: 'Campus map', onTap: () => app.goTo(1)),
            _HeroChip(
                icon: Icons.directions_walk,
                label: 'Find the library',
                onTap: () => app.showOnMap('library')),
            _HeroChip(
                icon: Icons.school_outlined, label: 'Departments', onTap: () => app.goTo(3)),
          ]),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(label),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      backgroundColor: Colors.white.withValues(alpha: .15),
      side: BorderSide(color: Colors.white.withValues(alpha: .3)),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic});
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => topic.id == 'departments'
            ? AppScope.read(context).goTo(3)
            : openTopic(context, topic),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(icon: topic.icon, color: topic.color),
              const Spacer(),
              Text(topic.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(topic.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
