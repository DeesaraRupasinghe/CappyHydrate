import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/water_settings.dart';
import '../services/app_state.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_colors.dart';

/// Setup screen — lets the user choose their daily bottle goal and sleep times.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late int _selectedBottles;
  late TimeOfDay _sleepStart; // bedtime
  late TimeOfDay _sleepEnd;   // wake-up time

  @override
  void initState() {
    super.initState();
    final settings = context.read<AppState>().settings;
    _selectedBottles = settings.totalBottles;
    final startParts = WaterSettings.parseTime(settings.sleepStart);
    final endParts = WaterSettings.parseTime(settings.sleepEnd);
    _sleepStart = TimeOfDay(hour: startParts[0], minute: startParts[1]);
    _sleepEnd = TimeOfDay(hour: endParts[0], minute: endParts[1]);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(
      {required TimeOfDay current,
      required ValueChanged<TimeOfDay> onPicked}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) {
        // Tint the time picker to match our brand colour
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: Colors.white,
              surface: AppColors.backgroundTop,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onPicked(picked);
  }

  void _handleSave() {
    final settings = WaterSettings(
      totalBottles: _selectedBottles,
      sleepStart: _formatTime(_sleepStart),
      sleepEnd: _formatTime(_sleepEnd),
    );
    context.read<AppState>().updateSettings(settings);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────────
                const SizedBox(height: 16),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.teal, AppColors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.water_drop,
                      size: 36, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Set your daily water goal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Help your capybara keep you hydrated!',
                  style: TextStyle(fontSize: 15, color: AppColors.secondaryBrown),
                ),
                const SizedBox(height: 28),

                // ── Bottles selection ────────────────────────────────────────
                _Card(
                  child: Column(
                    children: [
                      const Text(
                        'How many bottles per day?',
                        style: TextStyle(
                            fontSize: 17, color: AppColors.secondaryBrown),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: List.generate(8, (i) {
                          final num = i + 1;
                          final selected = _selectedBottles == num;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedBottles = num),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: selected
                                    ? const LinearGradient(
                                        colors: [AppColors.teal, AppColors.blue],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: selected ? null : Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.blue.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.water_drop,
                                    size: 22,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.secondaryBrown,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$num',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.secondaryBrown,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selected: $_selectedBottles bottles',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryBrown,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Sleep time selector ──────────────────────────────────────
                _Card(
                  child: Column(
                    children: [
                      const Text(
                        'When do you sleep?',
                        style: TextStyle(
                            fontSize: 17, color: AppColors.secondaryBrown),
                      ),
                      const SizedBox(height: 16),
                      // Bedtime row
                      _TimeRow(
                        icon: Icons.bedtime_outlined,
                        gradientColors: const [AppColors.blue, AppColors.darkBlue],
                        label: 'Bedtime',
                        timeText: _formatTime(_sleepStart),
                        onTap: () => _pickTime(
                          current: _sleepStart,
                          onPicked: (t) =>
                              setState(() => _sleepStart = t),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Wake-up row
                      _TimeRow(
                        icon: Icons.wb_sunny_outlined,
                        gradientColors: const [
                          Color(0xFFF4A261),
                          Color(0xFFE76F51)
                        ],
                        label: 'Wake up time',
                        timeText: _formatTime(_sleepEnd),
                        onTap: () => _pickTime(
                          current: _sleepEnd,
                          onPicked: (t) => setState(() => _sleepEnd = t),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '💙 We\'ll remind you at the best times',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: AppColors.secondaryBrown),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Save button ──────────────────────────────────────────────
                Center(
                  child: PrimaryButton(
                    label: "Let's Start!",
                    onPressed: _handleSave,
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
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

class _TimeRow extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final String label;
  final String timeText;
  final VoidCallback onTap;

  const _TimeRow({
    required this.icon,
    required this.gradientColors,
    required this.label,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.secondaryBrown),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.backgroundBottom, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryBrown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.access_time,
                          size: 18, color: AppColors.teal),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
