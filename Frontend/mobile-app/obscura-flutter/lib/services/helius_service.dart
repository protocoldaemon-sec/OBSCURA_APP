import 'dart:convert';
import 'package:http/http.dart' as http;

/// Helius RPC Service for Solana
/// Provides enhanced RPC, webhooks, and transaction monitoring
class HeliusService {
  HeliusService._({
    required this.apiKey,
    this.baseUrl = 'https://rpc.helius.xyz',
  });

  final String apiKey;
  final String baseUrl;

  static HeliusService? _instance;

  static HeliusService get instance {
    if (_instance == null) {
      throw Exception('HeliusService not initialized. Call init() first.');
    }
    return _instance!;
  }

  static void init(String apiKey, {String? baseUrl}) {
    _instance = HeliusService._(
      apiKey: apiKey,
      baseUrl: baseUrl ?? 'https://rpc.helius.xyz',
    );
  }

  /// Get account balance
  Future<double> getBalance(String address) async {
    final response = await _rpcCall('getBalance', [address, 'confirmed']);

    if (response['result'] == null) {
      throw HeliusError('Failed to get balance');
    }

    final lamports = response['result']['value'] as int;
    return lamports / 1e9; // Convert to SOL
  }

  /// Get account info
  Future<Map<String, dynamic>> getAccountInfo(String address) async {
    final response = await _rpcCall('getAccountInfo', [
      address,
      {'encoding': 'base64'}
    ]);

    if (response['result'] == null) {
      throw HeliusError('Failed to get account info');
    }

    return response['result'] as Map<String, dynamic>;
  }

  /// Get recent transactions for an address
  Future<List<Map<String, dynamic>>> getSignaturesForAddress(
    String address, {
    int limit = 10,
  }) async {
    final response = await _rpcCall('getSignaturesForAddress', [
      address,
      {'limit': limit}
    ]);

    if (response['result'] == null) {
      return [];
    }

    return (response['result'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  /// Get transaction details
  Future<Map<String, dynamic>> getTransaction(String signature) async {
    final response = await _rpcCall('getTransaction', [
      signature,
      {'encoding': 'jsonParsed'}
    ]);

    if (response['result'] == null) {
      throw HeliusError('Failed to get transaction');
    }

    return response['result'] as Map<String, dynamic>;
  }

  /// Send transaction
  Future<String> sendTransaction(String transaction) async {
    final response = await _rpcCall('sendTransaction', [
      transaction,
      {'encoding': 'base64'}
    ]);

    if (response['result'] == null) {
      throw HeliusError('Failed to send transaction');
    }

    return response['result'] as String;
  }

  /// Get latest blockhash
  Future<Map<String, dynamic>> getLatestBlockhash() async {
    final response =
        await _rpcCall('getLatestBlockhash', [{'commitment': 'confirmed'}]);

    if (response['result'] == null) {
      throw HeliusError('Failed to get latest blockhash');
    }

    return response['result']['value'] as Map<String, dynamic>;
  }

  /// Get asset (compressed NFT or token) by owner
  Future<List<Map<String, dynamic>>> getAssetsByOwner(String address) async {
    final url = Uri.parse(
        '$baseUrl/v0/addresses/$address/assets?api-key=$apiKey');

    final response = await http.Client().send(http.Request('GET', url));

    if (response.statusCode != 200) {
      throw HeliusError('Failed to get assets');
    }

    final body = await response.stream.bytesToString();
    final json = jsonDecode(body);

    return (json['items'] as List? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  /// Get token accounts by owner
  Future<List<Map<String, dynamic>>> getTokenAccounts(String address) async {
    final response = await _rpcCall('getTokenAccountsByOwner', [
      address,
      {'programId': 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA'},
      {'encoding': 'jsonParsed'}
    ]);

    if (response['result'] == null) {
      return [];
    }

    return (response['result']['value'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  /// Create webhook for transaction monitoring
  Future<Map<String, dynamic>> createWebhook({
    required String webhookUrl,
    required List<WebhookEventType> eventTypes,
    String? accountAddress,
  }) async {
    final url = Uri.parse('$baseUrl/v0/webhooks?api-key=$apiKey');

    final body = jsonEncode({
      'webhookURL': webhookUrl,
      'transactionTypes': eventTypes.map((e) => e.name).toList(),
      if (accountAddress != null) 'accountAddresses': [accountAddress],
    });

    final request = http.Request('POST', url);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';

    final response = await http.Client().send(request);

    if (response.statusCode != 200) {
      throw HeliusError('Failed to create webhook');
    }

    final responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody) as Map<String, dynamic>;
  }

  /// Get asset proof (for compressed NFTs)
  Future<Map<String, dynamic>> getAssetProof(String assetId) async {
    final url = Uri.parse('$baseUrl/v0/asset/$assetId/proof?api-key=$apiKey');

    final response = await http.Client().send(http.Request('GET', url));

    if (response.statusCode != 200) {
      throw HeliusError('Failed to get asset proof');
    }

    final body = await response.stream.bytesToString();
    return jsonDecode(body) as Map<String, dynamic>;
  }

  /// Generic RPC call
  Future<Map<String, dynamic>> _rpcCall(
    String method,
    List<dynamic> params,
  ) async {
    final url = Uri.parse('$baseUrl/?api-key=$apiKey');

    final body = jsonEncode({
      'jsonrpc': '2.0',
      'id': 1,
      'method': method,
      'params': params,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw HeliusError('RPC call failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body);

    if (json['error'] != null) {
      throw HeliusError(json['error']['message']);
    }

    return json as Map<String, dynamic>;
  }
}

enum WebhookEventType {
  TRANSACTION,
  NATIVE_TRANSFER,
  TOKEN_TRANSFER,
  COMPRESSED_NFT_TRANSFER,
  COMPRESSED_NFT_SALE,
}

class HeliusError implements Exception {
  final String message;

  HeliusError(this.message);

  @override
  String toString() => 'HeliusError: $message';
}
