import 'dart:convert';
import 'package:http/http.dart' as http;

/// Magic Block / Arcium Confidential Computing Service
/// Provides MPC (Multi-Party Computation) for enhanced privacy
class MagicBlockService {
  MagicBlockService._({
    required this.apiKey,
    this.baseUrl = 'https://api.magicblock.xyz',
  });

  final String apiKey;
  final String baseUrl;

  static MagicBlockService? _instance;

  static MagicBlockService get instance {
    if (_instance == null) {
      throw Exception('MagicBlockService not initialized. Call init() first.');
    }
    return _instance!;
  }

  static void init(String apiKey, {String? baseUrl}) {
    _instance = MagicBlockService._(
      apiKey: apiKey,
      baseUrl: baseUrl ?? 'https://api.magicblock.xyz',
    );
  }

  /// Submit computation for confidential processing
  Future<ComputationResult> submitComputation({
    required String programId,
    required Map<String, dynamic> inputs,
    ComputationType type = ComputationType.general,
  }) async {
    final url = Uri.parse('$baseUrl/v1/compute');

    final body = jsonEncode({
      'programId': programId,
      'inputs': inputs,
      'type': type.name,
    });

    final response = await _authenticatedRequest('POST', url, body: body);

    if (response.statusCode != 200) {
      final error = await response.stream.bytesToString();
      throw MagicBlockError('Failed to submit computation: $error');
    }

    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);

    return ComputationResult.fromJson(json);
  }

  /// Get computation status
  Future<ComputationStatus> getComputationStatus(String computationId) async {
    final url = Uri.parse('$baseUrl/v1/compute/$computationId');

    final response = await _authenticatedRequest('GET', url);

    if (response.statusCode != 200) {
      throw MagicBlockError('Failed to get computation status');
    }

    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);

    return ComputationStatus.fromJson(json);
  }

  /// Submit encrypted transaction
  Future<EncryptedTransactionResult> submitEncryptedTransaction({
    required String encryptedData,
    required List<String> nodes,
  }) async {
    final url = Uri.parse('$baseUrl/v1/encrypted-tx');

    final body = jsonEncode({
      'encryptedData': encryptedData,
      'nodes': nodes,
    });

    final response = await _authenticatedRequest('POST', url, body: body);

    if (response.statusCode != 200) {
      throw MagicBlockError('Failed to submit encrypted transaction');
    }

    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);

    return EncryptedTransactionResult.fromJson(json);
  }

  /// Get available compute nodes
  Future<List<ComputeNode>> getAvailableNodes() async {
    final url = Uri.parse('$baseUrl/v1/nodes');

    final response = await _authenticatedRequest('GET', url);

    if (response.statusCode != 200) {
      throw MagicBlockError('Failed to get available nodes');
    }

    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);

    return (json['nodes'] as List)
        .map((e) => ComputeNode.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create secret sharing for MPC
  Future<SecretShareResult> createSecretShare({
    required String secret,
    required int threshold,
    required int totalShares,
  }) async {
    final url = Uri.parse('$baseUrl/v1/secret-share');

    final body = jsonEncode({
      'secret': secret,
      'threshold': threshold,
      'totalShares': totalShares,
    });

    final response = await _authenticatedRequest('POST', url, body: body);

    if (response.statusCode != 200) {
      throw MagicBlockError('Failed to create secret share');
    }

    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);

    return SecretShareResult.fromJson(json);
  }

  /// Verify MPC computation result
  Future<bool> verifyComputation({
    required String computationId,
    required String proof,
  }) async {
    final url = Uri.parse('$baseUrl/v1/verify');

    final body = jsonEncode({
      'computationId': computationId,
      'proof': proof,
    });

    final response = await _authenticatedRequest('POST', url, body: body);

    if (response.statusCode != 200) {
      return false;
    }

    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);

    return json['valid'] as bool? ?? false;
  }

  /// Get compute cost estimate
  Future<ComputeCostEstimate> getComputeCost({
    required String programId,
    required Map<String, dynamic> inputs,
  }) async {
    final url = Uri.parse('$baseUrl/v1/cost-estimate');

    final body = jsonEncode({
      'programId': programId,
      'inputs': inputs,
    });

    final response = await _authenticatedRequest('POST', url, body: body);

    if (response.statusCode != 200) {
      throw MagicBlockError('Failed to get cost estimate');
    }

    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);

    return ComputeCostEstimate.fromJson(json);
  }

  Future<http.StreamedResponse> _authenticatedRequest(
    String method,
    Uri url, {
    String? body,
  }) async {
    final request = http.Request(method, url);
    request.headers['X-API-Key'] = apiKey;
    request.headers['Content-Type'] = 'application/json';

    if (body != null) {
      request.body = body;
    }

    return await http.Client().send(request);
  }
}

