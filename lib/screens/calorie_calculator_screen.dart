import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:macroverse/widgets/bottom_navigation.dart';
import 'package:macroverse/widgets/custom_appbar.dart';
import 'package:macroverse/services/storage_service.dart';

import '../constants/app_colors.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────

// ── Calorie Engine Screen ─────────────────────────────────────────────────────
class CalorieEngineScreen extends StatefulWidget {
  const CalorieEngineScreen({super.key});

  @override
  State<CalorieEngineScreen> createState() => _CalorieEngineScreenState();
}

class _CalorieEngineScreenState extends State<CalorieEngineScreen>
    with SingleTickerProviderStateMixin {
  // State
  bool _isMale = true;
  double _weight = 75;
  double _height = 180;
  double _age = 28;
  double _activityLevel = 0.45; // 0=Sedentary … 1=Athlete

  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;

  // Derived values
  int get _bmr {
    if (_isMale) {
      return (10 * _weight + 6.25 * _height - 5 * _age + 5).round();
    } else {
      return (10 * _weight + 6.25 * _height - 5 * _age - 161).round();
    }
  }

  double get _activityMultiplier {
    // Sedentary 1.2 → Athlete 1.9
    return 1.2 + _activityLevel * 0.7;
  }

  int get _maintenance => (_bmr * _activityMultiplier).round();
  int get _activityOffset => _maintenance - _bmr;

  String get _activityLabel {
    if (_activityLevel < 0.20) return 'Sedentary';
    if (_activityLevel < 0.40) return 'Light';
    if (_activityLevel < 0.60) return 'Moderate';
    if (_activityLevel < 0.80) return 'Active';
    return 'Athlete';
  }

  String get _activityDescription {
    if (_activityLevel < 0.20) return '"Little or no exercise."';
    if (_activityLevel < 0.40) return '"Light exercise 1-3 days per week."';
    if (_activityLevel < 0.60) return '"Moderate exercise 3-5 days per week."';
    if (_activityLevel < 0.80) return '"Hard exercise 6-7 days per week."';
    return '"Very hard exercise & physical job."';
  }

  // Ring progress: efficiency score 0–1
  double get _efficiencyProgress {
    // Peaks at moderate activity ~0.45
    return (1 - ((_activityLevel - 0.45).abs() * 1.6)).clamp(0.3, 1.0);
  }

  @override
  void initState() {
    super.initState();
    final profile = StorageService.getUserProfile();
    if (profile != null) {
      _isMale = profile.gender.toLowerCase() == 'male';
      _weight = profile.weight;
      _height = profile.height;
      _age = profile.age.toDouble();
      
      if (profile.activityLevel == 'Sedentary') {
        _activityLevel = 0.1;
      } else if (profile.activityLevel == 'Lightly Active') {
        _activityLevel = 0.3;
      } else if (profile.activityLevel == 'Moderately Active') {
        _activityLevel = 0.5;
      } else if (profile.activityLevel == 'Very Active') {
        _activityLevel = 0.7;
      } else if (profile.activityLevel == 'Extra Active') {
        _activityLevel = 0.9;
      }
    }

    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _buildPageHeader(),
                          const SizedBox(height: 20),
                          _buildMaintenanceCard(),
                          const SizedBox(height: 16),
                          _buildBiometricsCard(),
                          const SizedBox(height: 16),
                          _buildActivityCard(),
                          const SizedBox(height: 16),
                          _buildEfficiencyCard(),
                          const SizedBox(height: 20),
                          _buildSaveButton(),
                          const SizedBox(height: 8),
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
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 2),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────

  // ── Page Header ────────────────────────────────────────────────────────────
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Calorie Engine',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Calculate your metabolic baseline and daily\nenergy expenditure with precision.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Daily Maintenance Card ─────────────────────────────────────────────────
  Widget _buildMaintenanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565E8), Color(0xFF0044BB)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAILY MAINTENANCE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xAAFFFFFF),
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatNumber(_maintenance),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'kcal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xCCFFFFFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatNumber(_bmr),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'BMR (Base)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xAAFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withValues(alpha: 0.25),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+${_formatNumber(_activityOffset)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Activity Offset',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xAAFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Biometrics Card ────────────────────────────────────────────────────────
  Widget _buildBiometricsCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: const [
              Icon(
                Icons.person_outline_rounded,
                color: AppColors.primaryContainer,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Biometrics',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gender toggle
          Row(
            children: [
              Expanded(child: _genderButton(label: 'Male', isMale: true)),
              const SizedBox(width: 12),
              Expanded(child: _genderButton(label: 'Female', isMale: false)),
            ],
          ),
          const SizedBox(height: 16),

          // Weight & Height
          Row(
            children: [
              Expanded(
                child: _numericField(
                  label: 'Weight (kg)',
                  value: _weight.round().toString(),
                  onDecrease: () =>
                      setState(() => _weight = (_weight - 1).clamp(30, 200)),
                  onIncrease: () =>
                      setState(() => _weight = (_weight + 1).clamp(30, 200)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _numericField(
                  label: 'Height (cm)',
                  value: _height.round().toString(),
                  onDecrease: () =>
                      setState(() => _height = (_height - 1).clamp(100, 250)),
                  onIncrease: () =>
                      setState(() => _height = (_height + 1).clamp(100, 250)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Age
          _numericField(
            label: 'Age (years)',
            value: _age.round().toString(),
            onDecrease: () => setState(() => _age = (_age - 1).clamp(10, 100)),
            onIncrease: () => setState(() => _age = (_age + 1).clamp(10, 100)),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _genderButton({required String label, required bool isMale}) {
    final selected = _isMale == isMale;
    return GestureDetector(
      onTap: () => setState(() => _isMale = isMale),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAEEFF) : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primaryContainer : AppColors.outlineVariant,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isMale ? Icons.male_rounded : Icons.female_rounded,
              color: selected ? AppColors.primaryContainer : AppColors.outline,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numericField({
    required String label,
    required String value,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
    bool fullWidth = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onDecrease,
                child: const Icon(
                  Icons.remove_rounded,
                  color: AppColors.outlineVariant,
                  size: 18,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryContainer,
                ),
              ),
              GestureDetector(
                onTap: onIncrease,
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.outlineVariant,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Activity Level Card ────────────────────────────────────────────────────
  Widget _buildActivityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: Color(0xFFE09B00),
                size: 22,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Activity Level',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFB0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _activityLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C5800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: AppColors.primaryContainer,
              inactiveTrackColor: AppColors.outlineVariant,
              thumbColor: AppColors.primaryContainer,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              overlayColor: AppColors.primaryContainer.withValues(alpha: 0.15),
            ),
            child: Slider(
              value: _activityLevel,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _activityLevel = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Sedentary',
                  style: TextStyle(fontSize: 11, color: AppColors.outline),
                ),
                Text(
                  'Athlete',
                  style: TextStyle(fontSize: 11, color: AppColors.outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Description
          Text(
            _activityDescription,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Efficiency Card ────────────────────────────────────────────────────────
  Widget _buildEfficiencyCard() {
    return _Card(
      child: Row(
        children: [
          // Animated gold ring with icon
          AnimatedBuilder(
            animation: _ringAnim,
            builder: (_, _) => SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(80, 80),
                    painter: _ArcRingPainter(
                      progress: _efficiencyProgress * _ringAnim.value,
                      color: AppColors.amber,
                      trackColor: const Color(0xFFE8ECF0),
                      strokeWidth: 7,
                    ),
                  ),
                  const Icon(
                    Icons.fitness_center_rounded,
                    color: AppColors.amber,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'EFFICIENCY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.outline,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Optimal Range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.trending_up_rounded, color: AppColors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Metabolism Peak',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Save Button ────────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          final profile = StorageService.getUserProfile();
          if (profile != null) {
            String actLevel = 'Moderately Active';
            if (_activityLevel < 0.20) {
              actLevel = 'Sedentary';
            } else if (_activityLevel < 0.40) {
              actLevel = 'Lightly Active';
            } else if (_activityLevel < 0.60) {
              actLevel = 'Moderately Active';
            } else if (_activityLevel < 0.80) {
              actLevel = 'Very Active';
            } else {
              actLevel = 'Extra Active';
            }

            final updated = profile.copyWith(
              gender: _isMale ? 'Male' : 'Female',
              weight: _weight,
              height: _height,
              age: _age.round(),
              activityLevel: actLevel,
            );
            await StorageService.saveUserProfile(updated);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Biometrics updated successfully!'),
                  backgroundColor: AppColors.primaryContainer,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please complete onboarding first!'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Save Metric History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ── Bottom Navigation ──────────────────────────────────────────────────────

  String _formatNumber(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
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

// ── Arc Ring Painter ──────────────────────────────────────────────────────────
class _ArcRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _ArcRingPainter({
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
  bool shouldRepaint(_ArcRingPainter old) =>
      old.progress != progress || old.color != color;
}
