import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PrivacyLevelCard extends StatelessWidget {
  final String icon;
  final String name;
  final String description;

  const PrivacyLevelCard({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: AppColors.borderDefault,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
