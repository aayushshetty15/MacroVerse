import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:macroverse/widgets/bottom_navigation.dart';
import 'package:macroverse/widgets/custom_appbar.dart';

import '../constants/app_colors.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────

// ── Dashboard Screen ──────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _macroPage = 1; // 0-indexed dot indicator
  int notifCount = 9;

  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;
  late AnimationController _chartCtrl;
  late Animation<double> _chartAnim;

  final _searchCtrl = TextEditingController();

  // Macro data
  static const _macros = [
    _MacroData('Carbs', 50, 165, AppColors.teal),
    _MacroData('Fat', 35, 65, AppColors.purple),
    _MacroData('Protein', 65, 85, AppColors.gold),
  ];

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic);

    _chartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _chartAnim = CurvedAnimation(
      parent: _chartCtrl,
      curve: Curves.easeOutCubic,
    );

    _ringCtrl.forward();
    Future.delayed(
      const Duration(milliseconds: 300),
      () => _chartCtrl.forward(),
    );
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _chartCtrl.dispose();
    _searchCtrl.dispose();
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
                padding: const EdgeInsets.only(bottom: 20),
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
                          _buildGreeting(),
                          const SizedBox(height: 24),
                          _buildMacrosCard(),
                          const SizedBox(height: 16),
                          _buildStepsExerciseRow(),
                          const SizedBox(height: 24),
                          _buildProgressSection(),
                          const SizedBox(height: 20),
                          _buildSearchBar(),
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
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 0),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────

  // ── Greeting ───────────────────────────────────────────────────────────────
  Widget _buildGreeting() {
    return const Text(
      "We're so happy\nto see you again!",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        height: 1.25,
        letterSpacing: -0.5,
      ),
    );
  }

  // ── Macros Card ────────────────────────────────────────────────────────────
  Widget _buildMacrosCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Macros',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: AppColors.outline, size: 22),
            ],
          ),
          const SizedBox(height: 20),

          // Three macro rings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _macros.map((m) => _buildMacroRing(m)).toList(),
          ),

          const SizedBox(height: 20),

          // Dot indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final active = i == _macroPage;
              return GestureDetector(
                onTap: () => setState(() => _macroPage = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 10 : 8,
                  height: active ? 10 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? AppColors.primaryContainer : AppColors  .outlineVariant,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRing(_MacroData m) {
    final progress = (m.current / m.goal).clamp(0.0, 1.0);
    final remaining = m.goal - m.current;

    return Column(
      children: [
        // Label
        Text(
          m.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: m.color,
          ),
        ),
        const SizedBox(height: 12),
        // Ring
        AnimatedBuilder(
          animation: _ringAnim,
          builder: (_, _) => SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(90, 90),
                  painter: _SingleRingPainter(
                    progress: progress * _ringAnim.value,
                    color: m.color,
                    trackColor: const Color(0xFFE8ECF0),
                    strokeWidth: 9,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${m.current}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      '/${m.goal}g',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${remaining}g left',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }

  // ── Steps + Exercise Row ───────────────────────────────────────────────────
  Widget _buildStepsExerciseRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Steps card
        Expanded(
          child: _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Steps',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.directions_walk_rounded,
                      color: Color(0xFFE53935),
                      size: 22,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '3,550',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Goal: 15,000 steps',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 12),
                // Steps progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: 3550 / 15000,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE0E3E6),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFE53935),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Exercise card
        Expanded(
          child: _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Exercise',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.onSurface,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _exerciseRow(
                  bgColor: const Color(0xFFFFF3E0),
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFFF8F00),
                  value: '100 cal',
                ),
                const SizedBox(height: 10),
                _exerciseRow(
                  bgColor: const Color(0xFFE8F4F8),
                  icon: Icons.schedule_rounded,
                  iconColor: const Color(0xFF0288D1),
                  value: '0:30 hr',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _exerciseRow({
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  // ── Progress Section ───────────────────────────────────────────────────────
  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart
              SizedBox(
                height: 160,
                child: AnimatedBuilder(
                  animation: _chartAnim,
                  builder: (_, _) => CustomPaint(
                    size: const Size(double.infinity, 160),
                    painter: _ProgressChartPainter(progress: _chartAnim.value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Weight stats row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Current Weight',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.outline,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '74.5 kg',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        '-1.2 kg',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.teal,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'last 7 days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          const Icon(Icons.search_rounded, color: AppColors.outline, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurface,
              ),
              decoration: const InputDecoration(
                hintText: 'Search for a food',
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.outline,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              cursorColor: AppColors.primaryContainer,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.primaryContainer,
              size: 22,
            ),
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

// ── Single Ring Painter ───────────────────────────────────────────────────────
class _SingleRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _SingleRingPainter({
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
  bool shouldRepaint(_SingleRingPainter old) =>
      old.progress != progress || old.color != color;
}

// ── Progress Chart Painter ────────────────────────────────────────────────────
class _ProgressChartPainter extends CustomPainter {
  final double progress;
  const _ProgressChartPainter({required this.progress});

  // Normalised weight line points (x: 0..1, y: 0..1 where 1=bottom)
  static const _linePts = [
    Offset(0.00, 0.45),
    Offset(0.08, 0.50),
    Offset(0.16, 0.38),
    Offset(0.24, 0.60),
    Offset(0.32, 0.42),
    Offset(0.40, 0.35),
    Offset(0.50, 0.55),
    Offset(0.58, 0.30),
    Offset(0.66, 0.45),
    Offset(0.74, 0.38),
    Offset(0.82, 0.28),
    Offset(0.90, 0.35),
    Offset(1.00, 0.25),
  ];

  // Bar heights (normalised 0..1)
  static const _bars = [0.25, 0.35, 0.45, 0.55, 0.80, 1.0, 0.90];

  static const _teal = Color(0xFF008072);
  static const _tealLight = Color(0xFFB2DFDB);
  static const _gridColor = Color(0xFFE8ECF0);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final chartH = h * 0.85;
    final baseY = h * 0.92;

    // ── Grid lines ──
    final gridPaint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = baseY - (chartH * i / 4);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Y-axis labels
    const yLabels = ['0', '100', '200', '300', '400'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = baseY - (chartH * i / 4);
      final tp = TextPainter(
        text: TextSpan(
          text: yLabels[i],
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFFB0B5C0),
            fontFamily: 'Inter',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    final chartLeft = 22.0;
    final chartW = w - chartLeft;

    // ── Bars ──
    final barCount = _bars.length;
    final barWidth = (chartW / barCount) * 0.45;
    final barSpacing = chartW / barCount;

    for (int i = 0; i < barCount; i++) {
      final barH = _bars[i] * chartH * progress;
      final x = chartLeft + i * barSpacing + barSpacing / 2 - barWidth / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, baseY - barH, barWidth, barH),
        const Radius.circular(6),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = _tealLight.withValues(alpha: 0.7 * progress),
      );
    }

    // ── Spline line ──
    final pts = _linePts
        .map((p) => Offset(chartLeft + p.dx * chartW, baseY - p.dy * chartH))
        .toList();

    // Clip to progress reveal
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, chartLeft + chartW * progress, h));

    final linePath = _buildSpline(pts);

    // Fill under line
    final fillPath = Path()..addPath(linePath, Offset.zero);
    fillPath
      ..lineTo(pts.last.dx, baseY)
      ..lineTo(pts.first.dx, baseY)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_teal.withValues(alpha: 0.18), _teal.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Stroke
    canvas.drawPath(
      linePath,
      Paint()
        ..color = _teal
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.restore();
  }

  Path _buildSpline(List<Offset> pts) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final dx = (pts[i + 1].dx - pts[i].dx) * 0.45;
      path.cubicTo(
        pts[i].dx + dx,
        pts[i].dy,
        pts[i + 1].dx - dx,
        pts[i + 1].dy,
        pts[i + 1].dx,
        pts[i + 1].dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(_ProgressChartPainter old) => old.progress != progress;
}

// ── Data Models ───────────────────────────────────────────────────────────────
class _MacroData {
  final String name;
  final int current;
  final int goal;
  final Color color;
  const _MacroData(this.name, this.current, this.goal, this.color);
}
