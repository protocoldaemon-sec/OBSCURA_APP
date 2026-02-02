import 'privacy_level.dart';

class SwapRequest {
  final String tokenIn;
  final String tokenOut;
  final String amountIn;
  final String minAmountOut;
  final int? deadline;
  final PrivacyLevel privacyLevel;

  SwapRequest({
    required this.tokenIn,
    required this.tokenOut,
    required this.amountIn,
    required this.minAmountOut,
    this.deadline,
    this.privacyLevel = PrivacyLevel.shielded,
  });

  Map<String, dynamic> toJson() {
    return {
      'tokenIn': tokenIn,
      'tokenOut': tokenOut,
      'amountIn': amountIn,
      'minAmountOut': minAmountOut,
      if (deadline != null) 'deadline': deadline,
      'privacyLevel': privacyLevel.name,
    };
  }
}
