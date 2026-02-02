class IntentResponse {
  final String intentId;
  final String stealthAddress;
  final String commitment;
  final int expiresAt;
  final String? type;

  IntentResponse({
    required this.intentId,
    required this.stealthAddress,
    required this.commitment,
    required this.expiresAt,
    this.type,
  });

  factory IntentResponse.fromJson(Map<String, dynamic> json) {
    return IntentResponse(
      intentId: json['intentId'] as String,
      stealthAddress: json['stealthAddress'] as String,
      commitment: json['commitment'] as String,
      expiresAt: json['expiresAt'] as int,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intentId': intentId,
      'stealthAddress': stealthAddress,
      'commitment': commitment,
      'expiresAt': expiresAt,
      if (type != null) 'type': type,
    };
  }
}
