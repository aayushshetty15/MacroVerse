import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;
  late Animation<Offset> _slideUp;

  static const Color _primary = Color(0xFF0050CB);
  static const Color _primaryContainer = Color(0xFF0066FF);
  static const Color _secondary = Color(0xFFFFB800);
  static const Color _onSurface = Color(0xFF181C1E);
  static const Color _outline = Color(0xFF727687);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _scaleIn = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE5EBFF), // soft blue-lavender top
              Color(0xFFEEF3FF),
              Color(0xFFF7FAFD), // neutral mid
              Color(0xFFEDF1FF), // slight blue bottom tint
            ],
            stops: [0.0, 0.25, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Radial ambient glow centred behind the icon ──
            Positioned(
              top: size.height * 0.37,
              left: size.width / 2 - 130,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0066FF).withValues(alpha: 0.13),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Thin top accent bar: blue → amber ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0066FF),
                      Color(0xFF4DA3FF),
                      Color(0xFFFFB800),
                    ],
                  ),
                ),
              ),
            ),

            // ── Centre content ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App icon with entrance animation
                  FadeTransition(
                    opacity: _fadeIn,
                    child: ScaleTransition(
                      scale: _scaleIn,
                      child: _AppIcon(
                        primaryColor: _primary,
                        badgeColor: _secondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  // Wordmark + tagline slide up
                  SlideTransition(
                    position: _slideUp,
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          // "MacroVerse" two-tone wordmark
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.64,
                                height: 1.25,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Macro',
                                  style: TextStyle(color: _onSurface),
                                ),
                                TextSpan(
                                  text: 'Verse',
                                  style: TextStyle(color: _primaryContainer),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Tagline
                          const SizedBox(
                            width: 264,
                            child: Text(
                              'Precision nutrition for your ultimate potential.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF727687),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom version / copyright strip ──
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'VERSION 2.4.0',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _outline.withValues(alpha: 0.70),
                            letterSpacing: 1.1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '·',
                            style: TextStyle(
                              color: _outline.withValues(alpha: 0.45),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          'SECURE SYNC',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _outline.withValues(alpha: 0.70),
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '© 2024 MacroVerse Labs Inc.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: _outline.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// App Icon widget
// ────────────────────────────────────────────────────────────────────────────

class _AppIcon extends StatelessWidget {
  final Color primaryColor;
  final Color badgeColor;

  const _AppIcon({required this.primaryColor, required this.badgeColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      height: 104,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // White rounded-square card
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0066FF).withValues(alpha: 0.20),
                  blurRadius: 36,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(44, 44),
                painter: _BoltPainter(color: primaryColor),
              ),
            ),
          ),

          // Amber star badge
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(15, 15),
                  painter: _StarPainter(color: const Color(0xFF7C5800)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Bolt / lightning CustomPainter
// ────────────────────────────────────────────────────────────────────────────

class _BoltPainter extends CustomPainter {
  final Color color;
  const _BoltPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.63, 0)
      ..lineTo(w * 0.19, h * 0.53)
      ..lineTo(w * 0.46, h * 0.53)
      ..lineTo(w * 0.37, h)
      ..lineTo(w * 0.83, h * 0.47)
      ..lineTo(w * 0.55, h * 0.47)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BoltPainter old) => old.color != color;
}

// ────────────────────────────────────────────────────────────────────────────
// Star outline CustomPainter
// ────────────────────────────────────────────────────────────────────────────

class _StarPainter extends CustomPainter {
  final Color color;
  const _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const points = 5;
    final outerR = size.width / 2;
    final innerR = outerR * 0.42;

    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color;
}
