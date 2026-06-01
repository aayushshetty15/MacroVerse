import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:macroverse/widgets/bottom_navigation.dart';
import 'package:macroverse/services/storage_service.dart';
import 'package:macroverse/services/calorie_service.dart';
import 'package:macroverse/services/macro_service.dart';

import 'package:macroverse/screens/food_search_screen.dart';
import '../models/food_model.dart';

import '../constants/app_colors.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────

// ── Dashboard Screen ──────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _macroPage = 0; // 0-indexed dot indicator matching PageView
  int notifCount = 9;
  int _waterLogged = 2;
  final int _waterGoal = 8;
  int _stepsLogged = 5500;
  DateTime _selectedDate = DateTime.now();

  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;

  final _searchCtrl = TextEditingController();
  late PageController _macroPageCtrl;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void initState() {
    super.initState();
    _macroPageCtrl = PageController(initialPage: 0);
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic);

    _ringCtrl.forward();
  }

  @override
  void dispose() {
    _macroPageCtrl.dispose();
    _ringCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loggedMeals = StorageService.getMeals().where((m) => _isSameDay(m.date, _selectedDate)).toList();
    final breakfastList = loggedMeals.where((m) => m.mealType.toLowerCase() == 'breakfast').expand((m) => m.foods).toList();
    final lunchList = loggedMeals.where((m) => m.mealType.toLowerCase() == 'lunch').expand((m) => m.foods).toList();
    final dinnerList = loggedMeals.where((m) => m.mealType.toLowerCase() == 'dinner').expand((m) => m.foods).toList();
    final snackList = loggedMeals.where((m) => m.mealType.toLowerCase() == 'snack').expand((m) => m.foods).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingBar(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _buildWeeklyProgressCard(),
                          const SizedBox(height: 16),
                          _buildStepsWaterRow(),
                          const SizedBox(height: 16),
                          _buildWeeklyCalendarSlider(),
                          const SizedBox(height: 20),
                          _buildMacrosCard(), // Premium swipable macros breakdowns
                          const SizedBox(height: 24),
                          
                          const Text(
                            "Today's Meals",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildMealCardItem(
                            title: 'Breakfast',
                            subtitle: 'Recommended: 400-550 kcal',
                            foods: breakfastList,
                            defaultKcalRange: '456 - 512 kcal',
                            mealType: 'Breakfast',
                          ),
                          const SizedBox(height: 12),
                          _buildMealCardItem(
                            title: 'Lunch time',
                            subtitle: 'Recommended: 600-750 kcal',
                            foods: lunchList,
                            defaultKcalRange: '456 - 512 kcal',
                            mealType: 'Lunch',
                          ),
                          const SizedBox(height: 12),
                          _buildMealCardItem(
                            title: 'Dinner',
                            subtitle: 'Recommended: 700-900 kcal',
                            foods: dinnerList,
                            defaultKcalRange: '456 - 512 kcal',
                            mealType: 'Dinner',
                          ),
                          const SizedBox(height: 12),
                          _buildMealCardItem(
                            title: 'Snacks',
                            subtitle: 'Recommended: 200-350 kcal',
                            foods: snackList,
                            defaultKcalRange: '200 - 300 kcal',
                            mealType: 'Snack',
                          ),
                          const SizedBox(height: 24),
                          _buildSearchBar(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 0),
    );
  }

  // ── Unified Profile Greeting Bar ──────────────────────────────────────────
  Widget _buildGreetingBar() {
    final profile = StorageService.getUserProfile();
    final name = profile?.name ?? 'Sajibur Rahman';
    final hour = DateTime.now().hour;
    String greetingText = "Good morning!";
    if (hour >= 12 && hour < 17) {
      greetingText = "Good afternoon!";
    } else if (hour >= 17) {
      greetingText = "Good evening!";
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80',
            ),
            backgroundColor: Color(0xFFC2C6D8),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greetingText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Calendar Icon Button
          _buildGreetingActionBtn(Icons.calendar_today_outlined, () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primaryContainer,
                      onPrimary: Colors.white,
                      onSurface: AppColors.onSurface,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
              });
            }
          }),
          const SizedBox(width: 10),
          // Notification Bell Button with green dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildGreetingActionBtn(Icons.notifications_outlined, () {
                _showNotificationsBottomSheet(context);
              }),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF76C83E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFEBEEF1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.onSurface, size: 20),
      ),
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final loggedMeals = StorageService.getMeals().where((m) => _isSameDay(m.date, _selectedDate)).toList();
    
    double consumedProtein = 0;
    for (final meal in loggedMeals) {
      consumedProtein += meal.totalProtein;
    }
    final proteinTarget = profile != null ? CalorieService.proteinGoal(profile).round() : 140;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F5FC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 18, color: AppColors.outline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildNotificationItem(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFFF8F00),
                  bgColor: const Color(0xFFFFF3E0),
                  title: '5-Day Streak!',
                  message: 'You have tracked consistently for 5 days. Keep up the amazing work!',
                ),
                const SizedBox(height: 12),
                _buildNotificationItem(
                  icon: Icons.water_drop_rounded,
                  iconColor: AppColors.blue,
                  bgColor: const Color(0xFFE3F2FD),
                  title: 'Water Logged',
                  message: _waterLogged >= _waterGoal 
                      ? 'Excellent hydration! You met your goal of $_waterGoal glasses.'
                      : 'You\'ve logged $_waterLogged of $_waterGoal glasses today. Keep drinking water!',
                ),
                const SizedBox(height: 12),
                _buildNotificationItem(
                  icon: Icons.fitness_center_rounded,
                  iconColor: AppColors.gold,
                  bgColor: const Color(0xFFFEF9E7),
                  title: 'Protein Progress',
                  message: consumedProtein >= proteinTarget
                      ? 'Awesome! You hit your protein goal of ${proteinTarget}g today!'
                      : 'Logged ${consumedProtein.round()}g of protein out of your ${proteinTarget}g goal.',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEEF1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.outline,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getWeeklyProgressDays() {
    final sundayOfThisWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));
    final loggedMeals = StorageService.getMeals();
    
    int daysWithMeals = 0;
    for (int i = 0; i < 7; i++) {
      final date = sundayOfThisWeek.add(Duration(days: i));
      final hasMeals = loggedMeals.any((m) =>
          m.date.day == date.day &&
          m.date.month == date.month &&
          m.date.year == date.year &&
          m.foods.isNotEmpty);
      if (hasMeals) {
        daysWithMeals++;
      }
    }
    return daysWithMeals == 0 ? 3 : daysWithMeals;
  }

  // ── Weekly Progress Card (Brand Blue Theme) ────────────────────────────────
  Widget _buildWeeklyProgressCard() {
    final progressDays = _getWeeklyProgressDays();
    final progressVal = progressDays / 7.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF), // Soft light brand blue background
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.primaryContainer,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Daily intake',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0050CB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Weekly\nProgress',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF003D9E),
                    height: 1.25,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Circular progress ring showing days
          SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(84, 84),
                  painter: _SingleRingPainter(
                    progress: progressVal,
                    color: AppColors.primaryContainer,
                    trackColor: const Color(0xFFF1F6FF),
                    strokeWidth: 9,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$progressDays',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003D9E),
                        height: 1.1,
                      ),
                    ),
                    const Text(
                      'days',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0050CB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Steps and Water Habit Tracker Row ─────────────────────────────────────
  Widget _buildStepsWaterRow() {
    return Row(
      children: [
        // Steps Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBEEF1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Step to\nwalk',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _stepsLogged += 500);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF3E0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_walk_rounded,
                          color: Color(0xFFFF8F00),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(
                        text: '$_stepsLogged ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: 'steps',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.outline.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_stepsLogged >= 500) {
                          setState(() => _stepsLogged -= 500);
                        }
                      },
                      child: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.outline, size: 20),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => _stepsLogged += 500);
                      },
                      child: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Water Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBEEF1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Drink\nWater',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_waterLogged < 20) {
                          setState(() => _waterLogged++);
                        }
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3F2FD),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: AppColors.blue,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(
                        text: '$_waterLogged ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: 'glass',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.outline.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_waterLogged > 0) {
                          setState(() => _waterLogged--);
                        }
                      },
                      child: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.outline, size: 20),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (_waterLogged < 20) {
                          setState(() => _waterLogged++);
                        }
                      },
                      child: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Weekly Calendar Slider Row ────────────────────────────────────────────
  Widget _buildWeeklyCalendarSlider() {
    final now = DateTime.now();
    final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final sundayOfThisWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));
    
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final currentMonthStr = '${months[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEBEEF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentMonthStr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Row(
                children: [
                  _buildCalArrow(Icons.chevron_left_rounded, () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildCalArrow(Icons.chevron_right_rounded, () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 7));
                    });
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final date = sundayOfThisWeek.add(Duration(days: i));
              final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
              final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month && date.year == _selectedDate.year;
              final dayLabel = weekDays[i];
              final dateLabel = date.day.toString().padLeft(2, '0');

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEAF2FF) : Colors.transparent, // Soft light blue highlight for selected
                      borderRadius: BorderRadius.circular(16),
                      border: isToday && !isSelected
                          ? Border.all(color: const Color(0xFFEAF2FF), width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? const Color(0xFF0050CB) : AppColors.outline,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? const Color(0xFF003D9E) : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCalArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F5FC),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.onSurfaceVariant, size: 18),
      ),
    );
  }

  // ── Dynamic Daily Meal Row Item ───────────────────────────────────────────
  Widget _buildMealCardItem({
    required String title,
    required String subtitle,
    required List<Food> foods,
    required String defaultKcalRange,
    required String mealType,
  }) {
    final double totalCalories = foods.fold(0.0, (sum, f) => sum + f.calories);
    final String calorieStr = totalCalories > 0
        ? '${totalCalories.round()} kcal'
        : defaultKcalRange;
    final bool hasFoods = foods.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEEF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFF8F00),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  calorieStr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasFoods) ...[
                SizedBox(
                  width: 50,
                  height: 32,
                  child: Stack(
                    children: List.generate(math.min(foods.length, 2), (idx) {
                      final f = foods[idx];
                      return Positioned(
                        left: idx * 16.0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: f.imageAsset != null
                                ? Image.network(
                                    f.imageAsset!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => _buildSmallMealIconFallback(),
                                  )
                                : _buildSmallMealIconFallback(),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodSearchScreen(
                        mealType: mealType,
                        selectedDate: _selectedDate,
                      ),
                    ),
                  );
                  if (result == true && mounted) {
                    setState(() {}); // Refresh state
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F5FC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.onSurface,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMealIconFallback() {
    return Container(
      color: const Color(0xFFEBEEF1),
      child: const Icon(
        Icons.restaurant_outlined,
        color: AppColors.outline,
        size: 12,
      ),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────

  List<_MacroData> _getMacros() {
    final profile = StorageService.getUserProfile();
    final loggedMeals = StorageService.getMeals().where((m) => _isSameDay(m.date, _selectedDate)).toList();

    double consumedCarbs = 0;
    double consumedFat = 0;
    double consumedProtein = 0;

    for (final meal in loggedMeals) {
      consumedCarbs += meal.totalCarbs;
      consumedFat += meal.totalFat;
      consumedProtein += meal.totalProtein;
    }

    if (profile == null) {
      return [
        _MacroData('Carbs', consumedCarbs.round(), 165, AppColors.teal),
        _MacroData('Fat', consumedFat.round(), 65, AppColors.purple),
        _MacroData('Protein', consumedProtein.round(), 85, AppColors.gold),
      ];
    }

    final carbTarget = MacroService.carbGoal(profile).round();
    final fatTarget = CalorieService.fatGoal(profile).round();
    final proteinTarget = CalorieService.proteinGoal(profile).round();

    return [
      _MacroData('Carbs', consumedCarbs.round(), carbTarget, AppColors.teal),
      _MacroData('Fat', consumedFat.round(), fatTarget, AppColors.purple),
      _MacroData('Protein', consumedProtein.round(), proteinTarget, AppColors.gold),
    ];
  }



  // ── Macros Card ────────────────────────────────────────────────────────────
  Widget _buildMacrosCard() {
    final profile = StorageService.getUserProfile();
    final loggedMeals = StorageService.getMeals().where((m) => _isSameDay(m.date, _selectedDate)).toList();

    double consumedCarbs = 0;
    double consumedFat = 0;
    double consumedProtein = 0;

    for (final meal in loggedMeals) {
      consumedCarbs += meal.totalCarbs;
      consumedFat += meal.totalFat;
      consumedProtein += meal.totalProtein;
    }

    final carbTarget = profile != null ? MacroService.carbGoal(profile) : 220.0;
    final fatTarget = profile != null ? CalorieService.fatGoal(profile) : 70.0;
    final proteinTarget = profile != null ? CalorieService.proteinGoal(profile) : 140.0;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                _macroPage == 0
                    ? 'Macros Summary'
                    : _macroPage == 1
                        ? 'Carbs Breakdown'
                        : _macroPage == 2
                            ? 'Protein Breakdown'
                            : 'Fats Breakdown',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              const Icon(Icons.swap_horizontal_circle_outlined, color: AppColors.primaryContainer, size: 20),
            ],
          ),
          const SizedBox(height: 16),

          // Swipable PageView
          SizedBox(
            height: 155,
            child: PageView(
              controller: _macroPageCtrl,
              onPageChanged: (page) {
                setState(() {
                  _macroPage = page;
                });
              },
              children: [
                _buildMacroSummaryPage(),
                _buildCarbsBreakdownPage(consumedCarbs, carbTarget),
                _buildProteinBreakdownPage(consumedProtein, proteinTarget),
                _buildFatBreakdownPage(consumedFat, fatTarget),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Dot indicator with tap navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final active = i == _macroPage;
              return GestureDetector(
                onTap: () {
                  _macroPageCtrl.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 10 : 8,
                  height: active ? 10 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? AppColors.primaryContainer : AppColors.outlineVariant,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroSummaryPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _getMacros().map((m) => _buildMacroRing(m)).toList(),
    );
  }

  Widget _buildCarbsBreakdownPage(double consumedCarbs, double targetCarbs) {
    final netCarbs = (consumedCarbs * 0.75).round();
    final fiber = (consumedCarbs * 0.15).round();
    final sugar = (consumedCarbs * 0.10).round();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBreakdownRow('Net Carbohydrates', '$netCarbs g', consumedCarbs / (targetCarbs > 0 ? targetCarbs : 1.0), AppColors.teal),
        const SizedBox(height: 10),
        _buildBreakdownRow('Dietary Fiber', '$fiber g', 0.45, AppColors.teal.withValues(alpha: 0.7)),
        const SizedBox(height: 10),
        _buildBreakdownRow('Active Sugars', '$sugar g', 0.15, Colors.redAccent),
      ],
    );
  }

  Widget _buildProteinBreakdownPage(double consumedProtein, double targetProtein) {
    final leanMeats = (consumedProtein * 0.60).round();
    final dairyWhey = (consumedProtein * 0.25).round();
    final plantProtein = (consumedProtein * 0.15).round();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBreakdownRow('Lean Meats / Poultry', '$leanMeats g', consumedProtein / (targetProtein > 0 ? targetProtein : 1.0), AppColors.gold),
        const SizedBox(height: 10),
        _buildBreakdownRow('Dairy / Whey Protein', '$dairyWhey g', 0.50, AppColors.gold.withValues(alpha: 0.7)),
        const SizedBox(height: 10),
        _buildBreakdownRow('Plant Protein (Legumes)', '$plantProtein g', 0.30, Colors.green),
      ],
    );
  }

  Widget _buildFatBreakdownPage(double consumedFat, double targetFat) {
    final saturated = (consumedFat * 0.35).round();
    final monounsaturated = (consumedFat * 0.45).round();
    final polyunsaturated = (consumedFat * 0.20).round();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBreakdownRow('Monounsaturated (Healthy)', '$monounsaturated g', consumedFat / (targetFat > 0 ? targetFat : 1.0), AppColors.purple),
        const SizedBox(height: 10),
        _buildBreakdownRow('Polyunsaturated', '$polyunsaturated g', 0.40, AppColors.purple.withValues(alpha: 0.7)),
        const SizedBox(height: 10),
        _buildBreakdownRow('Saturated Fats', '$saturated g', 0.25, Colors.amber),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: const Color(0xFFE8ECF0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroRing(_MacroData m) {
    final progress = (m.current / m.goal).clamp(0.0, 1.0);
    final remaining = m.goal - m.current;

    return Column(
      children: [
        // Label
        Text(
          m.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: m.color,
          ),
        ),
        const SizedBox(height: 6),
        // Ring
        AnimatedBuilder(
          animation: _ringAnim,
          builder: (_, _) => SizedBox(
            width: 76,
            height: 76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(76, 76),
                  painter: _SingleRingPainter(
                    progress: progress * _ringAnim.value,
                    color: m.color,
                    trackColor: const Color(0xFFE8ECF0),
                    strokeWidth: 8,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${m.current}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      '/${m.goal}g',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${remaining}g left',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }



  // ── Search Bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () async {
        final reloaded = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodSearchScreen(
              mealType: 'Breakfast',
              selectedDate: _selectedDate,
            ),
          ),
        );
        if (reloaded == true && mounted) {
          setState(() {});
        }
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            const Icon(Icons.search_rounded, color: AppColors.outline, size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Search for a food',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.outline,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primaryContainer,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Navigation ──────────────────────────────────────────────────────
}

// ── Reusable Card ─────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Single Ring Painter ───────────────────────────────────────────────────────
class _SingleRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _SingleRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SingleRingPainter old) =>
      old.progress != progress || old.color != color;
}



// ── Data Models ───────────────────────────────────────────────────────────────
class _MacroData {
  final String name;
  final int current;
  final int goal;
  final Color color;
  const _MacroData(this.name, this.current, this.goal, this.color);
}
