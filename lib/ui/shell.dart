import 'package:flutter/material.dart';

import '../app_state.dart';
import 'chat_screen.dart';
import 'departments_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';

/// Bottom navigation on phones, a navigation rail on wide (web/desktop) screens.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _dests = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.map_outlined, Icons.map_rounded, 'Campus Map'),
    (Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Assistant'),
    (Icons.school_outlined, Icons.school_rounded, 'Departments'),
  ];

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final body = IndexedStack(
      index: app.tab,
      children: const [HomeScreen(), MapScreen(), ChatScreen(), DepartmentsScreen()],
    );

    if (!wide) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: app.tab,
          onDestinationSelected: app.goTo,
          destinations: [
            for (final d in _dests)
              NavigationDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: d.$3),
          ],
        ),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: app.tab,
            onDestinationSelected: app.goTo,
            labelType: NavigationRailLabelType.all,
            backgroundColor: scheme.surfaceContainerLow,
            leading: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: scheme.primary,
                child: Text('UET',
                    style: TextStyle(
                        color: scheme.onPrimary, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ),
            destinations: [
              for (final d in _dests)
                NavigationRailDestination(
                    icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: Text(d.$3)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
