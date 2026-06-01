import 'package:flutter/material.dart';
// ─── Design Tokens ────────────────────────────────────────────────────────────
import 'package:macroverse/constants/app_colors.dart';
import 'profile_setup2.dart';

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

class ActivityOption {
  final String title;
  final String subtitle;

  const ActivityOption({required this.title, required this.subtitle});
}

const activityOptions = [
  ActivityOption(title: 'Sedentary', subtitle: 'Little or no exercise'),
  ActivityOption(title: 'Lightly Active', subtitle: 'Exercise 1-3 days/week'),
  ActivityOption(
    title: 'Moderately Active',
    subtitle: 'Exercise 3-5 days/week',
  ),
  ActivityOption(title: 'Very Active', subtitle: 'Hard exercise 6-7 days/week'),
  ActivityOption(
    title: 'Extra Active',
    subtitle: 'Very hard exercise & physical job',
  ),
];

// ─── Step 2 Screen ────────────────────────────────────────────────────────────

class OnboardingStep2Screen extends StatefulWidget {
  final String name;
  final String gender;
  final int age;
  final double weight;
  final double height;

  const OnboardingStep2Screen({
    super.key,
    required this.name,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
  });

  @override
  State<OnboardingStep2Screen> createState() => _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends State<OnboardingStep2Screen> {
  int _selectedIndex = 2; // "Moderately Active" pre-selected

  final int _currentStep = 2;
  final int _totalSteps = 3;

  double get _progress => _currentStep / _totalSteps;

  void _onContinue() {
    if (_selectedIndex < 0) return;
    final activityLevel = activityOptions[_selectedIndex].title;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingStep3Screen(
          name: widget.name,
          gender: widget.gender,
          age: widget.age,
          weight: widget.weight,
          height: widget.height,
          activityLevel: activityLevel,
        ),
      ),
    );
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildTopBar(),
                          const SizedBox(height: 28),
                          _buildHeadline(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Activity option cards
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.separated(
                      itemCount: activityOptions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _ActivityOptionCard(
                        option: activityOptions[i],
                        isSelected: _selectedIndex == i,
                        onTap: () => setState(() => _selectedIndex = i),
                      ),
                    ),
                  ),

                  // Decorative fitness image
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 24,
                        bottom: 8,
                      ),
                      child: _buildFitnessImage(),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),

            // Sticky Continue button
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Row(
      children: [
        // Back button
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

        // Progress bar
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
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
        ),
        const SizedBox(width: 12),

        // Step label
        Text(
          'Step $_currentStep of $_totalSteps',
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Headline ──────────────────────────────────────────────────────────────────

  Widget _buildHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your activity level?',
          style: AppTextStyles.headlineLgMobile,
        ),
        const SizedBox(height: 10),
        Text(
          'This helps us calculate your daily energy\nexpenditure more accurately.',
          style: AppTextStyles.bodyMd,
        ),
      ],
    );
  }

  // ── Fitness Image ─────────────────────────────────────────────────────────────

  Widget _buildFitnessImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.surfaceContainer,
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: AppColors.outline,
                  size: 48,
                ),
              ),
            ),
            // Gradient fade at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.surface.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Continue Button ───────────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: _selectedIndex >= 0 ? _onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.outlineVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            shadowColor: AppColors.primary.withValues(alpha: 0.35),
          ),
          child: Text(
            'Continue',
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.onPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Activity Option Card ─────────────────────────────────────────────────────

class _ActivityOptionCard extends StatelessWidget {
  final ActivityOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityOptionCard({
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryFixed.withValues(alpha: 0.35)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.03 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: AppTextStyles.labelMd.copyWith(
                      fontSize: 16,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(option.subtitle, style: AppTextStyles.labelSm),
                ],
              ),
            ),

            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : AppColors.outlineVariant,
                  width: 2,
                ),
                color: isSelected
                    ? AppColors.primaryContainer
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onPrimary,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
