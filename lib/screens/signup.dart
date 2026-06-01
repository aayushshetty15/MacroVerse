import 'package:flutter/material.dart';
import 'package:macroverse/screens/login.dart';
import '../constants/app_colors.dart';

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

// ─── Sign Up Screen ───────────────────────────────────────────────────────────
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE6EDF8), Color(0xFFF7FAFD)],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildTopBar(),
                const SizedBox(height: 32),
                _buildHeadline(),
                const SizedBox(height: 32),
                _buildFormCard(),
                const SizedBox(height: 24),
                _buildFooter(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      children: [
        // Snowflake / hub icon
        Icon(Icons.hub_rounded, color: AppColors.primaryContainer, size: 26),
        const SizedBox(width: 8),
        Text(
          'MacroVerse',
          style: AppTextStyles.labelMd.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryContainer,
          ),
        ),
      ],
    );
  }

  // ── Headline ──────────────────────────────────────────────────────────────────

  Widget _buildHeadline() {
    return Column(
      children: [
        Text(
          'Create Your Account',
          style: AppTextStyles.headlineLgMobile,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Start your journey to optimal health with\nprecise macro tracking.',
          style: AppTextStyles.bodyMd,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Form Card ─────────────────────────────────────────────────────────────────

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name
          Text('Full Name', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          _buildOutlinedTextField(
            controller: _nameController,
            hint: 'John Doe',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
          ),

          const SizedBox(height: 18),

          // Email
          Text('Email', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          _buildOutlinedTextField(
            controller: _emailController,
            hint: 'name@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 18),

          // Password
          Text('Password', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          _buildOutlinedTextField(
            controller: _passwordController,
            hint: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.outline,
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Create Account button
          SizedBox(
            width: double.infinity,
            height: 56,
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
              child: Text(
                'Create Account',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Divider
          _buildDivider(),

          const SizedBox(height: 16),

          // Social buttons — full width stacked
          _buildSocialButton(
            label: 'Google',
            icon: _googleIcon(),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildSocialButton(label: 'Apple', icon: _appleIcon(), onTap: () {}),
        ],
      ),
    );
  }

  // ── Outlined Text Field ───────────────────────────────────────────────────────

  Widget _buildOutlinedTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant, width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(prefixIcon, color: AppColors.outline, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.outline,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffixIcon != null) ...[suffixIcon, const SizedBox(width: 14)],
        ],
      ),
    );
  }

  // ── Divider ───────────────────────────────────────────────────────────────────

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outlineVariant, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR CONTINUE WITH',
            style: AppTextStyles.labelSm.copyWith(
              letterSpacing: 0.8,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.outlineVariant, thickness: 1)),
      ],
    );
  }

  // ── Social Button (full-width outlined) ───────────────────────────────────────

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outlineVariant, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.labelMd.copyWith(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _googleIcon() {
    // Coloured "g" rendered as styled text inside a small rounded square
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xFFF1F3F4),
      ),
      child: const Center(
        child: Text(
          'g',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }

  Widget _appleIcon() {
    return Container(
      width: 28,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'iOS',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Column(
      children: [
        // Already have account row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 14,
                color: AppColors.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                'Log In',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.primaryContainer,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Terms & Privacy
        Text.rich(
          TextSpan(
            style: AppTextStyles.labelSm.copyWith(fontSize: 12),
            children: [
              const TextSpan(text: 'By signing up, you agree to our '),
              TextSpan(
                text: 'Terms of Service',
                style: AppTextStyles.labelSm.copyWith(
                  fontSize: 12,
                  color: AppColors.onSurface,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.onSurface,
                ),
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: AppTextStyles.labelSm.copyWith(
                  fontSize: 12,
                  color: AppColors.onSurface,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.onSurface,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
