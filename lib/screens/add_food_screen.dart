import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

// ── Design Tokens ────────────────────────────────────────────────────────────

// ── Food Details Screen ───────────────────────────────────────────────────────
class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _servings = 1;
  int _selectedMealIdx = 0;
  bool _isFavorited = false;
  String _selectedServing = '1 Bowl (350g)';
  bool _showServingDropdown = false;

  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;

  // Base macros per serving
  static const int _baseKcal = 480;
  static const int _baseProtein = 35;
  static const int _baseCarbs = 15;
  static const int _baseFat = 10;

  int get _totalKcal => _baseKcal * _servings;
  int get _totalProtein => _baseProtein * _servings;
  int get _totalCarbs => _baseCarbs * _servings;
  int get _totalFat => _baseFat * _servings;

  final _meals = ['Lunch', 'Dinner', 'Snack', 'Breakfast'];
  final _servingOptions = ['1 Bowl (350g)', '½ Bowl (175g)', '2 Bowls (700g)'];

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic);
    _ringCtrl.forward();
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Scrollable content ──
          CustomScrollView(
            slivers: [
              _buildHeroSliver(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMacroRingCard(),
                      const SizedBox(height: 16),
                      _buildPortionCard(),
                      const SizedBox(height: 16),
                      _buildMicronutrientsCard(),
                      // Space for bottom bar
                      const SizedBox(height: 160),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  // ── Hero Sliver ────────────────────────────────────────────────────────────
  Widget _buildHeroSliver() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.onSurface,
            size: 20,
          ),
        ),
      ),
      title: const Text(
        'Food Details',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () => setState(() => _isFavorited = !_isFavorited),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isFavorited
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorited ? Colors.redAccent : AppColors.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            child: const Icon(
              Icons.content_paste_rounded,
              color: AppColors.onSurface,
              size: 18,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Teal placeholder image background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3AADA0), Color(0xFF1E7A70)],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.restaurant_rounded,
                  color: Color(0x44FFFFFF),
                  size: 80,
                ),
              ),
            ),
            // Bottom gradient + title
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xDD000000), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Grilled Salmon Bowl',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Fresh Nordic Kitchen  •  480 kcal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xCCFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Macro Ring Card ────────────────────────────────────────────────────────
  Widget _buildMacroRingCard() {
    return _Card(
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Ring with animated segments
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _ringAnim,
                  builder: (_, _) => CustomPaint(
                    size: const Size(140, 140),
                    painter: _MacroRingPainter(
                      progress: _ringAnim.value,
                      proteinFrac:
                          _totalProtein /
                          (_totalProtein + _totalCarbs + _totalFat),
                      carbsFrac:
                          _totalCarbs /
                          (_totalProtein + _totalCarbs + _totalFat),
                      fatFrac:
                          _totalFat / (_totalProtein + _totalCarbs + _totalFat),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_totalKcal',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.1,
                      ),
                    ),
                    const Text(
                      'KCAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Macro labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _macroLabel('Protein', '${_totalProtein}g', AppColors.teal),
              _macroLabel('Carbs', '${_totalCarbs}g', AppColors.amber),
              _macroLabel('Fat', '${_totalFat}g', AppColors.primaryContainer),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _macroLabel(String name, String value, Color color) {
    return Column(
      children: [
        Text(
          name,
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  // ── Portion Details Card ───────────────────────────────────────────────────
  Widget _buildPortionCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PORTION DETAILS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.outline,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          // Serving Size dropdown
          const Text(
            'Serving Size',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () =>
                setState(() => _showServingDropdown = !_showServingDropdown),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedServing,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    _showServingDropdown
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.outline,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Dropdown options
          if (_showServingDropdown)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: _servingOptions.map((opt) {
                  final selected = opt == _selectedServing;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedServing = opt;
                      _showServingDropdown = false;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFEAF0FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? AppColors.primaryContainer
                                    : AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (selected)
                            const Icon(
                              Icons.check_rounded,
                              color: AppColors.primaryContainer,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 16),

          // Number of Servings stepper
          const Text(
            'Number of Servings',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _servings > 1
                      ? () => setState(() => _servings--)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                  color: AppColors.primaryContainer,
                  disabledColor: AppColors.outlineVariant,
                  iconSize: 22,
                ),
                Text(
                  '$_servings',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _servings++),
                  icon: const Icon(Icons.add_rounded),
                  color: AppColors.primaryContainer,
                  iconSize: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Micronutrients Card ────────────────────────────────────────────────────
  Widget _buildMicronutrientsCard() {
    final micros = [
      _Micro('Dietary Fiber', '${6 * _servings}g'),
      _Micro('Sodium', '${420 * _servings}mg'),
      _Micro('Sugars', '${4 * _servings}g'),
      _Micro('Cholesterol', '${55 * _servings}mg'),
    ];

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MICRONUTRIENTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.outline,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(micros.length, (i) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        micros[i].name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        micros[i].value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < micros.length - 1)
                  Divider(
                    height: 1,
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── Bottom Bar ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors    .surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Meal selector chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _meals.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final active = i == _selectedMealIdx;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMealIdx = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primaryContainer
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(99),
                          border: active
                              ? null
                              : Border.all(color: AppColors.outlineVariant, width: 1),
                        ),
                        child: Text(
                          _meals[i],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: active ? Colors.white : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Total entry + Add to Diary
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Entry',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.outline,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$_totalKcal kcal',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          size: 20,
                        ),
                        label: const Text(
                          'Add to Diary',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

// ── Macro Ring Painter ────────────────────────────────────────────────────────
// Three-segment arc: teal=protein, amber=carbs, blue=fat + grey track
class _MacroRingPainter extends CustomPainter {
  final double progress;
  final double proteinFrac;
  final double carbsFrac;
  final double fatFrac;

  const _MacroRingPainter({
    required this.progress,
    required this.proteinFrac,
    required this.carbsFrac,
    required this.fatFrac,
  });

  static const _strokeWidth = 12.0;
  static const _gap = 0.03; // radians gap between segments

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - _strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFFE8ECF0)
        ..strokeWidth = _strokeWidth
        ..style = PaintingStyle.stroke,
    );

    // Segments colours
    final segments = [
      (proteinFrac, const Color(0xFF008072)), // teal – protein
      (carbsFrac, const Color(0xFFFFBA20)), // amber – carbs
      (fatFrac, const Color(0xFF0066FF)), // blue  – fat
    ];

    double startAngle = -math.pi / 2;
    final total = 2 * math.pi * progress;

    for (final seg in segments) {
      final sweep = seg.$1 * total - _gap;
      if (sweep > 0) {
        canvas.drawArc(
          rect,
          startAngle,
          sweep,
          false,
          Paint()
            ..color = seg.$2
            ..strokeWidth = _strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
      startAngle += seg.$1 * total;
    }
  }

  @override
  bool shouldRepaint(_MacroRingPainter old) =>
      old.progress != progress ||
      old.proteinFrac != proteinFrac ||
      old.carbsFrac != carbsFrac ||
      old.fatFrac != fatFrac;
}

// ── Data models ───────────────────────────────────────────────────────────────
class _Micro {
  final String name;
  final String value;
  const _Micro(this.name, this.value);
}
