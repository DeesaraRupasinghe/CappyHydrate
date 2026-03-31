import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';

/// Reminder screen — shown when a notification fires.
/// Displays the capybara image with a friendly "drink water" message.
class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // ── Animated background glows ─────────────────────────────────
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Opacity(
                  opacity: 0.2 + 0.1 * _pulse.value,
                  child: Stack(
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.15,
                        left: MediaQuery.of(context).size.width * 0.1,
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.teal.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.2,
                        right: MediaQuery.of(context).size.width * 0.1,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blue.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Alert card ────────────────────────────────────────────────
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.6), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Capybara image
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color: AppColors.teal.withOpacity(0.3),
                                width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            AppImages.reminder,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.teal.withOpacity(0.3),
                              child: const Icon(Icons.pets,
                                  size: 60, color: AppColors.teal),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // "Hey there!" heading with animated drops
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _BouncingDrop(),
                            const SizedBox(width: 8),
                            const Text(
                              'Hey there!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _BouncingDrop(delay: 200),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your capybara says:',
                          style: TextStyle(
                              fontSize: 18, color: AppColors.secondaryBrown),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Drink water 💙',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Stay hydrated, friend! 🐾',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryBrown,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // I drank button
                        PrimaryButton(
                          label: 'I drank!',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.water_drop,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 12),

                        // Snooze button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.access_time,
                                color: AppColors.secondaryBrown, size: 20),
                            label: const Text(
                              'Snooze (15 min)',
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.secondaryBrown,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                  color: AppColors.backgroundBottom, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Decorative dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [0, 200, 400]
                              .map((delay) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: _BouncingDot(delay: delay),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────

class _BouncingDrop extends StatefulWidget {
  final int delay;
  const _BouncingDrop({this.delay = 0});

  @override
  State<_BouncingDrop> createState() => _BouncingDropState();
}

class _BouncingDropState extends State<_BouncingDrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _offset = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _offset.value), child: child),
      child: const Icon(Icons.water_drop,
          size: 30, color: AppColors.teal),
    );
  }
}

class _BouncingDot extends StatefulWidget {
  final int delay;
  const _BouncingDot({this.delay = 0});

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween<double>(begin: 0.6, end: 1.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.teal,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
