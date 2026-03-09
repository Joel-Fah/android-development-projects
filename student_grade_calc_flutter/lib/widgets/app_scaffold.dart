import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../theme/app_theme.dart';

/// Root scaffold with bottom navigation bar.
///
/// Wraps the currently visible page in a centered, width-constrained layout
/// so content never stretches beyond 720px on wide screens.
///
/// [currentIndex]: 0 = Home, 1 = History.
/// [onTabChanged]: called when the user taps a nav item.
/// [child]: the currently visible page widget.
class AppScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Widget child;

  const AppScaffold({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
            child: ClipOval(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 100.0,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.2)
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTabChanged,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(RemixIcons.home_6_line),
                  activeIcon: Icon(RemixIcons.home_6_fill),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(RemixIcons.archive_2_line),
                  activeIcon: Icon(RemixIcons.archive_2_fill),
                  label: 'History',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
