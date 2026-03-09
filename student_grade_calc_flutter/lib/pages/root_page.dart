import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';
import 'history_page.dart';
import 'home_page.dart';

/// RootPage manages which page (Home or History) is currently visible.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  // IndexedStack keeps all pages in memory — no rebuilds when switching tabs
  final List<Widget> _pages = const [HomePage(), HistoryPage()];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: _currentIndex,
      onTabChanged: (i) => setState(() => _currentIndex = i),
      child: IndexedStack(index: _currentIndex, children: _pages),
    );
  }
}
