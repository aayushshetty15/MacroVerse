import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────

class AppTextStyles {
  static const displayLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.64,
    color: AppColors.onSurface,
  );
  static const headlineMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.24,
    color: AppColors.onSurface,
  );
  static const headlineSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.onSurface,
  );
  static const bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurface,
  );
  static const labelMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    color: AppColors.onSurface,
  );
  static const labelSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.onSurfaceVariant,
  );
  static const dataLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.27,
    color: AppColors.primaryContainer,
  );
}

class RecentFood {
  final String name;
  final String subtitle;
  final int kcal;
  final String imageAsset; // use a placeholder network image

  const RecentFood({
    required this.name,
    required this.subtitle,
    required this.kcal,
    required this.imageAsset,
  });
}

class FrequentMeal {
  final String name;
  final int kcal;
  final String imageAsset;

  const FrequentMeal({
    required this.name,
    required this.kcal,
    required this.imageAsset,
  });
}

const recentFoods = [
  RecentFood(
    name: 'Sourdough Avocado Toast',
    subtitle: '2 slices • 180g',
    kcal: 342,
    imageAsset:
        'https://images.unsplash.com/photo-1541519227354-08fa5d50c820?w=120&q=80',
  ),
  RecentFood(
    name: 'Greek Feta Salad',
    subtitle: 'Large bowl • 350g',
    kcal: 285,
    imageAsset:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=120&q=80',
  ),
  RecentFood(
    name: 'Grilled Chicken Breast',
    subtitle: 'Skinless • 200g',
    kcal: 310,
    imageAsset:
        'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=120&q=80',
  ),
];

const frequentMeals = [
  FrequentMeal(
    name: 'Power Protein Bowl',
    kcal: 540,
    imageAsset:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=80',
  ),
  FrequentMeal(
    name: 'Green Detox Shake',
    kcal: 210,
    imageAsset:
        'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=300&q=80',
  ),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  int _selectedTab = 1; // Diary is active
  int _selectedFilter = 0; // Recent, Frequent, My Meals

  final List<String> _filterLabels = ['Recent', 'Frequent', 'My Meals'];
  final List<IconData> _filterIcons = [
    Icons.history_rounded,
    Icons.star_border_rounded,
    Icons.restaurant_menu_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildFilterChips(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Recent Foods', onViewAll: () {}),
                    const SizedBox(height: 12),
                    _buildRecentFoodsList(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Frequent Meals'),
                    const SizedBox(height: 12),
                    _buildFrequentMealsGrid(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildScanFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF0050CB), Color(0xFF003FA4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'MacroVerse',
            style: AppTextStyles.headlineSm.copyWith(fontSize: 22),
          ),
          const Spacer(),
          // Bell icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurface,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search food, brands, or recipes...',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter Chips ─────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _filterLabels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _filterIcons[i],
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _filterLabels[i],
                    style: AppTextStyles.labelMd.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.headlineSm),
          const Spacer(),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View All',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  // ── Recent Foods List ────────────────────────────────────────────────────

  Widget _buildRecentFoodsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recentFoods.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _RecentFoodCard(food: recentFoods[i]),
    );
  }

  // ── Frequent Meals Grid ──────────────────────────────────────────────────

  Widget _buildFrequentMealsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: frequentMeals
            .map(
              (meal) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: meal == frequentMeals.last ? 0 : 12,
                  ),
                  child: _FrequentMealCard(meal: meal),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Bottom Navigation ────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    final items = [
      (Icons.grid_view_rounded, 'Dashboard'),
      (Icons.menu_book_rounded, 'Diary'),
      (Icons.chat_bubble_outline_rounded, 'Newsfeed'),
      (Icons.assignment_outlined, 'Plans'),
      (Icons.more_horiz_rounded, 'More'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = i == _selectedTab;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        items[i].$1,
                        color: Colors.white.withValues(
                          alpha: isActive ? 1.0 : 0.65,
                        ),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[i].$2,
                      style: AppTextStyles.labelSm.copyWith(
                        color: Colors.white.withValues(
                          alpha: isActive ? 1.0 : 0.65,
                        ),
                        fontSize: 11,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ── Scan FAB ─────────────────────────────────────────────────────────────

  Widget _buildScanFab() {
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.only(bottom: 70, right: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryContainer.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.qr_code_scanner_rounded,
        color: AppColors.secondary,
        size: 26,
      ),
    );
  }
}

// ─── Recent Food Card ─────────────────────────────────────────────────────────

class _RecentFoodCard extends StatelessWidget {
  final RecentFood food;
  const _RecentFoodCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              food.imageAsset,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 64,
                height: 64,
                color: AppColors.surfaceContainerLow,
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.outlineVariant,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Name & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: AppTextStyles.labelMd.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(food.subtitle, style: AppTextStyles.labelSm),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Calories
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${food.kcal}', style: AppTextStyles.dataLg),
              Text(
                'kcal',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Frequent Meal Card ───────────────────────────────────────────────────────

class _FrequentMealCard extends StatelessWidget {
  final FrequentMeal meal;
  const _FrequentMealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 1.15,
            child: Image.network(
              meal.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.surfaceContainerLow,
                child: const Icon(
                  Icons.fastfood_rounded,
                  color: AppColors.outlineVariant,
                  size: 36,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: AppTextStyles.labelMd.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${meal.kcal} kcal',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
