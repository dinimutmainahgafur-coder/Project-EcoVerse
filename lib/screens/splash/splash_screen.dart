import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack)),
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A3C24),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D2818),
                    Color(0xFF1A3C24),
                    Color(0xFF2E5E3F),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1B5E20).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        _buildLogo(),
                        const Spacer(flex: 3),
                        _buildButton(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF66BB6A).withValues(alpha: 0.2),
                const Color(0xFF2E7D32).withValues(alpha: 0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: _buildEcoIcon(),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'EcoVerse',
          style: GoogleFonts.poppins(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Small Actions, Big Impact',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEcoIcon() {
    return CustomPaint(
      size: const Size(80, 80),
      painter: EcoLeafPainter(),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mulai Perjalanan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EcoLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Earth circle
    paint.shader = const LinearGradient(
      colors: [Color(0xFF29B6F6), Color(0xFF1565C0)],
    ).createShader(Rect.fromCircle(center: center, radius: 28));
    canvas.drawCircle(center, 28, paint);

    // Land masses
    paint.color = const Color(0xFF4CAF50);
    final landPath = Path();
    landPath.moveTo(center.dx - 15, center.dy - 10);
    landPath.quadraticBezierTo(center.dx - 5, center.dy - 20, center.dx + 10, center.dy - 8);
    landPath.quadraticBezierTo(center.dx + 5, center.dy + 5, center.dx - 10, center.dy + 8);
    landPath.quadraticBezierTo(center.dx - 20, center.dy, center.dx - 15, center.dy - 10);
    canvas.drawPath(landPath, paint);

    // Leaf wrapping around
    paint.shader = const LinearGradient(
      colors: [Color(0xFF81C784), Color(0xFF2E7D32)],
    ).createShader(Rect.fromCircle(center: center, radius: 38));

    final leafPath = Path();
    leafPath.moveTo(center.dx + 30, center.dy + 20);
    leafPath.quadraticBezierTo(center.dx + 38, center.dy - 10, center.dx + 20, center.dy - 32);
    leafPath.quadraticBezierTo(center.dx + 5, center.dy - 42, center.dx - 15, center.dy - 35);
    leafPath.quadraticBezierTo(center.dx - 5, center.dy - 25, center.dx + 5, center.dy - 15);
    leafPath.quadraticBezierTo(center.dx + 15, center.dy - 5, center.dx + 10, center.dy + 10);
    leafPath.quadraticBezierTo(center.dx + 20, center.dy + 20, center.dx + 30, center.dy + 20);
    canvas.drawPath(leafPath, paint);

    // Leaf vein
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFFA5D6A7);
    final veinPath = Path();
    veinPath.moveTo(center.dx + 28, center.dy + 18);
    veinPath.quadraticBezierTo(center.dx + 15, center.dy - 5, center.dx + 5, center.dy - 28);
    canvas.drawPath(veinPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
