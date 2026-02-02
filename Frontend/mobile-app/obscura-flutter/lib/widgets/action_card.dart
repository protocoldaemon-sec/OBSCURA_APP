import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;
  final bool locked;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        child: Opacity(
          opacity: locked ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xB3FFFFFF), // rgba(255,255,255,0.7)
                  ),
                ),
                if (locked) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Connect wallet to use',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.statusWarning,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
