import 'privacy_level.dart';

class TransferRequest {
  final String recipient;
  final String asset;
  final String amount;
  final ChainType sourceChain;
  final ChainType? targetChain;
  final PrivacyLevel privacyLevel;

  TransferRequest({
    required this.recipient,
    required this.asset,
    required this.amount,
    required this.sourceChain,
    this.targetChain,
    this.privacyLevel = PrivacyLevel.shielded,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'asset': asset,
      'amount': amount,
      'sourceChain': sourceChain.name,
      if (targetChain != null) 'targetChain': targetChain!.name,
      'privacyLevel': privacyLevel.name,
    };
  }
}

enum ChainType { ethereum, solana, polygon, arbitrum }

extension ChainTypeExtension on ChainType {
  String get displayName {
    switch (this) {
      case ChainType.ethereum:
        return 'Ethereum';
      case ChainType.solana:
        return 'Solana';
      case ChainType.polygon:
        return 'Polygon';
      case ChainType.arbitrum:
        return 'Arbitrum';
    }
  }

  String get symbol {
    switch (this) {
      case ChainType.ethereum:
        return 'ETH';
      case ChainType.solana:
        return 'SOL';
      case ChainType.polygon:
        return 'MATIC';
      case ChainType.arbitrum:
        return 'ARB';
    }
  }
}
