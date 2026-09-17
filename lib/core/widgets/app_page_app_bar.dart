import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AppBar یکدست با دکمه بازگشت و خانه برای صفحات پشته.
class AppPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppPageAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showHome = true,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String title;
  final List<Widget>? actions;
  final bool showHome;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading && canPop,
      leading: automaticallyImplyLeading && canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'بازگشت',
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: [
        ...?actions,
        if (showHome)
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'خانه',
            onPressed: () => context.go('/'),
          ),
      ],
    );
  }
}
