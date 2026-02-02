class QuoteRequest {
  final String sourceChain;
  final String targetChain;
  final String inputAsset;
  final String outputAsset;
  final String amount;

  QuoteRequest({
    required this.sourceChain,
    required this.targetChain,
    required this.inputAsset,
    required this.outputAsset,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'sourceChain': sourceChain,
      'targetChain': targetChain,
      'inputAsset': inputAsset,
      'outputAsset': outputAsset,
      'amount': amount,
    };
  }
}

class QuoteResponse {
  final List<Quote> quotes;
  final String? error;

  QuoteResponse({
    required this.quotes,
    this.error,
  });

  factory QuoteResponse.fromJson(Map<String, dynamic> json) {
    return QuoteResponse(
      quotes: (json['quotes'] as List<dynamic>?)
              ?.map((e) => Quote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }
}

class Quote {
  final String provider;
  final String inputAmount;
  final String outputAmount;
  final String priceImpact;
  final String gasEstimate;
  final int? expiresAt;

  Quote({
    required this.provider,
    required this.inputAmount,
    required this.outputAmount,
    required this.priceImpact,
    required this.gasEstimate,
    this.expiresAt,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      provider: json['provider'] as String,
      inputAmount: json['inputAmount'] as String,
      outputAmount: json['outputAmount'] as String,
      priceImpact: json['priceImpact'] as String,
      gasEstimate: json['gasEstimate'] as String,
      expiresAt: json['expiresAt'] as int?,
    );
  }
}
