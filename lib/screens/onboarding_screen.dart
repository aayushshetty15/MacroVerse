import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
class AppTextStyles {
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

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildLogo(),
                    const SizedBox(height: 32),
                    _buildHeroImage(),
                    const SizedBox(height: 36),
                    _buildHeadline(),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  // ── Logo ────────────────────────────────────────────────────────────────────

  Widget _buildLogo() {
    return Text(
      'MacroVerse',
      style: AppTextStyles.headlineLgMobile.copyWith(
        color: AppColors.primaryContainer,
        letterSpacing: -0.3,
      ),
    );
  }

  // ── Hero Image with floating badges ─────────────────────────────────────────

  Widget _buildHeroImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 340,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main food image — rounded square, slightly left & centered
            Positioned(
              left: 0,
              right: 32,
              top: 24,
              bottom: 24,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.surfaceContainerLow,
                      child: const Icon(
                        Icons.restaurant_rounded,
                        size: 56,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Protein badge — top right
            Positioned(
              top: 0,
              right: 0,
              child: _FloatingBadge(
                icon: Icons.bolt_rounded,
                iconColor: AppColors.tertiaryContainer,
                label: 'Protein',
                value: '145g',
              ),
            ),

            // Progress badge — bottom left
            Positioned(
              bottom: 0,
              left: 0,
              child: _FloatingBadge(
                icon: Icons.fitness_center_rounded,
                iconColor: AppColors.secondaryContainer,
                label: 'Progress',
                value: 'Target Met',
                valueFontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Headline & Subtext ───────────────────────────────────────────────────────

  Widget _buildHeadline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'Track Your Macros\nwith Precision',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLgMobile,
          ),
          const SizedBox(height: 14),
          Text(
            'Reach your fitness goals with MacroVerse.\nIntelligent tracking, personalized insights,\nand real results.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd,
          ),
        ],
      ),
    );
  }

  // ── Bottom CTA ───────────────────────────────────────────────────────────────

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        children: [
          // Get Started button
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () {},
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
                    'Get Started',
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

          const SizedBox(height: 16),

          // Log In row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: AppTextStyles.bodyMd.copyWith(fontSize: 14),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Log In',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Floating Badge ───────────────────────────────────────────────────────────

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final double valueFontSize;

  const _FloatingBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueFontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: AppTextStyles.labelSm),
              Text(
                value,
                style: AppTextStyles.labelMd.copyWith(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
