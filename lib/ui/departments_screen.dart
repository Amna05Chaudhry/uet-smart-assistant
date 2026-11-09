import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import 'widgets.dart';

const _deptColors = {
  'cs': Color(0xFF4F46E5),
  'ee': Color(0xFFF59E0B),
  'ce': Color(0xFF0EA5E9),
  'me': Color(0xFFEF4444),
  'hbs': Color(0xFF10B981),
};
const _deptIcons = {
  'cs': Icons.computer_rounded,
  'ee': Icons.bolt_rounded,
  'ce': Icons.memory_rounded,
  'me': Icons.precision_manufacturing_rounded,
  'hbs': Icons.functions_rounded,
};

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 1000 ? 2 : 1;
    final depts = app.data.departments;
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        Constrained(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Explore programmes, labs and where to find each department.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: cols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: cols == 2 ? 2.6 : (width < 420 ? 1.9 : 2.6),
              children: [for (final d in depts) _DeptCard(dept: d)],
            ),
          ]),
        ),
      ]),
    );
  }
}

class _DeptCard extends StatelessWidget {
  const _DeptCard({required this.dept});
  final Department dept;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _deptColors[dept.id] ?? theme.colorScheme.primary;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final app = AppScope.read(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AppScope(state: app, child: DepartmentDetailScreen(dept: dept))));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconBadge(icon: _deptIcons[dept.id] ?? Icons.school, color: color, size: 52),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(dept.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(dept.degree,
                    style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(dept.about,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ),
    );
  }
}

class DepartmentDetailScreen extends StatelessWidget {
  const DepartmentDetailScreen({super.key, required this.dept});
  final Department dept;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = _deptColors[dept.id] ?? scheme.primary;
    final building = app.data.building(dept.building);

    void backThen(VoidCallback a) {
      Navigator.of(context).pop();
      a();
    }

    Widget section(String title, IconData icon, List<String> items) => items.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(title,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 10),
                  for (final i in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7, right: 10),
                          child: CircleAvatar(radius: 3, backgroundColor: color),
                        ),
                        Expanded(child: Text(i, style: theme.textTheme.bodyMedium)),
                      ]),
                    ),
                ]),
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(title: Text(dept.short)),
      body: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
        Constrained(
          maxWidth: 820,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(colors: [color, color.withValues(alpha: .7)]),
              ),
              child: Row(children: [
                Icon(_deptIcons[dept.id] ?? Icons.school, color: Colors.white, size: 44),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Department of ${dept.name}',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(dept.degree,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              Chip(avatar: const Icon(Icons.verified_outlined, size: 18), label: Text(dept.accreditation)),
              if (dept.seats > 0)
                Chip(avatar: const Icon(Icons.groups_outlined, size: 18), label: Text('${dept.seats} seats / year (sample)')),
              if (building != null)
                Chip(avatar: const Icon(Icons.place_outlined, size: 18), label: Text(building.name)),
            ]),
            const SizedBox(height: 12),
            Text(dept.about, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
            section('Highlights', Icons.star_outline_rounded, dept.highlights),
            section('Labs', Icons.science_outlined, dept.labs),
            section('Career paths', Icons.work_outline_rounded, dept.careers),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Card(
                child: Column(children: [
                  ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(dept.chair),
                      subtitle: const Text('Head of department')),
                  ListTile(
                      leading: const Icon(Icons.mail_outline),
                      title: Text(dept.email),
                      subtitle: const Text('Placeholder contact')),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (building != null)
                FilledButton.icon(
                  onPressed: () => backThen(() => app.showOnMap(building.id)),
                  icon: const Icon(Icons.directions_walk_rounded, size: 18),
                  label: const Text('Show on campus map'),
                ),
              OutlinedButton.icon(
                onPressed: () => backThen(() => app.ask('Tell me about the ${dept.name} department.')),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Ask the assistant'),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}
