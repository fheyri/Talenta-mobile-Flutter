import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/app_fonts.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/api_exception.dart';
import 'role_selection_screen.dart';

/// Layar 4: Masuk (Gambar 4)
/// Sesuai instruksi:
/// - Header 270 dp gradasi #2F5FE6 ke #438EF5 dengan 2 lingkaran putih transparan.
/// - Panah kembali menuju Layar 2.
/// - Kolom tinggi 37 dp, padding kiri-kanan 22 dp.
/// - TANPA ikon mata di kolom sandi.
/// - Tombol Masuk, Lupa Sandi, dan dua tombol abu (#DEDEDE dengan teks biru #315EE8) tinggi 48 dp bentuk pil penuh.
/// - Validasi E-mail / Nama: jika bukan format email, tampilkan "Gunakan e-mail untuk masuk (login dengan nama belum tersedia)".
/// - "Daftar Sekarang" menuju Layar 2.
/// - Setelah masuk berhasil: Navigator.popUntil route pertama.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _cardAnimController;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOut),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOutQuart),
    );
    _cardAnimController.forward();
  }

  @override
  void dispose() {
    _cardAnimController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature belum tersedia.')),
      );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final input = _loginController.text.trim();
    // Validasi sesuai instruksi: backend baru menerima email
    final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(input);
    if (!isEmail) {
      setState(() {
        _error = 'Gunakan e-mail untuk masuk (login dengan nama belum tersedia)';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().login(
            input,
            _passwordController.text,
          );

      if (mounted) {
        // Setelah masuk berhasil, kosongkan tumpukan navigasi supaya AuthGate menampilkan halaman utama
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Terjadi kesalahan. Coba lagi.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header 270 dp dengan gradasi #2F5FE6 ke #438EF5 dan 2 lingkaran transparan
            _Header(
              title: 'Masuk',
              subtitle: 'Masuk Sekarang',
              onBack: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                  );
                }
              },
            ),

            // Kartu putih dengan sudut atas melengkung 28 dp
            SlideTransition(
              position: _cardSlide,
              child: FadeTransition(
                opacity: _cardFade,
                child: Transform.translate(
                  offset: const Offset(0, -28),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 24), // Padding 22 dp
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Field 1: E-mail / Nama (tinggi 37 dp)
                      _LoginField(
                        label: 'E-mail / Nama',
                        controller: _loginController,
                        hint: 'admin@gmail.com',
                        enabled: !_loading,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) {
                            return 'E-mail / Nama wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // Field 2: Kata Sandi (tinggi 37 dp, TANPA ikon mata)
                      _LoginField(
                        label: 'Kata Sandi',
                        controller: _passwordController,
                        hint: 'admin123',
                        enabled: !_loading,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (v) {
                          if ((v ?? '').isEmpty) {
                            return 'Kata Sandi wajib diisi';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECEC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFF3B9B9)),
                          ),
                          child: Text(
                            _error!,
                            style: AppFonts.inter(fontSize: 12, color: AppColors.error),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Tombol "Masuk" (tinggi 48 dp, bentuk pil penuh, warna #315EE8)
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Masuk',
                                  style: AppFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tombol "Lupa Sandi" (tinggi 48 dp, bentuk pil penuh, outlined)
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _loading ? null : () => _showComingSoon('Lupa Sandi'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            'Lupa Sandi',
                            style: AppFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Teks "Atau"
                      Center(
                        child: Text(
                          'Atau',
                          style: AppFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.navy,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tombol "Lanjutkan dengan Google" (tinggi 48 dp, bentuk pil, #DEDEDE dengan teks biru)
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : () => _showComingSoon('Lanjutkan dengan Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greyButton,
                            foregroundColor: AppColors.greyButtonText,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/google.svg',
                                width: 18,
                                height: 18,
                                placeholderBuilder: (_) => const Icon(
                                  Icons.g_mobiledata,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Lanjutkan dengan Google',
                                style: AppFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.greyButtonText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tombol "Lanjutkan dengan E-mail" (tinggi 48 dp, bentuk pil, #DEDEDE dengan teks biru)
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : () => _showComingSoon('Lanjutkan dengan E-mail'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greyButton,
                            foregroundColor: AppColors.greyButtonText,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.mail_outline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Lanjutkan dengan E-mail',
                                style: AppFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.greyButtonText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // "Belum Memiliki Akun? Daftar Sekarang" (menuju Layar 2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum Memiliki Akun? ',
                            style: AppFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.navy,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const RoleSelectionScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Daftar Sekarang',
                              style: AppFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          // 2 Lingkaran putih transparan di kanan atas dengan animasi ambient float
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              final drift1 = math.sin(_bubbleController.value * math.pi) * 6;
              final drift2 = math.cos(_bubbleController.value * math.pi) * 5;
              return Stack(
                children: [
                  Positioned(
                    right: -40 + drift1,
                    top: -40 + drift2,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50 - drift2,
                    top: 60 + drift1,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.14),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Panah kembali dan Judul
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 20, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: widget.onBack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AppFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: AppFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.label,
    required this.controller,
    required this.hint,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 37, // Tinggi kolom ~37 dp sesuai instruksi
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            style: AppFonts.inter(fontSize: 13, color: AppColors.navy),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppFonts.inter(fontSize: 13, color: AppColors.hint),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
