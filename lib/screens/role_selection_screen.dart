import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_fonts.dart';
import '../core/app_theme.dart';
import 'auth/register_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

/// Layar 2: Pilih jenis akun (Siswa / Alumni) (Gambar 2 & Pembaruan Desain)
/// - Panah kembali di kiri atas menuju Layar 1 (SplashScreen).
/// - Kartu Siswa: Ikon topi wisuda, aktif default (border biru, lingkaran biru muda, teks navy).
/// - Kartu Alumni: Ikon avatar orang (person), tidak aktif default (border ungu muda, lingkaran abu-abu, teks abu-abu).
/// - Saat dipilih (tap), kartu yang aktif berubah gaya secara dinamis.
/// - Tombol Mulai pil penuh menuju Layar 3 (RegisterScreen).
/// - "Masuk Sekarang" menuju Layar 4 (LoginScreen).
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String _selectedRole = 'siswa';
  bool _isButtonPressed = false;

  late final AnimationController _animController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _card1Fade;
  late final Animation<Offset> _card1Slide;
  late final Animation<double> _card2Fade;
  late final Animation<Offset> _card2Slide;
  late final Animation<double> _bottomFade;
  late final Animation<Offset> _bottomSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.50, curve: Curves.easeOutQuart),
      ),
    );

    _card1Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.20, 0.65, curve: Curves.easeOut),
      ),
    );
    _card1Slide = Tween<Offset>(
      begin: const Offset(-0.15, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.20, 0.70, curve: Curves.easeOutQuart),
      ),
    );

    _card2Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.30, 0.75, curve: Curves.easeOut),
      ),
    );
    _card2Slide = Tween<Offset>(
      begin: const Offset(0.15, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.30, 0.80, curve: Curves.easeOutQuart),
      ),
    );

    _bottomFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.50, 0.95, curve: Curves.easeOut),
      ),
    );
    _bottomSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.50, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Glow biru muda lembut di pojok kanan atas
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFDCEBFC).withOpacity(0.85),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Panah kembali di kiri atas (menuju Layar 1)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.primary, size: 24),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const SplashScreen()),
                          );
                        }
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),

                          // Header & Logo dengan animasi halus
                          SlideTransition(
                            position: _headerSlide,
                            child: FadeTransition(
                              opacity: _headerFade,
                              child: Column(
                                children: [
                                  // Logo T (lebar ~133 dp) di atas
                                  Center(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      width: 133,
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  const SizedBox(height: 26),

                                  // Judul: "Selamat Datang di TALENTA"
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 327),
                                    child: Text(
                                      'Selamat Datang di TALENTA',
                                      textAlign: TextAlign.center,
                                      style: AppFonts.inter(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.navy,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Subjudul: "Pilih jenis akun untuk melanjutkan"
                                  Text(
                                    'Pilih jenis akun untuk melanjutkan',
                                    textAlign: TextAlign.center,
                                    style: AppFonts.inter(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),

                          // Dua kartu pilihan (Siswa & Alumni) dengan animasi staggered
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SlideTransition(
                                position: _card1Slide,
                                child: FadeTransition(
                                  opacity: _card1Fade,
                                  child: _RoleSelectionCard(
                                    title: 'Siswa',
                                    isSelected: _selectedRole == 'siswa',
                                    isAlumni: false,
                                    onSelect: () => setState(() => _selectedRole = 'siswa'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SlideTransition(
                                position: _card2Slide,
                                child: FadeTransition(
                                  opacity: _card2Fade,
                                  child: _RoleSelectionCard(
                                    title: 'Alumni',
                                    isSelected: _selectedRole == 'alumni',
                                    isAlumni: true,
                                    onSelect: () => setState(() => _selectedRole = 'alumni'),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 48),

                          // Tombol Mulai & Navigasi bawah dengan transisi halus & micro-interaction
                          SlideTransition(
                            position: _bottomSlide,
                            child: FadeTransition(
                              opacity: _bottomFade,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    child: GestureDetector(
                                      onTapDown: (_) => setState(() => _isButtonPressed = true),
                                      onTapUp: (_) => setState(() => _isButtonPressed = false),
                                      onTapCancel: () => setState(() => _isButtonPressed = false),
                                      child: AnimatedScale(
                                        scale: _isButtonPressed ? 0.96 : 1.0,
                                        duration: const Duration(milliseconds: 140),
                                        curve: Curves.easeInOut,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 44,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => RegisterScreen(role: _selectedRole),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: Colors.white,
                                              elevation: _isButtonPressed ? 1 : 4,
                                              shadowColor: AppColors.primary.withOpacity(0.35),
                                              shape: const StadiumBorder(),
                                            ),
                                            child: Text(
                                              'Mulai',
                                              style: AppFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // "Sudah Memiliki Akun? Masuk Sekarang"
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sudah Memiliki Akun? ',
                                        style: AppFonts.inter(
                                          fontSize: 12.5,
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
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleSelectionCard extends StatelessWidget {
  const _RoleSelectionCard({
    required this.title,
    required this.isSelected,
    required this.isAlumni,
    required this.onSelect,
  });

  final String title;
  final bool isSelected;
  final bool isAlumni;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    // Siswa terpilih border biru #315EE8, Alumni tidak terpilih border ungu muda #E9D5FF
    final borderColor = isSelected ? AppColors.primary : AppColors.cardBorderPurple;
    final circleColor = isSelected ? AppColors.circleIconBg : const Color(0xFFE2E8F0);
    final iconColor = isSelected ? AppColors.primary : const Color(0xFF94A3B8);
    final titleColor = isSelected ? AppColors.navy : const Color(0xFF8A94A6);
    final descColor = isSelected
        ? AppColors.navy.withOpacity(0.8)
        : const Color(0xFFA0AEC0);

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedScale(
        scale: isSelected ? 1.025 : 0.975,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: 152,
          height: 226,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.16),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Lingkaran ikon 63 dp: topi wisuda untuk Siswa, avatar person untuk Alumni
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                width: 63,
                height: 63,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Center(
                  child: isAlumni
                      ? Icon(
                          Icons.person_rounded,
                          color: iconColor,
                          size: 38,
                        )
                      : SvgPicture.asset(
                          'assets/icons/cap.svg',
                          width: 32,
                          height: 32,
                          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                          placeholderBuilder: (_) => Icon(
                            Icons.school_rounded,
                            color: iconColor,
                            size: 32,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 18),

              // Judul: "Siswa" atau "Alumni"
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                style: AppFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
                child: Text(title),
              ),

              const SizedBox(height: 8),

              // Deskripsi persis dari desain: "Lorem Ipsum dolor sit / amet"
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                textAlign: TextAlign.center,
                style: AppFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: descColor,
                  height: 1.35,
                ),
                child: const Text('Lorem Ipsum dolor sit\namet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