enum ComputationType {
  general,
  zkProof,
  mpc,
  encryption,
}

class ComputationResult {
  final String computationId;
  final String status;
  final Map<String, dynamic>? result;

  ComputationResult({
    required this.computationId,
    required this.status,
    this.result,
  });

  factory ComputationResult.fromJson(Map<String, dynamic> json) {
    return ComputationResult(
      computationId: json['computationId'] as String,
      status: json['status'] as String,
      result: json['result'] as Map<String, dynamic>?,
    );
  }
}

class ComputationStatus {
  final String computationId;
  final String status;
  final int? progress;
  final String? error;
  final Map<String, dynamic>? result;

  ComputationStatus({
    required this.computationId,
    required this.status,
    this.progress,
    this.error,
    this.result,
  });

  factory ComputationStatus.fromJson(Map<String, dynamic> json) {
    return ComputationStatus(
      computationId: json['computationId'] as String,
      status: json['status'] as String,
      progress: json['progress'] as int?,
      error: json['error'] as String?,
      result: json['result'] as Map<String, dynamic>?,
    );
  }

  bool get isComplete => status == 'complete';
  bool get isPending => status == 'pending';
  bool get isProcessing => status == 'processing';
  bool get hasError => status == 'error';
}

class EncryptedTransactionResult {
  final String transactionId;
  final String encryptedSignature;
  final List<String> participatingNodes;

  EncryptedTransactionResult({
    required this.transactionId,
    required this.encryptedSignature,
    required this.participatingNodes,
  });

  factory EncryptedTransactionResult.fromJson(Map<String, dynamic> json) {
    return EncryptedTransactionResult(
      transactionId: json['transactionId'] as String,
      encryptedSignature: json['encryptedSignature'] as String,
      participatingNodes:
          (json['participatingNodes'] as List).cast<String>(),
    );
  }
}

class ComputeNode {
  final String id;
  final String address;
  final bool available;
  final int load;

  ComputeNode({
    required this.id,
    required this.address,
    required this.available,
    required this.load,
  });

  factory ComputeNode.fromJson(Map<String, dynamic> json) {
    return ComputeNode(
      id: json['id'] as String,
      address: json['address'] as String,
      available: json['available'] as bool,
      load: json['load'] as int,
    );
  }
}

class SecretShareResult {
  final List<String> shares;
  final int threshold;
  final String verificationKey;

  SecretShareResult({
    required this.shares,
    required this.threshold,
    required this.verificationKey,
  });

  factory SecretShareResult.fromJson(Map<String, dynamic> json) {
    return SecretShareResult(
      shares: (json['shares'] as List).cast<String>(),
      threshold: json['threshold'] as int,
      verificationKey: json['verificationKey'] as String,
    );
  }
}

class ComputeCostEstimate {
  final double costUsd;
  final int estimatedTimeMs;
  final int computeUnits;

  ComputeCostEstimate({
    required this.costUsd,
    required this.estimatedTimeMs,
    required this.computeUnits,
  });

  factory ComputeCostEstimate.fromJson(Map<String, dynamic> json) {
    return ComputeCostEstimate(
      costUsd: (json['costUsd'] as num).toDouble(),
      estimatedTimeMs: json['estimatedTimeMs'] as int,
      computeUnits: json['computeUnits'] as int,
    );
  }
}

class MagicBlockError implements Exception {
  final String message;

  MagicBlockError(this.message);

  @override
  String toString() => 'MagicBlockError: $message';
}
