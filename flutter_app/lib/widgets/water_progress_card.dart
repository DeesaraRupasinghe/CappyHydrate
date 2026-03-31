import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A rounded card containing the daily water-progress display.
class WaterProgressCard extends StatelessWidget {
  final int current;
  final int total;

  const WaterProgressCard({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Numeric counter
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$current',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryOrange,
                ),
              ),
              Text(
                '/$total',
                style: const TextStyle(
                  fontSize: 32,
                  color: AppColors.secondaryBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Droplet icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (index) {
              final filled = index < current;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.water_drop,
                  size: 26,
                  color: filled ? AppColors.teal : Colors.grey.shade300,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          const Text(
            'bottles completed',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryBrown),
          ),
        ],
      ),
    );
  }
}
