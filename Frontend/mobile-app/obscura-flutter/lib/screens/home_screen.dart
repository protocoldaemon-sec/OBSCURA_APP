import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../theme/theme.dart';
import '../widgets/wallet_button.dart';
import '../widgets/action_card.dart';
import '../widgets/privacy_level_card.dart';
import 'transfer_screen.dart';
import 'swap_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApiProvider>().checkHealth();
      context.read<WalletProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),
                const SizedBox(height: AppSpacing.lg),
                _buildHeader(),
                const SizedBox(height: AppSpacing.xl),
                _buildWalletCard(context),
                const SizedBox(height: AppSpacing.lg),
                _buildNetworkStatusCard(context),
                const SizedBox(height: AppSpacing.xl),
                _buildActions(context),
                const SizedBox(height: AppSpacing.xl),
                _buildPrivacySection(),
                const SizedBox(height: AppSpacing.xl),
                _buildPoweredBy(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(),
        const WalletButton(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.brandPrimary,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: const Center(
        child: Text(
          'O',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'OBSCURA',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Post-Quantum Private Transactions',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    if (!wallet.connected || wallet.address == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        gradient: AppGradients.cardGradient,
        border: Border.all(
          color: AppColors.brandPrimary,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      wallet.chain.displayName,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  wallet.balance ?? '0.00',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              wallet.formatWalletAddress,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkStatusCard(BuildContext context) {
    final api = context.watch<ApiProvider>();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: AppColors.borderDefault,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: api.isHealthy
                      ? AppColors.statusSuccess
                      : AppColors.statusError,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'Network Status',
                style: AppTextStyles.label,
              ),
            ],
          ),
          if (api.healthLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandPrimary),
              ),
            )
          else if (api.isHealthy)
            const Text(
              'Connected',
              style: TextStyle(
                color: AppColors.statusSuccess,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            const Text(
              'Offline',
              style: TextStyle(
                color: AppColors.statusError,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Column(
      children: [
        ActionCard(
          icon: '🔒',
          title: 'Private Transfer',
          description: 'Send tokens with hidden amounts',
          gradient: AppGradients.purpleToBlue,
          onTap: () {
            Navigator.pushNamed(context, '/transfer');
          },
          locked: !wallet.connected,
        ),
        const SizedBox(height: AppSpacing.md),
        ActionCard(
          icon: '🔄',
          title: 'Private Swap',
          description: 'Swap tokens anonymously',
          gradient: AppGradients.blueToLightBlue,
          onTap: () {
            Navigator.pushNamed(context, '/swap');
          },
          locked: !wallet.connected,
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Levels',
          style: AppTextStyles.label.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(
              child: PrivacyLevelCard(
                icon: '🛡️',
                name: 'Shielded',
                description: 'Maximum privacy',
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PrivacyLevelCard(
                icon: '📋',
                name: 'Compliant',
                description: 'With viewing keys',
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PrivacyLevelCard(
                icon: '🔓',
                name: 'Transparent',
                description: 'Debug mode',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPoweredBy() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.borderDefault,
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'POWERED BY',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.md,
          children: [
            _buildPartnerLogo('Daemon Protocol'),
            _buildPartnerLogo('Arcium'),
            _buildPartnerLogo('Helius'),
            _buildPartnerLogo('Light Protocol'),
          ],
        ),
      ],
    );
  }

  Widget _buildPartnerLogo(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
