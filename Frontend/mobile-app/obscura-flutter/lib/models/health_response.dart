class HealthResponse {
  final String status;
  final String timestamp;
  final HealthServices services;

  HealthResponse({
    required this.status,
    required this.timestamp,
    required this.services,
  });

  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      status: json['status'] as String,
      timestamp: json['timestamp'] as String,
      services: HealthServices.fromJson(
        json['services'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  bool get isHealthy => status == 'healthy';
}

class HealthServices {
  final String auth;
  final String aggregator;

  HealthServices({
    required this.auth,
    required this.aggregator,
  });

  factory HealthServices.fromJson(Map<String, dynamic> json) {
    return HealthServices(
      auth: json['auth'] as String? ?? 'unknown',
      aggregator: json['aggregator'] as String? ?? 'unknown',
    );
  }
}
