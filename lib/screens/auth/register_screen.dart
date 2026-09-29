import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_fonts.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_exception.dart';
import '../login_screen.dart';
import '../role_selection_screen.dart';

/// Layar 3: Daftar (Gambar 3)
/// Sesuai instruksi:
/// - Header 270 dp gradasi #2F5FE6 ke #438EF5 dengan 2 lingkaran putih transparan di kanan atas.
/// - Kolom tinggi 46 dp, radius 14 dp, padding kiri-kanan 32 dp.
/// - TANPA ikon mata di kolom sandi.
/// - Tombol Daftar tinggi 44 dp bentuk pil penuh #315EE8.
/// - Setelah berhasil, Navigator.popUntil route pertama agar AuthGate menampilkan HomePlaceholder.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.role = 'siswa'});

  final String role;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

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
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // POST /auth/register mengirim: name, email, password, role
      await context.read<AuthProvider>().register(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            role: widget.role,
          );

      if (mounted) {
        // Setelah daftar berhasil, kosongkan tumpukan navigasi supaya AuthGate menampilkan halaman utama
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

  String? _validateName(String? v) {
    if ((v ?? '').trim().isEmpty) return 'Nama Lengkap wajib diisi';
    return null;
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'E-mail wajib diisi';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Format e-mail tidak valid';
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Kata Sandi wajib diisi';
    if (value.length < 8) return 'Kata Sandi minimal 8 karakter';
    return null;
  }

  String? _validateConfirm(String? v) {
    if ((v ?? '').isEmpty) return 'Konfirmasi Sandi wajib diisi';
    if (v != _password.text) return 'Konfirmasi Sandi tidak cocok';
    return null;
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
              title: 'Daftar',
              subtitle: 'Daftar Sekarang',
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
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Field 1: Nama Lengkap
                      _FormField(
                        label: 'Nama Lengkap',
                        controller: _name,
                        hint: 'admin',
                        enabled: !_loading,
                        validator: _validateName,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 14),

                      // Field 2: E-mail
                      _FormField(
                        label: 'E-mail',
                        controller: _email,
                        hint: 'admin@talenta.id',
                        enabled: !_loading,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 14),

                      // Field 3: Kata Sandi (TANPA ikon mata sesuai desain)
                      _FormField(
                        label: 'Kata Sandi',
                        controller: _password,
                        hint: 'admin123',
                        enabled: !_loading,
                        obscureText: true,
                        validator: _validatePassword,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 14),

                      // Field 4: Konfirmasi Sandi (TANPA ikon mata sesuai desain)
                      _FormField(
                        label: 'Konfirmasi Sandi',
                        controller: _confirmPassword,
                        hint: 'admin123',
                        enabled: !_loading,
                        obscureText: true,
                        validator: _validateConfirm,
                        textInputAction: TextInputAction.done,
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

                      const SizedBox(height: 28),

                      // Tombol Daftar (tinggi 44 dp, margin kiri & kanan ~42 dp, bentuk pil penuh)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 44,
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
                                    'Daftar',
                                    style: AppFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // "Sudah Memiliki Akun? Masuk Sekarang" (menuju Layar 4)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah Memiliki Akun? ',
                            style: AppFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.navy,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Masuk Sekarang',
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

class _FormField extends StatelessWidget {
  const _FormField({
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 46, // Tinggi kolom ~46 dp
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            style: AppFonts.inter(fontSize: 13.5, color: AppColors.navy),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppFonts.inter(fontSize: 13.5, color: AppColors.hint),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14), // Radius 14 dp
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
