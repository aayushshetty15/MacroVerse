import 'package:flutter/material.dart';
import 'package:macroverse/widgets/bottom_navigation.dart';
import 'package:macroverse/widgets/custom_appbar.dart';
import 'package:macroverse/services/storage_service.dart';
import 'package:macroverse/services/auth_service.dart';
import 'package:macroverse/screens/onboarding_screen.dart';
import 'package:macroverse/screens/profile_setup.dart';

import '../constants/app_colors.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
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
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileCard(),
                          const SizedBox(height: 28),
                          _buildSectionLabel('My Fitness Goals'),
                          const SizedBox(height: 12),
                          _buildFitnessGoalCard(),
                          const SizedBox(height: 28),
                          _buildSectionLabel('App Settings'),
                          const SizedBox(height: 12),
                          _buildSettingsCard(),
                          const SizedBox(height: 16),
                          _buildLogOutButton(),
                          const SizedBox(height: 24),
                          _buildVersionFooter(),
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
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 4),
    );
  }

  Widget _buildProfileCard() {
    final profile = StorageService.getUserProfile();
    final name = profile?.name ?? AuthService.getCurrentSession()?['name'] ?? 'User';
    final weightStr = profile != null ? '${profile.weight.toStringAsFixed(1)} kg' : '-- kg';
    final streakStr = StorageService.getMeals().isNotEmpty ? '1 Day' : '0 Days';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565E8), Color(0xFF0050CB)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0050CB).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Member since June 2026',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xCCFFFFFF),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  label: 'Current Weight',
                  value: weightStr,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatChip(label: 'Daily Streak', value: streakStr),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xCCFFFFFF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        letterSpacing: -0.2,
      ),
    );
  }

  // ── Fitness Goal Card ──────────────────────────────────────────────────────
  Widget _buildFitnessGoalCard() {
    final profile = StorageService.getUserProfile();
    final goalTitle = profile?.goal ?? 'Lose Weight';
    final targetWeightVal = profile?.targetWeight ?? 75.0;
    
    double progress = 0.0;
    if (profile != null) {
      final startWeight = profile.weight + 2.0; // Mock start weight
      final current = profile.weight;
      final target = profile.targetWeight;
      if ((startWeight - target).abs() > 0.1) {
        progress = ((startWeight - current) / (startWeight - target)).clamp(0.0, 1.0);
      } else {
        progress = 1.0;
      }
    }
    final progressPercent = (progress * 100).round();

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalTitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Target: ${targetWeightVal.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OnboardingStep1Screen()),
                  );
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '$progressPercent%',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE0E3E6),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Settings Card ──────────────────────────────────────────────────────────
  Widget _buildSettingsCard() {
    final items = <_SettingItem>[
      _SettingItem(
        icon: Icons.person_outline_rounded,
        label: 'Account Information',
        type: _SettingType.navigate,
      ),
      _SettingItem(
        icon: Icons.notifications_outlined,
        label: 'Push Notifications',
        type: _SettingType.toggle,
      ),
      _SettingItem(
        icon: Icons.straighten_outlined,
        label: 'Measurement Units',
        trailing: 'Metric',
        type: _SettingType.value,
      ),
      _SettingItem(
        icon: Icons.lock_outline_rounded,
        label: 'Privacy & Security',
        type: _SettingType.navigate,
      ),
      _SettingItem(
        icon: Icons.help_outline_rounded,
        label: 'Help Center',
        type: _SettingType.navigate,
      ),
    ];

    return Container(
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
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              _buildSettingRow(item),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  indent: 56,
                  endIndent: 0,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingRow(_SettingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.onSurfaceVariant, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurface,
              ),
            ),
          ),
          if (item.type == _SettingType.toggle)
            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primaryContainer,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.outlineVariant,
              ),
            )
          else if (item.type == _SettingType.value) ...[
            Text(
              item.trailing ?? '',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
          ] else
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
        ],
      ),
    );
  }

  // ── Log Out Button ─────────────────────────────────────────────────────────
  Widget _buildLogOutButton() {
    return GestureDetector(
      onTap: () async {
        await AuthService.logOut();
        await StorageService.clearAllData();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Version Footer ─────────────────────────────────────────────────────────
  Widget _buildVersionFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            'MacroVerse Version 2.4.1 (Build 882)',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.outline.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '© 2024 MacroVerse Inc.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.outline.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Navigation ──────────────────────────────────────────────────────
}

// ── Data models ───────────────────────────────────────────────────────────────

enum _SettingType { navigate, toggle, value }

class _SettingItem {
  final IconData icon;
  final String label;
  final String? trailing;
  final _SettingType type;
  const _SettingItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.type,
  });
}
