import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:macroverse/widgets/bottom_navigation.dart';
import 'package:macroverse/widgets/custom_appbar.dart';

import '../constants/app_colors.dart';
import '../models/food_model.dart';
import '../services/calorie_service.dart';
import '../services/macro_service.dart';
import '../services/storage_service.dart';
import 'food_search_screen.dart';

// ── Diary Screen ──────────────────────────────────────────────────────────────
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  
  Future<void> _navigateToAddFood(String mealType) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodSearchScreen(mealType: mealType),
      ),
    );
    if (result == true && mounted) {
      setState(() {}); // Refresh meal log state
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch dynamic profile & baseline limits
    final profile = StorageService.getUserProfile();
    final targetKcal = profile != null ? CalorieService.calculateTargetCalories(profile) : 2400.0;
    final carbTarget = profile != null ? MacroService.carbGoal(profile) : 220.0;
    final proteinTarget = profile != null ? CalorieService.proteinGoal(profile) : 140.0;
    final fatTarget = profile != null ? CalorieService.fatGoal(profile) : 70.0;

    // 2. Fetch logged meals & aggregate metrics
    final loggedMeals = StorageService.getMeals();
    double consumedKcal = 0.0;
    double consumedCarbs = 0.0;
    double consumedProtein = 0.0;
    double consumedFat = 0.0;

    for (final meal in loggedMeals) {
      consumedKcal += meal.totalCalories;
      consumedCarbs += meal.totalCarbs;
      consumedProtein += meal.totalProtein;
      consumedFat += meal.totalFat;
    }

    const exerciseKcal = 210.0; // Keep exercise static for this view
    final remainingKcal = targetKcal - consumedKcal + exerciseKcal;
    final calorieProgress = (consumedKcal / targetKcal).clamp(0.0, 1.0);

    final carbsProgress = carbTarget > 0 ? (consumedCarbs / carbTarget).clamp(0.0, 1.0) : 0.0;
    final proteinProgress = proteinTarget > 0 ? (consumedProtein / proteinTarget).clamp(0.0, 1.0) : 0.0;
    final fatProgress = fatTarget > 0 ? (consumedFat / fatTarget).clamp(0.0, 1.0) : 0.0;

    // 3. Segment food lists
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
                    const CustomTopBar(),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCalorieCard(
                            target: targetKcal.round(),
                            consumed: consumedKcal.round(),
                            exercise: exerciseKcal.round(),
                            remaining: remainingKcal.round(),
                            progress: calorieProgress,
                          ),
                          const SizedBox(height: 16),
                          _buildMacroRow(
                            carbsVal: '${consumedCarbs.round()}g',
                            carbsProg: carbsProgress,
                            proteinVal: '${consumedProtein.round()}g',
                            proteinProg: proteinProgress,
                            fatVal: '${consumedFat.round()}g',
                            fatProg: fatProgress,
                          ),
                          const SizedBox(height: 24),
                          _buildMealsSectionHeader(),
                          const SizedBox(height: 12),
                          
                          // Breakfast Card
                          _buildMealCardSection(
                            title: 'Breakfast',
                            foods: breakfastList,
                            recommended: '400–550 kcal',
                          ),
                          const SizedBox(height: 16),
                          
                          // Lunch Card
                          _buildMealCardSection(
                            title: 'Lunch',
                            foods: lunchList,
                            recommended: '600–750 kcal',
                          ),
                          const SizedBox(height: 16),
                          
                          // Dinner Card
                          _buildMealCardSection(
                            title: 'Dinner',
                            foods: dinnerList,
                            recommended: '700–900 kcal',
                          ),
                          const SizedBox(height: 16),

                          // Snack Card
                          _buildMealCardSection(
                            title: 'Snacks',
                            foods: snackList,
                            recommended: '200–350 kcal',
                          ),
                          const SizedBox(height: 16),
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
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 1),
    );
  }

  // ── Calorie Ring Card ──────────────────────────────────────────────────────
  Widget _buildCalorieCard({
    required int target,
    required int consumed,
    required int exercise,
    required int remaining,
    required double progress,
  }) {
    return _Card(
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(180, 180),
                  painter: _RingPainter(
                    progress: progress,
                    trackColor: const Color(0xFFE8ECF0),
                    fillColor: AppColors.primaryContainer,
                    strokeWidth: 14,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      remaining.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (m) => '${m[1]},',
                      ),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'kcal remaining',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEBEEF1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _calStat('Goal', target.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'), AppColors.onSurface),
              _calDivider(),
              _calStat('Food', consumed.toString(), AppColors.onSurface),
              _calDivider(),
              _calStat('Exercise', '+$exercise', const Color(0xFFFFB800)),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _calStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _calDivider() =>
      Container(width: 1, height: 32, color: AppColors.outlineVariant);

  // ── Macro Row ──────────────────────────────────────────────────────────────
  Widget _buildMacroRow({
    required String carbsVal,
    required double carbsProg,
    required String proteinVal,
    required double proteinProg,
    required String fatVal,
    required double fatProg,
  }) {
    return Row(
      children: [
        Expanded(
          child: _MacroCard(
            label: 'Carbs',
            value: carbsVal,
            progress: carbsProg,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MacroCard(
            label: 'Protein',
            value: proteinVal,
            progress: proteinProg,
            color: AppColors.teal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MacroCard(
            label: 'Fat',
            value: fatVal,
            progress: fatProg,
            color: AppColors.amber,
          ),
        ),
      ],
    );
  }

  // ── Meals Section Header ───────────────────────────────────────────────────
  Widget _buildMealsSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's Meals",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEEF8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'Today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Meal Card Dynamic Section ──────────────────────────────────────────────
  Widget _buildMealCardSection({
    required String title,
    required List<Food> foods,
    required String recommended,
  }) {
    if (foods.isEmpty) {
      return _buildEmptyMealCard(title);
    }

    final totalKcal = foods.fold(0, (sum, f) => sum + f.calories.round());
    final totalCarbs = foods.fold(0, (sum, f) => sum + f.carbs.round());
    final totalProtein = foods.fold(0, (sum, f) => sum + f.protein.round());

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Recommended: $recommended',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalKcal kcal',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _macroChip('C: ${totalCarbs}g'),
                      const SizedBox(width: 6),
                      _macroChip('P: ${totalProtein}g'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEBEEF1)),
          const SizedBox(height: 10),
          ...foods.map((f) => _buildFoodRow(f)),
          const SizedBox(height: 8),
          _buildAddFoodButton(title),
        ],
      ),
    );
  }

  Widget _macroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEEF8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildFoodRow(Food food) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: food.imageAsset != null
                ? Image.network(
                    food.imageAsset!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildFoodRowFallbackIcon(),
                  )
                : _buildFoodRowFallbackIcon(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${food.servingSize.round()}g portion',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${food.calories.round()} kcal',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodRowFallbackIcon() {
    return Container(
      width: 44,
      height: 44,
      color: const Color(0xFFEBEEF1),
      child: const Icon(
        Icons.restaurant_outlined,
        color: AppColors.outline,
        size: 20,
      ),
    );
  }

  Widget _buildAddFoodButton(String mealType) {
    return GestureDetector(
      onTap: () => _navigateToAddFood(mealType),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: AppColors.primary, size: 18),
            SizedBox(width: 6),
            Text(
              'Add Food',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty Meal Card ────────────────────────────────────────────────────────
  Widget _buildEmptyMealCard(String title) {
    return _Card(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFEBEEF1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu_outlined,
              color: AppColors.outline,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You haven't logged $title yet.\nStay on track!",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.outline,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () => _navigateToAddFood(title),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Add Meal',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
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

// ── Macro Card ────────────────────────────────────────────────────────────────
class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Vertical progress bar
          SizedBox(
            height: 56,
            width: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: RotatedBox(
                quarterTurns: 2,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE0E3E6),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ring Painter ──────────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color fillColor;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Track (full circle)
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc — starts from top (-π/2), goes clockwise
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.fillColor != fillColor ||
      old.trackColor != trackColor;
}
