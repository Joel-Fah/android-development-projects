import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'data/history_repository.dart';
import 'pages/home_page.dart';
import 'pages/history_page.dart';
import 'theme/app_theme.dart';
import 'widgets/app_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize desktop SQLite support before the app starts
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize the database (creates tables if they don't exist)
  await HistoryRepository().init();

  runApp(const GradeCalculatorApp());
}

/// Root widget for the Student Grade Calculator app.
class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Grade Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const RootPage(),
    );
  }
}

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
