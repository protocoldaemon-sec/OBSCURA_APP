import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../theme/theme.dart';
import '../widgets/chip_selector.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _assetController = TextEditingController(text: 'ETH');

  ChainType _selectedChain = ChainType.ethereum;
  PrivacyLevel _selectedPrivacy = PrivacyLevel.shielded;

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _assetController.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer() async {
    final wallet = context.read<WalletProvider>();
    final api = context.read<ApiProvider>();

    if (!wallet.connected) {
      _showErrorDialog('Wallet Required', 'Please connect your wallet first');
      return;
    }

    if (_recipientController.text.isEmpty || _amountController.text.isEmpty) {
      _showErrorDialog('Error', 'Please fill all fields');
      return;
    }

    try {
      // Sign the transaction
      final signature = await wallet.signTransaction({
        'type': 'transfer',
        'recipient': _recipientController.text,
        'amount': _amountController.text,
        'asset': _assetController.text,
        'chain': _selectedChain.name,
        'privacyLevel': _selectedPrivacy.name,
      });

      if (signature == null) {
        _showErrorDialog('Error', 'Transaction signing failed');
        return;
      }

      // Create transfer
      final result = await api.transfer(TransferRequest(
        recipient: _recipientController.text,
        asset: _assetController.text,
        amount: _amountController.text,
        sourceChain: _selectedChain,
        privacyLevel: _selectedPrivacy,
      ));

      if (result != null && mounted) {
        _showSuccessDialog(result);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error', e.toString());
      }
    }
  }

  void _showSuccessDialog(IntentResponse intent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: const Text(
          'Transfer Created',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your transfer is being processed privately.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Intent ID: ${intent.intentId}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          message,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final api = context.watch<ApiProvider>();

    // Show connect prompt if not connected
    if (!wallet.connected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Private Transfer'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🔐',
                  style: TextStyle(fontSize: 64),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Wallet Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Connect your wallet to make private transfers',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Tap the "Connect" button in the header',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.brandPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Transfer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Private Transfer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Send tokens with hidden amounts',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Wallet Info
            _buildWalletInfo(wallet),

            // Recipient
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Recipient Address',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _recipientController,
              style: AppTextStyles.body,
              decoration: const InputDecoration(
                hintText: '0x... or wallet address',
              ),
            ),

            // Amount & Asset
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Amount',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    style: AppTextStyles.body,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: '0.0',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _assetController,
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'ETH',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Available: ${wallet.balance ?? "0.00"}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),

            // Chain Selection
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Chain',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppSpacing.sm),
            ChipSelector<ChainType>(
              options: ChainType.values,
              selectedOption: _selectedChain,
              onSelect: (value) => setState(() => _selectedChain = value),
              labelBuilder: (chain) => chain.displayName,
            ),

            // Privacy Level
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Privacy Level',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppSpacing.sm),
            ChipSelector<PrivacyLevel>(
              options: PrivacyLevel.values,
              selectedOption: _selectedPrivacy,
              onSelect: (value) => setState(() => _selectedPrivacy = value),
              labelBuilder: (level) => '${level.emoji} ${level.displayName}',
            ),

            // Submit Button
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppGradients.purpleToBlue,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: ElevatedButton(
                  onPressed: api.transferLoading ? null : _handleTransfer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                  ),
                  child: api.transferLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textPrimary,
                            ),
                          ),
                        )
                      : const Text('🔒 Send Private Transfer'),
                ),
              ),
            ),

            // Result
            if (api.transferIntent != null) ...[
              const SizedBox(height: AppSpacing.lg),
              _buildResultCard(api.transferIntent!),
            ],

            // Error
            if (api.transferError != null) ...[
              const SizedBox(height: AppSpacing.lg),
              _buildErrorCard(api.transferError!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInfo(WalletProvider wallet) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
            'From: ${wallet.formatWalletAddress}',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(IntentResponse intent) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0x1010B981), // rgba(16, 185, 129, 0.1)
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: const Color(0x3010B981), // rgba(16, 185, 129, 0.3)
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('✅', style: TextStyle(fontSize: 16)),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Transfer Created',
                style: TextStyle(
                  color: AppColors.statusSuccess,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Intent ID: ${intent.intentId}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            'Commitment: ${intent.commitment.substring(0, 20)}...',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0x10EF4444), // rgba(239, 68, 68, 0.1)
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: const Color(0x30EF4444), // rgba(239, 68, 68, 0.3)
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Text('❌', style: TextStyle(fontSize: 16)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: AppColors.statusError,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
