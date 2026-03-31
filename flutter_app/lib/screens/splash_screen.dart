import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/gradient_background.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';

/// Splash screen — shown for 3 seconds with a fade-in animation, then
/// navigates to [HomeScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // Fade-in animation over 1.5 s
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Navigate to home after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decorative blurred circle (top-left)
                  _CapybaraAvatar(),
                  const SizedBox(height: 32),
                  // App title
                  const Text(
                    'Cappy Water',
                    style: TextStyle(
                      fontSize: 46,
                      color: AppColors.primaryOrange,
                      fontFamily: 'Georgia',
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  const Text(
                    'Stay hydrated with love',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.secondaryBrown,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Animated loading dots
                  const _LoadingDots(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Capybara avatar ──────────────────────────────────────────────────────────

class _CapybaraAvatar extends StatefulWidget {
  @override
  State<_CapybaraAvatar> createState() => _CapybaraAvatarState();
}

class _CapybaraAvatarState extends State<_CapybaraAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce;
  late final Animation<double> _offsetY;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _offsetY = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _bounce, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetY,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _offsetY.value), child: child),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          AppImages.splash,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _placeholder(),
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.teal.withOpacity(0.3),
        child: const Icon(Icons.water_drop,
            size: 80, color: AppColors.teal),
      );
}

// ── Loading dots ─────────────────────────────────────────────────────────────

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            // Each dot peaks at a different point in the animation cycle
            final phase = (i * 0.2);
            final t = (_controller.value + phase) % 1.0;
            final scale = 0.6 + 0.6 * (1 - (t - 0.5).abs() * 2).clamp(0, 1);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
