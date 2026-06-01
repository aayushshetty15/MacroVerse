import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macroverse/constants/app_colors.dart';
import 'package:macroverse/models/userprofile_model.dart';
import 'package:macroverse/services/storage_service.dart';
import 'package:macroverse/screens/dashboard_screen.dart';

class AppTextStyles {
  static const headlineLgMobile = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    color: AppColors.onSurface,
  );
  static const bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurfaceVariant,
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
}

// ─── Data Model ───────────────────────────────────────────────────────────────

class GoalOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const GoalOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

const goalOptions = [
  GoalOption(
    title: 'Lose Weight',
    subtitle: 'Fat loss & definition',
    icon: Icons.trending_down_rounded,
    bgColor: AppColors.goalPurpleBg,
    iconColor: AppColors.goalPurpleIcon,
  ),
  GoalOption(
    title: 'Maintain Weight',
    subtitle: 'Balance & performance',
    icon: Icons.balance_rounded,
    bgColor: AppColors.goalAmberBg,
    iconColor: AppColors.goalAmberIcon,
  ),
  GoalOption(
    title: 'Gain Muscle',
    subtitle: 'Hypertrophy & strength',
    icon: Icons.fitness_center_rounded,
    bgColor: AppColors.goalTealBg,
    iconColor: AppColors.goalTealIcon,
  ),
];

class OnboardingStep3Screen extends StatefulWidget {
  final String name;
  final String gender;
  final int age;
  final double weight;
  final double height;
  final String activityLevel;

  const OnboardingStep3Screen({
    super.key,
    required this.name,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
  });

  @override
  State<OnboardingStep3Screen> createState() => _OnboardingStep3ScreenState();
}

class _OnboardingStep3ScreenState extends State<OnboardingStep3Screen> {
  int _selectedGoalIndex = 1; // "Maintain Weight" pre-selected
  final _targetWeightController = TextEditingController();

  final int _currentStep = 3;
  final int _totalSteps = 3;
  double get _progress => _currentStep / _totalSteps;

  @override
  void initState() {
    super.initState();
    _targetWeightController.text = widget.weight.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _targetWeightController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _onFinish() async {
    final targetWeightText = _targetWeightController.text.trim();
    final targetWeight = double.tryParse(targetWeightText);

    if (targetWeight == null || targetWeight <= 0 || targetWeight > 500) {
      _showError('Please enter a valid target weight');
      return;
    }

    final profile = UserProfile(
      name: widget.name,
      age: widget.age,
      gender: widget.gender,
      height: widget.height,
      weight: widget.weight,
      targetWeight: targetWeight,
      goal: goalOptions[_selectedGoalIndex].title,
      activityLevel: widget.activityLevel,
    );

    await StorageService.saveUserProfile(profile);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTopBar(),
                    const SizedBox(height: 8),
                    _buildProgressRow(),
                    const SizedBox(height: 28),
                    _buildHeadline(),
                    const SizedBox(height: 24),
                    _buildGoalCards(),
                    const SizedBox(height: 28),
                    _buildTargetWeightSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.onSurface,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'MacroVerse',
          style: AppTextStyles.labelMd.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        // Notes/clipboard icon button
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.assignment_outlined,
            color: AppColors.onSurface,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ── Progress Row ──────────────────────────────────────────────────────────────

  Widget _buildProgressRow() {
    return Column(
      children: [
        // Full-width progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 6,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: 6,
                  width: constraints.maxWidth * _progress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryContainer],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.4,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $_currentStep of $_totalSteps',
              style: AppTextStyles.labelSm,
            ),
            Text(
              'Almost there!',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.primaryContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Headline ──────────────────────────────────────────────────────────────────

  Widget _buildHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What is your goal?', style: AppTextStyles.headlineLgMobile),
        const SizedBox(height: 10),
        Text(
          "We'll tailor your macro targets based on your\nselection.",
          style: AppTextStyles.bodyMd,
        ),
      ],
    );
  }

  // ── Goal Cards ────────────────────────────────────────────────────────────────

  Widget _buildGoalCards() {
    return Column(
      children: List.generate(goalOptions.length, (i) {
        final isSelected = _selectedGoalIndex == i;
        return Padding(
          padding: EdgeInsets.only(bottom: i < goalOptions.length - 1 ? 12 : 0),
          child: _GoalCard(
            option: goalOptions[i],
            isSelected: isSelected,
            onTap: () => setState(() => _selectedGoalIndex = i),
          ),
        );
      }),
    );
  }

  // ── Target Weight ─────────────────────────────────────────────────────────────

  Widget _buildTargetWeightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target Weight (kg)', style: AppTextStyles.labelMd),
        const SizedBox(height: 10),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _targetWeightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  style: AppTextStyles.labelMd.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  'KG',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Current weight: ${widget.weight.toStringAsFixed(1)}kg',
          style: AppTextStyles.labelSm,
        ),
      ],
    );
  }

  // ── Finish Button ─────────────────────────────────────────────────────────────

  Widget _buildFinishButton() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: AppColors.primary.withValues(alpha: 0.35),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Finish Setup',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🚀', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'By finishing, you agree to our Terms of Service.',
            style: AppTextStyles.labelSm.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Goal Card ────────────────────────────────────────────────────────────────

class _GoalCard extends StatelessWidget {
  final GoalOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : Colors.transparent,
            width: 2,
          ),
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
            // Icon badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: option.bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(option.icon, color: option.iconColor, size: 26),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: AppTextStyles.labelMd.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(option.subtitle, style: AppTextStyles.labelSm),
                ],
              ),
            ),

            // Check indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Container(
                      key: const ValueKey('checked'),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryContainer,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primaryContainer,
                        size: 22,
                      ),
                    )
                  : Container(
                      key: const ValueKey('unchecked'),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.outlineVariant,
                          width: 2,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
