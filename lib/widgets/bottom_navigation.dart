import 'package:flutter/material.dart';
import 'package:macroverse/screens/calorie_calculator_screen.dart';
import 'package:macroverse/screens/dashboard_screen.dart';
import 'package:macroverse/screens/diary_screen.dart';
import 'package:macroverse/screens/profile_screen.dart';
import 'package:macroverse/screens/progress_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNav({super.key, required this.selectedIndex});
  static final List<NavItem> items = [
    NavItem(
      icon: Icons.dashboard_outlined,
      label: 'Dashboard',
      screen: const DashboardScreen(),
    ),
    NavItem(
      icon: Icons.menu_book_outlined,
      label: 'Diary',
      screen: const DiaryScreen(),
    ),
    NavItem(
      icon: Icons.newspaper_outlined,
      label: 'Calorie Tracker',
      screen: const CalorieEngineScreen(),
    ),
    NavItem(
      icon: Icons.list_alt_outlined,
      label: 'Progress',
      screen: const ProgressScreen(),
    ),
    NavItem(
      icon: Icons.more_horiz_rounded,
      label: 'Profile',
      screen: const ProfileScreen(),
    ),
  ];

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => items[index].screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _navigate(context, i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].icon,
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: active
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Widget screen;
  NavItem({required this.icon, required this.label, required this.screen});
}
