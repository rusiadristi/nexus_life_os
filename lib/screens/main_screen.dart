import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'dashboard_screen.dart';
import 'ai_copilot_screen.dart';
import 'task_matrix_screen.dart';
import 'focus_chamber_screen.dart';
import 'wealth_matrix_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onNavigateTab: _onTabChanged),
      const AiCopilotScreen(),
      const TaskMatrixScreen(),
      const FocusChamberScreen(),
      const WealthMatrixScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}

