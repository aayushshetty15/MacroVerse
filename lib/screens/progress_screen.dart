import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:macroverse/widgets/bottom_navigation.dart';
import 'package:macroverse/widgets/custom_appbar.dart';

import '../constants/app_colors.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────

// ── Progress Screen ───────────────────────────────────────────────────────────
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringController;
  late Animation<double> _ringAnimation;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ringAnimation = CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeOutCubic,
    );
    _ringController.forward();
  }

  @override
  void dispose() {
    _ringController.dispose();
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
                          _buildWeightTrendCard(),
                          const SizedBox(height: 16),
                          _buildAvgCaloriesCard(),
                          const SizedBox(height: 16),
                          _buildProteinTargetCard(),
                          const SizedBox(height: 28),
                          _buildTransformationSection(),
                          const SizedBox(height: 28),
                          _buildActivityInsightsSection(),
                          const SizedBox(height: 16),
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
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 3),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────

  // ── Page Header ────────────────────────────────────────────────────────────
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Looking good, Alex! You've lost 2.4kg this month.",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Weight Trend Card ──────────────────────────────────────────────────────
  Widget _buildWeightTrendCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Last 30 Days',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '-2.4kg',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: CustomPaint(
              size: const Size(double.infinity, 130),
              painter: _WeightChartPainter(
                lineColor: AppColors.primaryContainer,
                fillColor: const Color(0x1A0066FF),
                labelColor: AppColors.primaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '1 Oct',
                style: TextStyle(fontSize: 11, color: AppColors.outline),
              ),
              Text(
                '10 Oct',
                style: TextStyle(fontSize: 11, color: AppColors.outline),
              ),
              Text(
                '20 Oct',
                style: TextStyle(fontSize: 11, color: AppColors.outline),
              ),
              Text(
                'Today',
                style: TextStyle(fontSize: 11, color: AppColors.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Avg Calories Card ──────────────────────────────────────────────────────
  Widget _buildAvgCaloriesCard() {
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
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'AVG. CALORIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xAAFFFFFF),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '1,840',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Daily avg. this week',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xCCFFFFFF),
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.18,
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: Colors.white,
              size: 64,
            ),
          ),
        ],
      ),
    );
  }

  // ── Protein Target Card ────────────────────────────────────────────────────
  Widget _buildProteinTargetCard() {
    return _Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '92%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Protein Target',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _ringAnimation,
            builder: (_, _) => CustomPaint(
              size: const Size(54, 54),
              painter: _SmallRingPainter(
                progress: 0.92 * _ringAnimation.value,
                color: AppColors.primaryContainer,
                trackColor: const Color(0xFFE0E3E6),
                strokeWidth: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Transformation Section ─────────────────────────────────────────────────
  Widget _buildTransformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Transformation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'View Gallery',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primaryContainer,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Visual body change timeline',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 14),
        // 2x2 grid
        Row(
          children: [
            Expanded(
              child: _transformationTile(
                month: 'Month 1',
                weight: '82.4 kg',
                isLatest: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _transformationTile(
                month: 'Month 2',
                weight: '80.1 kg',
                isLatest: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _transformationTile(
                month: 'Month 3',
                weight: '78.2 kg',
                isLatest: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _updatePhotoTile()),
          ],
        ),
      ],
    );
  }

  Widget _transformationTile({
    required String month,
    required String weight,
    required bool isLatest,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder image with gradient overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFF2A3550), const Color(0xFF1A2035)],
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Color(0x44FFFFFF),
                size: 64,
              ),
            ),
          ),
          // Bottom label
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xCC000000), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      weight,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xCCFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Latest badge
          if (isLatest)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LATEST',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _updatePhotoTile() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEBEEF1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.outline,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Update Photo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Activity Insights ──────────────────────────────────────────────────────
  Widget _buildActivityInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            children: [
              _insightRow(
                icon: Icons.directions_run_rounded,
                iconColor: const Color(0xFF0066FF),
                iconBg: const Color(0xFFEAF0FF),
                title: 'Average Daily Steps',
                subtitle: '10,420 steps (+12% vs last mo)',
              ),
              const Divider(height: 1, color: Color(0xFFEBEEF1)),
              _insightRow(
                icon: Icons.fitness_center_rounded,
                iconColor: const Color(0xFFE07B00),
                iconBg: const Color(0xFFFFF3E0),
                title: 'Workout Consistency',
                subtitle: '18 sessions completed this month',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _insightRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.outline,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.outlineVariant,
            size: 20,
          ),
        ],
      ),
    );
  }

  // ── Bottom Navigation ──────────────────────────────────────────────────────
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

// ── Weight Chart CustomPainter ────────────────────────────────────────────────
class _WeightChartPainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;
  final Color labelColor;

  const _WeightChartPainter({
    required this.lineColor,
    required this.fillColor,
    required this.labelColor,
  });

  // Normalised data points (x: 0..1, y: 0..1 where 0=top, 1=bottom)
  static const _pts = [
    Offset(0.00, 0.72),
    Offset(0.12, 0.58),
    Offset(0.25, 0.40),
    Offset(0.38, 0.55),
    Offset(0.52, 0.68),
    Offset(0.65, 0.50),
    Offset(0.78, 0.42),
    Offset(0.88, 0.60),
    Offset(1.00, 0.28),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Map normalised points to canvas
    List<Offset> pts = _pts.map((p) => Offset(p.dx * w, p.dy * h)).toList();

    // Build smooth cubic spline path
    final linePath = _buildSpline(pts);

    // Fill area under curve
    final fillPath = Path()..addPath(linePath, Offset.zero);
    fillPath
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(fillPath, Paint()..color = fillColor);

    // Draw line
    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw dots on data points
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < pts.length; i += 2) {
      canvas.drawCircle(pts[i], 4, dotPaint);
      canvas.drawCircle(pts[i], 4, dotBorderPaint);
    }

    // Label on last point
    final lastPt = pts.last;
    final label = '78.2kg';
    final labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );
    final tp = TextPainter(
      text: TextSpan(text: label, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    const pad = 6.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(
          lastPt.dx.clamp(tp.width / 2 + pad + 8, w - tp.width / 2 - pad - 8),
          lastPt.dy - tp.height / 2 - pad - 10,
        ),
        width: tp.width + pad * 2,
        height: tp.height + pad * 1.5,
      ),
      const Radius.circular(8),
    );

    canvas.drawRRect(rect, Paint()..color = lineColor);
    tp.paint(canvas, Offset(rect.left + pad, rect.top + pad * 0.75));
  }

  Path _buildSpline(List<Offset> pts) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1 = Offset(
        pts[i].dx + (pts[i + 1].dx - pts[i].dx) * 0.45,
        pts[i].dy,
      );
      final cp2 = Offset(
        pts[i + 1].dx - (pts[i + 1].dx - pts[i].dx) * 0.45,
        pts[i + 1].dy,
      );
      path.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        pts[i + 1].dx,
        pts[i + 1].dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Small Arc Ring ────────────────────────────────────────────────────────────
class _SmallRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _SmallRingPainter({
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
  bool shouldRepaint(_SmallRingPainter old) => old.progress != progress;
}
