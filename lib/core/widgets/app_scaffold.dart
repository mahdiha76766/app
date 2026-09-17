import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// اسکفولد با نوار پایین مرتب و یکدست با تم.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _tabs = <_TabItem>[
    _TabItem(
      label: 'خانه',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      path: '/',
    ),
    _TabItem(
      label: 'خودروها',
      icon: Icons.directions_car_outlined,
      selectedIcon: Icons.directions_car_rounded,
      path: '/vehicles',
    ),
    _TabItem(
      label: 'یادآوری',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications_rounded,
      path: '/reminders',
    ),
    _TabItem(
      label: 'بیشتر',
      icon: Icons.more_horiz_rounded,
      selectedIcon: Icons.more_horiz_rounded,
      path: '/settings',
    ),
  ];

  int _currentIndex(String location) {
    final index = _tabs.indexWhere((tab) {
      if (tab.path == '/') {
        return location == '/';
      }
      return location == tab.path || location.startsWith('${tab.path}/');
    });
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Material(
        color: theme.colorScheme.surface,
        elevation: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.28),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  for (var i = 0; i < _tabs.length; i++)
                    Expanded(
                      child: _NavDestination(
                        item: _tabs[i],
                        selected: currentIndex == i,
                        onTap: () {
                          final target = _tabs[i].path;
                          if (location != target) {
                            context.go(target);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination extends StatelessWidget {
  const _NavDestination({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _TabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: selected ? 56 : 40,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              selected ? item.selectedIcon : item.icon,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
}
