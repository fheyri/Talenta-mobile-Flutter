import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/app_fonts.dart';
import '../core/app_theme.dart';
import 'role_selection_screen.dart';

/// Layar 1: Splash "Mulai" (Parisian Luxury Haute-Couture Edition)
/// - Logo T anggun muncul dengan soft bloom & subtle organic float.
/// - Teks TALENTA di bawah logo muncul dengan animasi mewah ala studio Paris:
///   transisi slide-up halus, ekspansi skala lembut, dan kilau cahaya (luminous sheen sweep).
/// - Tagline dan tombol "Mulai" muncul bertahap (staggered cascade) dengan feedback sentuh interaktif.
/// - Halaman pertama tanpa tombol back.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatController;

  // Animasi Logo T
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;

  // Animasi Teks TALENTA (Parisian Luxury Reveal)
  late final Animation<double> _talentaOpacity;
  late final Animation<double> _talentaScale;
  late final Animation<Offset> _talentaSlide;
  late final Animation<double> _talentaSheen;

  // Animasi Tagline
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  // Animasi Tombol Mulai
  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonSlide;

  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    // 1. Controller untuk rangkaian entrance mewah (1800 ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // 2. Controller ambient float halus berulang (3200 ms) untuk rasa "hidup"
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    // --- LOGO T (0.05 - 0.45) ---
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.05, 0.42, curve: Curves.easeOutCubic),
      ),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.05, 0.50, curve: Curves.easeOutBack),
      ),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.05, 0.48, curve: Curves.easeOutQuart),
      ),
    );

    // --- TEKS TALENTA (0.28 - 0.70) (Parisian Haute-Couture Slide & Sheen) ---
    _talentaOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.28, 0.60, curve: Curves.easeOut),
      ),
    );
    _talentaScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.28, 0.68, curve: Curves.easeOutCubic),
      ),
    );
    _talentaSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.28, 0.70, curve: Curves.easeOutQuart),
      ),
    );

    // Kilau cahaya diagonal melintasi teks TALENTA setelah tiba di posisinya (0.55 - 0.88)
    _talentaSheen = Tween<double>(begin: -1.2, end: 1.6).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.88, curve: Curves.easeInOutCubic),
      ),
    );

    // --- TAGLINE (0.58 - 0.85) ---
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.58, 0.85, curve: Curves.easeOut),
      ),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.58, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // --- TOMBOL MULAI (0.72 - 1.0) ---
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.72, 0.98, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.72, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Ambient Glow Halus di Tengah Atas (Menciptakan depth & kemewahan)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.18,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final scale = 1.0 + (_floatController.value * 0.08);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFDCEBFC).withOpacity(0.55),
                            const Color(0xFFEEF5FE).withOpacity(0.20),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // 1. LOGO T dengan animasi bloom, subtle float, dan scale
                  SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            final floatOffset = math.sin(_floatController.value * 2 * math.pi) * 3.5;
                            return Transform.translate(
                              offset: Offset(0, floatOffset),
                              child: child,
                            );
                          },
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 133,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. TEKS TALENTA DENGAN ANIMASI PARSIAN LUXURY REVEAL & LUMINOUS SHEEN
                  SlideTransition(
                    position: _talentaSlide,
                    child: FadeTransition(
                      opacity: _talentaOpacity,
                      child: ScaleTransition(
                        scale: _talentaScale,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Gambar teks TALENTA asli
                                  Image.asset(
                                    'assets/images/logo_text.png',
                                    width: 265,
                                    fit: BoxFit.contain,
                                  ),

                                  // Luminous Sheen Sweep: Kilau cahaya berlian ala luxury brand
                                  if (_entranceController.value >= 0.55 &&
                                      _entranceController.value <= 0.92)
                                    Positioned.fill(
                                      child: ClipRect(
                                        child: Transform.translate(
                                          offset: Offset(
                                            _talentaSheen.value * 265,
                                            0,
                                          ),
                                          child: Transform.rotate(
                                            angle: 0.35,
                                            child: Container(
                                              width: 60,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white.withOpacity(0.0),
                                                    Colors.white.withOpacity(0.65),
                                                    Colors.white.withOpacity(0.0),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. TAGLINE 3 BARIS DENGAN STAGGERED FADE & SLIDE ELEGAN
                  SlideTransition(
                    position: _taglineSlide,
                    child: FadeTransition(
                      opacity: _taglineOpacity,
                      child: Text(
                        'Platform Terintegrasi untuk Pengelolaan\ninformasi dan Peluang Karier\nSiswa dan Alumni',
                        textAlign: TextAlign.center,
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          height: 1.35,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 4),

                  // 4. TOMBOL MULAI DENGAN TRANSISI HALUS & SENTUHAN INTERAKTIF
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonOpacity,
                      child: Padding(
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
                                      builder: (_) => const RoleSelectionScreen(),
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
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
