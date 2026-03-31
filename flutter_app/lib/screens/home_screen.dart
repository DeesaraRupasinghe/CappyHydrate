import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/gradient_background.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';
import 'setup_screen.dart';
import 'progress_screen.dart';

/// Home screen — shows the capybara, today's progress, and the "Drink Water"
/// button.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // ── Decorative blurred blobs ─────────────────────────────────
              Positioned(
                top: 60,
                right: 0,
                child: _Blob(color: AppColors.teal, size: 120, opacity: 0.18),
              ),
              Positioned(
                bottom: 160,
                left: 0,
                child: _Blob(color: AppColors.orange2, size: 140, opacity: 0.14),
              ),

              Column(
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _IconButton(
                          icon: Icons.settings_outlined,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SetupScreen()),
                          ),
                        ),
                        _IconButton(
                          icon: Icons.trending_up,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ProgressScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Main content ─────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          // Capybara image
                          _CapybaraCard(),
                          const SizedBox(height: 24),
                          // Reminder message
                          const Text(
                            'Your capybara reminds you to drink water 💧',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.secondaryBrown,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Progress card
                          WaterProgressCard(
                            current: state.waterCount,
                            total: state.settings.totalBottles,
                          ),
                          const SizedBox(height: 28),
                          // Action button
                          Center(
                            child: PrimaryButton(
                              label: state.goalReached
                                  ? 'Goal Complete! 🎉'
                                  : 'I Drank Water!',
                              onPressed:
                                  state.goalReached ? null : state.drinkWater,
                              icon: state.goalReached
                                  ? null
                                  : const Icon(Icons.water_drop,
                                      color: Colors.white, size: 22),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Next reminder
                          Text(
                            '⏰ Next reminder ${state.nextReminder}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryBrown,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────

class _CapybaraCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 4),
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
        AppImages.home,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _placeholder(),
        errorBuilder: (_, __, ___) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.teal.withOpacity(0.3),
        child: const Icon(Icons.pets, size: 80, color: AppColors.teal),
      );
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.primaryOrange),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _Blob({required this.color, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }
}
