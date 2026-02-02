import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ChipSelector<T> extends StatelessWidget {
  final List<T> options;
  final T selectedOption;
  final void Function(T) onSelect;
  final String Function(T) labelBuilder;

  const ChipSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((option) {
        final isSelected = option == selectedOption;
        return GestureDetector(
          onTap: () => onSelect(option),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.brandPrimary
                  : AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(AppBorderRadius.full),
              border: Border.all(
                color: isSelected
                    ? AppColors.brandPrimary
                    : AppColors.borderDefault,
                width: 1,
              ),
            ),
            child: Text(
              labelBuilder(option),
              style: TextStyle(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
