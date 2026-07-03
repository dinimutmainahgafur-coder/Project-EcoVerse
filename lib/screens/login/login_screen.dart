import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap setujui syarat dan kebijakan privasi',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: EcoColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted && success) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildIllustration(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Selamat Datang!',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: EcoColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldLabel('Nama Lengkap'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nameController,
                        hint: 'contoh: Jhon Doe',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => v == null || v.isEmpty ? 'Nama harus diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildFieldLabel('Email'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'contoh: email@domain.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email harus diisi';
                          if (!v.contains('@')) return 'Email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFieldLabel('Password'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Masukkan password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: EcoColors.subtitle,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password harus diisi';
                          if (v.length < 6) return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTermsCheckbox(),
                      const SizedBox(height: 24),
                      _buildRegisterButton(),
                      const SizedBox(height: 16),
                      _buildLoginLink(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F8E9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: NatureIllustrationPainter(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF66BB6A).withValues(alpha: 0.3),
                        const Color(0xFF2E7D32).withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: EcoLeafPainterSmall(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: EcoColors.text,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14, color: EcoColors.text),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: EcoColors.subtitle, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF5F7F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EcoColors.error),
        ),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: EcoColors.subtitle),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (v) => setState(() => _agreeTerms = v ?? false),
            activeColor: EcoColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: EcoColors.divider),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'Saya menyetujui ',
              style: GoogleFonts.poppins(fontSize: 12, color: EcoColors.subtitle),
              children: [
                TextSpan(
                  text: 'Persyaratan',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: EcoColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' dan '),
                TextSpan(
                  text: 'Kebijakan Privasi',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: EcoColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return ElevatedButton(
            onPressed: auth.isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: auth.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Daftar Sekarang',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/register'),
        child: RichText(
          text: TextSpan(
            text: 'Sudah punya akun? ',
            style: GoogleFonts.poppins(fontSize: 13, color: EcoColors.subtitle),
            children: [
              TextSpan(
                text: 'Masuk disini',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: EcoColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NatureIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Ground
    paint.color = const Color(0xFF81C784);
    final groundPath = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(groundPath, paint);

    // Darker ground
    paint.color = const Color(0xFF66BB6A);
    final darkGround = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.6, size.width * 0.5, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.8, size.width, size.height * 0.65)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(darkGround, paint);

    // Trees
    _drawTree(canvas, size.width * 0.15, size.height * 0.35, 20, const Color(0xFF2E7D32));
    _drawTree(canvas, size.width * 0.85, size.height * 0.3, 25, const Color(0xFF388E3C));
    _drawTree(canvas, size.width * 0.08, size.height * 0.5, 15, const Color(0xFF43A047));
    _drawTree(canvas, size.width * 0.92, size.height * 0.45, 18, const Color(0xFF4CAF50));

    // Hills
    paint.color = const Color(0xFFA5D6A7).withValues(alpha: 0.5);
    final hill1 = Path()
      ..moveTo(size.width * 0.2, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.2, size.width * 0.5, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.65, size.width * 0.2, size.height * 0.6);
    canvas.drawPath(hill1, paint);

    // People (simplified)
    _drawPerson(canvas, size.width * 0.4, size.height * 0.55, const Color(0xFF5D4037));
    _drawPerson(canvas, size.width * 0.55, size.height * 0.58, const Color(0xFF1565C0));
  }

  void _drawTree(Canvas canvas, double x, double y, double size, Color color) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Trunk
    paint.color = const Color(0xFF795548);
    canvas.drawRect(Rect.fromLTWH(x - 3, y, 6, size * 0.8), paint);

    // Foliage
    paint.color = color;
    canvas.drawCircle(Offset(x, y - size * 0.2), size * 0.5, paint);
    canvas.drawCircle(Offset(x - size * 0.3, y + size * 0.1), size * 0.35, paint);
    canvas.drawCircle(Offset(x + size * 0.3, y + size * 0.1), size * 0.35, paint);
  }

  void _drawPerson(Canvas canvas, double x, double y, Color shirtColor) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Head
    paint.color = const Color(0xFFFFCC80);
    canvas.drawCircle(Offset(x, y - 22), 7, paint);

    // Body
    paint.color = shirtColor;
    canvas.drawRect(Rect.fromLTWH(x - 6, y - 14, 12, 18), paint);

    // Legs
    paint.color = const Color(0xFF455A64);
    canvas.drawRect(Rect.fromLTWH(x - 5, y + 4, 4, 10), paint);
    canvas.drawRect(Rect.fromLTWH(x + 1, y + 4, 4, 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EcoLeafPainterSmall extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);

    // Earth
    paint.shader = const LinearGradient(
      colors: [Color(0xFF29B6F6), Color(0xFF1565C0)],
    ).createShader(Rect.fromCircle(center: center, radius: 22));
    canvas.drawCircle(center, 22, paint);

    // Land
    paint.color = const Color(0xFF4CAF50);
    final land = Path()
      ..moveTo(center.dx - 10, center.dy - 5)
      ..quadraticBezierTo(center.dx, center.dy - 12, center.dx + 8, center.dy)
      ..quadraticBezierTo(center.dx, center.dy + 8, center.dx - 10, center.dy - 5);
    canvas.drawPath(land, paint);

    // Leaf
    paint.shader = const LinearGradient(
      colors: [Color(0xFF81C784), Color(0xFF2E7D32)],
    ).createShader(Rect.fromCircle(center: center, radius: 30));
    final leaf = Path()
      ..moveTo(center.dx + 22, center.dy + 15)
      ..quadraticBezierTo(center.dx + 28, center.dy - 5, center.dx + 15, center.dy - 25)
      ..quadraticBezierTo(center.dx + 5, center.dy - 30, center.dx - 8, center.dy - 22)
      ..quadraticBezierTo(center.dx, center.dy - 15, center.dx + 5, center.dy)
      ..quadraticBezierTo(center.dx + 12, center.dy + 10, center.dx + 22, center.dy + 15);
    canvas.drawPath(leaf, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
