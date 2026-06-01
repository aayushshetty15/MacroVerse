import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macroverse/constants/app_colors.dart';
import 'profile_setup1.dart';

class AppTextStyles {
  static const displayLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.64,
    color: AppColors.onSurface,
  );
  static const headlineLgMobile = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    color: AppColors.onSurface,
  );
  static const bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.44,
    color: AppColors.onSurfaceVariant,
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
}

// ─── App Root ─────────────────────────────────────────────────────────────────

// ─── Onboarding Step 1 ────────────────────────────────────────────────────────

class OnboardingStep1Screen extends StatefulWidget {
  const OnboardingStep1Screen({super.key});

  @override
  State<OnboardingStep1Screen> createState() => _OnboardingStep1ScreenState();
}

class _OnboardingStep1ScreenState extends State<OnboardingStep1Screen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGender;

  final int _totalSteps = 3;
  final int _currentStep = 1;

  double get _progress => _currentStep / _totalSteps;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
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

  void _onContinue() {
    final name = _nameController.text.trim();
    final gender = _selectedGender;
    final ageText = _ageController.text.trim();
    final weightText = _weightController.text.trim();
    final heightText = _heightController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (gender == null) {
      _showError('Please select your gender');
      return;
    }
    final age = int.tryParse(ageText);
    if (age == null || age <= 0 || age > 120) {
      _showError('Please enter a valid age');
      return;
    }
    final weight = double.tryParse(weightText);
    if (weight == null || weight <= 0 || weight > 500) {
      _showError('Please enter a valid weight');
      return;
    }
    final height = double.tryParse(heightText);
    if (height == null || height <= 0 || height > 300) {
      _showError('Please enter a valid height');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingStep2Screen(
          name: name,
          gender: gender,
          age: age,
          weight: weight,
          height: height,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable content ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTopBar(),
                    const SizedBox(height: 28),
                    _buildStepIndicator(),
                    const SizedBox(height: 24),
                    _buildHeadline(),
                    const SizedBox(height: 28),
                    _buildInputCard(),
                  ],
                ),
              ),
            ),
            // ── Sticky continue button ───────────────────────────────────
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'MacroVerse',
          style: AppTextStyles.labelMd.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryContainer, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=88&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.surfaceContainer,
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.outline,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Step Indicator ────────────────────────────────────────────────────────

  Widget _buildStepIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $_currentStep of $_totalSteps',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.primaryContainer,
              ),
            ),
            Text(
              '${(_progress * 100).round()}%',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Track
                Container(
                  height: 6,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Fill
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
      ],
    );
  }

  // ── Headline ──────────────────────────────────────────────────────────────

  Widget _buildHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tell us about\nyourself', style: AppTextStyles.headlineLgMobile),
        const SizedBox(height: 10),
        Text(
          'We use this to calculate your daily caloric\nneeds with scientific precision.',
          style: AppTextStyles.bodyLg,
        ),
      ],
    );
  }

  // ── Input Card ────────────────────────────────────────────────────────────

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
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
          // Name field
          Text('Full Name', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nameController,
            hint: 'e.g. John Doe',
            suffix: '',
            keyboardType: TextInputType.name,
          ),

          const SizedBox(height: 20),

          // Gender Selector
          Text('Gender', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton('Male', Icons.male_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderButton('Female', Icons.female_rounded),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Age field
          Text('Age', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _ageController,
            hint: 'e.g. 28',
            suffix: 'years',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),

          const SizedBox(height: 20),

          // Weight & Height row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight', style: AppTextStyles.labelMd),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _weightController,
                      hint: '75',
                      suffix: 'kg',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,1}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Height', style: AppTextStyles.labelMd),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _heightController,
                      hint: '180',
                      suffix: 'cm',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryFixed.withValues(alpha: 0.35)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.outline,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String suffix,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              style: AppTextStyles.bodyMd,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.outline,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          if (suffix.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                suffix,
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Continue Button ───────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: _onContinue,
          style:
              ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shadowColor: AppColors.primary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ).copyWith(
                elevation: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) return 2;
                  return 6;
                }),
                shadowColor: WidgetStateProperty.all(
                  AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.onPrimary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
