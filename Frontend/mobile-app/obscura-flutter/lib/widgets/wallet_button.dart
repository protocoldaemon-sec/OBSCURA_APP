import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../theme/theme.dart';
import 'wallet_modal.dart';

class WalletButton extends StatelessWidget {
  const WalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    if (wallet.connected && wallet.address != null) {
      return _buildConnectedButton(context, wallet);
    }

    return _buildConnectButton(context);
  }

  Widget _buildConnectButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showWalletModal(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.purpleToBlue,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: const Text(
          'Connect',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectedButton(BuildContext context, WalletProvider wallet) {
    return GestureDetector(
      onTap: () => _showWalletModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: AppColors.brandPrimary,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.statusSuccess,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              wallet.formatWalletAddress,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const WalletModal(),
    );
  }
}
