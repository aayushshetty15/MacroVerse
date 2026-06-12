import 'package:flutter/material.dart';
import 'package:macroverse/screens/dashboard_screen.dart';
import 'package:macroverse/screens/profile_setup.dart';
import 'package:macroverse/screens/signup.dart';
import 'package:macroverse/services/auth_service.dart';
import 'package:macroverse/services/storage_service.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  static const headlineLgMobile = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    color: AppColors.primaryContainer,
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
// ─── Login Screen ─────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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

  void _showSocialAuthOverlay({required String provider, required VoidCallback onComplete}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 72,
                        height: 72,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryContainer),
                        ),
                      ),
                      provider == 'Google'
                          ? Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'G',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF4285F4),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.apple_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Signing in with $provider...',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait while we secure your connection',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.of(context).pop(); // Dismiss overlay
      onComplete();
    });
  }

  void _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter your email address');
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }
    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }

    final success = await AuthService.logIn(email, password);
    if (!success) {
      _showError('Invalid email or password');
      return;
    }

    if (mounted) {
      final profile = StorageService.getUserProfile();
      if (profile != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingStep1Screen()),
          (route) => false,
        );
      }
    }
  }

  void _onSocialLogin(String provider) {
    _showSocialAuthOverlay(
      provider: provider,
      onComplete: () async {
        final mockName = provider == 'Google' ? 'Google User' : 'Apple User';
        final mockEmail = provider == 'Google' ? 'google_user@gmail.com' : 'apple_user@icloud.com';
        
        final success = provider == 'Google'
            ? await AuthService.signInWithGoogle(mockName, mockEmail)
            : await AuthService.signInWithApple(mockName, mockEmail);
            
        if (success && mounted) {
          final profile = StorageService.getUserProfile();
          if (profile != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const OnboardingStep1Screen()),
              (route) => false,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
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
            colors: [
              Color(0xFFE8EEF9), // soft blue-tinted top
              Color(0xFFF7FAFD), // surface
            ],
            stops: [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),
                _buildAppIcon(),
                const SizedBox(height: 20),
                _buildBranding(),
                const SizedBox(height: 36),
                _buildLoginCard(),
                const SizedBox(height: 24),
                _buildSignUpRow(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── App Icon ──────────────────────────────────────────────────────────────────

  Widget _buildAppIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.energy_savings_leaf_rounded,
        color: AppColors.onPrimary,
        size: 40,
      ),
    );
  }

  // ── Branding ──────────────────────────────────────────────────────────────────

  Widget _buildBranding() {
    return Column(
      children: [
        Text('MacroVerse', style: AppTextStyles.headlineLgMobile),
        const SizedBox(height: 6),
        Text(
          'Track your journey to peak health',
          style: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  // ── Login Card ────────────────────────────────────────────────────────────────

  Widget _buildLoginCard() {
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
          // Email field
          Text('Email Address', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'name@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 20),

          // Password field
          Text('Password', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          _buildTextField(
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

          const SizedBox(height: 12),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _showError('Reset link sent if email is registered.'),
              child: Text(
                'Forgot Password?',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.primaryContainer,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Login button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _onLogin,
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
                'Login',
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

          const SizedBox(height: 20),

          // Social buttons
          Row(
            children: [
              Expanded(child: _buildGoogleButton()),
              const SizedBox(width: 12),
              Expanded(child: _buildAppleButton()),
            ],
          ),
        ],
      ),
    );
  }

  // ── Text Field ────────────────────────────────────────────────────────────────

  Widget _buildTextField({
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
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
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

  // ── Google Button ─────────────────────────────────────────────────────────────

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: () => _onSocialLogin('Google'),
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
            // Google "G" logo using colored text
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4285F4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('Google', style: AppTextStyles.labelMd.copyWith(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // ── Apple Button ──────────────────────────────────────────────────────────────

  Widget _buildAppleButton() {
    return GestureDetector(
      onTap: () => _onSocialLogin('Apple'),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apple_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              'Apple',
              style: AppTextStyles.labelMd.copyWith(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sign Up Row ───────────────────────────────────────────────────────────────

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: 14,
            color: AppColors.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: Text(
            'Sign Up',
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.primaryContainer,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
