import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/gradient_background.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';

/// Progress screen — shows today's progress, a weekly overview, and a
/// motivational message.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  // Mock weekly data (in production this would come from persistent storage)
  static const _weeklyData = [
    (day: 'Mon', completed: 4, goal: 4),
    (day: 'Tue', completed: 3, goal: 4),
    (day: 'Wed', completed: 4, goal: 4),
    (day: 'Thu', completed: 2, goal: 4),
    (day: 'Fri', completed: 4, goal: 4),
    (day: 'Sat', completed: 3, goal: 4),
    (day: 'Sun', completed: 2, goal: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final current = state.waterCount;
    final total = state.settings.totalBottles;
    final percentage = total > 0 ? (current / total) : 0.0;

    final mood = percentage >= 1.0
        ? 'Amazing! 🎉'
        : percentage >= 0.75
            ? "You're doing great! 💪"
            : percentage >= 0.5
                ? 'Keep going! 😊'
                : "Let's hydrate! 💧";

    final capyStatus = percentage >= 0.75 ? 'super happy' : 'cheering for you';

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                        child: const Icon(Icons.arrow_back,
                            size: 20, color: AppColors.primaryOrange),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Your Progress',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Spacer to balance the back button
                    const SizedBox(width: 42),
                  ],
                ),
              ),

              // ── Scrollable content ────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Capybara mood card
                      _GlassCard(
                        child: Column(
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
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
                                AppImages.progress,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.teal.withOpacity(0.3),
                                  child: const Icon(Icons.pets,
                                      size: 60, color: AppColors.teal),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              mood,
                              style: const TextStyle(
                                fontSize: 22,
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your capybara is $capyStatus!',
                              style: const TextStyle(
                                  fontSize: 15, color: AppColors.secondaryBrown),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Today's progress
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 18, color: AppColors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "Today's Progress",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.secondaryBrown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$current bottles',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.secondaryBrown)),
                                Text('$total bottles goal',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.secondaryBrown)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: LinearProgressIndicator(
                                value: percentage.clamp(0.0, 1.0),
                                minHeight: 28,
                                backgroundColor:
                                    AppColors.backgroundBottom.withOpacity(0.5),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.teal),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                '${(percentage * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ),
                            const Center(
                              child: Text(
                                'completed',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.secondaryBrown),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Weekly bar chart
                      _GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.emoji_events,
                                    size: 18, color: Color(0xFFF4A261)),
                                SizedBox(width: 8),
                                Text(
                                  'This Week',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.secondaryBrown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _WeeklyChart(data: _weeklyData),
                            const SizedBox(height: 16),
                            const Divider(color: AppColors.backgroundBottom),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Expanded(
                                    child: _StatCell(
                                        value: '5', label: 'Days completed')),
                                Expanded(
                                    child: _StatCell(
                                        value: '22', label: 'Total bottles')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Motivational quote
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.teal.withOpacity(0.25),
                              AppColors.blue.withOpacity(0.25),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '"Keep up the great work! Your body thanks you!" 💙',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.secondaryBrown,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '- Your caring capybara',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.secondaryBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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
}

// ── Helper widgets ─────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;

  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryOrange,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: AppColors.secondaryBrown),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<({String day, int completed, int goal})> data;
  const _WeeklyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((d) {
          final pct = d.goal > 0 ? d.completed / d.goal : 0.0;
          final full = pct >= 1.0;
          final high = pct >= 0.75;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (full)
                  const Text('✨', style: TextStyle(fontSize: 14))
                else
                  const SizedBox(height: 20),
                const SizedBox(height: 2),
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: pct.clamp(0.05, 1.0),
                    child: Container(
                      width: 28,
                      decoration: BoxDecoration(
                        gradient: full || high
                            ? const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [AppColors.teal, AppColors.blue],
                              )
                            : null,
                        color: full || high ? null : AppColors.backgroundBottom,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  d.day,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.secondaryBrown),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
