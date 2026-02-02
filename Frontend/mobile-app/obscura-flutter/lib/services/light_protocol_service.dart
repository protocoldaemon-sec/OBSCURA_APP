import 'dart:convert';
import 'package:http/http.dart' as http;

/// Light Protocol ZK Compression Service
/// Provides 1000x cheaper storage on Solana using Zero-Knowledge proofs
class LightProtocolService {
  LightProtocolService._({
    required this.rpcUrl,
    this.compressionApiUrl = 'https://light.helius.dev',
  });

  final String rpcUrl;
  final String compressionApiUrl;

  static LightProtocolService? _instance;

  static LightProtocolService get instance {
    if (_instance == null) {
      throw Exception('LightProtocolService not initialized. Call init() first.');
    }
    return _instance!;
  }

  static void init(String rpcUrl, {String? compressionApiUrl}) {
    _instance = LightProtocolService._(
      rpcUrl: rpcUrl,
      compressionApiUrl: compressionApiUrl ?? 'https://light.helius.dev',
    );
  }

  /// Get compressed account balance
  Future<CompressedBalance> getCompressedBalance({
    required String address,
    String? mint,
  }) async {
    final url = Uri.parse('$compressionApiUrl/balance');
    final body = jsonEncode({
      'address': address,
      if (mint != null) 'mint': mint,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw LightProtocolError('Failed to get compressed balance');
    }

    final json = jsonDecode(response.body);
    return CompressedBalance.fromJson(json);
  }

  /// Get compressed asset proof
  Future<Map<String, dynamic>> getCompressedAssetProof({
    required String assetId,
  }) async {
    final url = Uri.parse('$compressionApiUrl/asset-proof/$assetId');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw LightProtocolError('Failed to get asset proof');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get compressed assets by owner
  Future<List<CompressedAsset>> getCompressedAssets({
    required String address,
    int limit = 1000,
    int page = 1,
  }) async {
    final url = Uri.parse(
      '$compressionApiUrl/assets',
    ).replace(queryParameters: {
      'owner': address,
      'limit': limit.toString(),
      'page': page.toString(),
    });

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw LightProtocolError('Failed to get compressed assets');
    }

    final json = jsonDecode(response.body);
    final items = json['items'] as List? ?? [];

    return items.map((e) => CompressedAsset.fromJson(e)).toList();
  }

  /// Verify compressed transaction
  Future<Map<String, dynamic>> verifyCompressedTransaction({
    required String transactionSignature,
  }) async {
    final url = Uri.parse('$compressionApiUrl/transaction/$transactionSignature');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw LightProtocolError('Failed to verify transaction');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Create compressed transaction
  Future<Map<String, dynamic>> createCompressedTransaction({
    required List<Map<String, dynamic>> instructions,
    required String payer,
    List<String>? additionalSigners,
  }) async {
    final url = Uri.parse('$compressionApiUrl/transaction');

    final body = jsonEncode({
      'instructions': instructions,
      'payer': payer,
      if (additionalSigners != null) 'additionalSigners': additionalSigners,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw LightProtocolError('Failed to create compressed transaction');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get compression status
  Future<Map<String, dynamic>> getCompressionStatus() async {
    final url = Uri.parse('$compressionApiUrl/status');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw LightProtocolError('Failed to get compression status');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class CompressedBalance {
  final double balance;
  final String? mint;
  final int decimals;

  CompressedBalance({
    required this.balance,
    this.mint,
    required this.decimals,
  });

  factory CompressedBalance.fromJson(Map<String, dynamic> json) {
    return CompressedBalance(
      balance: (json['balance'] as num).toDouble(),
      mint: json['mint'] as String?,
      decimals: json['decimals'] as int? ?? 0,
    );
  }
}

class CompressedAsset {
  final String id;
  final String compressionType;
  final String? owner;
  final String? delegate;
  final double? balance;
  final bool? compressed;
  final String? compressible;
  final LightMetadata? metadata;

  CompressedAsset({
    required this.id,
    required this.compressionType,
    this.owner,
    this.delegate,
    this.balance,
    this.compressed,
    this.compressible,
    this.metadata,
  });

  factory CompressedAsset.fromJson(Map<String, dynamic> json) {
    return CompressedAsset(
      id: json['id'] as String,
      compressionType: json['compression_type'] as String? ?? 'unknown',
      owner: json['owner'] as String?,
      delegate: json['delegate'] as String?,
      balance: json['balance'] != null
          ? (json['balance'] as num).toDouble()
          : null,
      compressed: json['compressed'] as bool?,
      compressible: json['compressible'] as String?,
      metadata: json['metadata'] != null
          ? LightMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LightMetadata {
  final String? name;
  final String? symbol;
  final String? uri;
  final LightMetadataCollection? collection;

  LightMetadata({
    this.name,
    this.symbol,
    this.uri,
    this.collection,
  });

  factory LightMetadata.fromJson(Map<String, dynamic> json) {
    return LightMetadata(
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      uri: json['uri'] as String?,
      collection: json['collection'] != null
          ? LightMetadataCollection.fromJson(
              json['collection'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LightMetadataCollection {
  final String? name;
  final String? address;

  LightMetadataCollection({
    this.name,
    this.address,
  });

  factory LightMetadataCollection.fromJson(Map<String, dynamic> json) {
    return LightMetadataCollection(
      name: json['name'] as String?,
      address: json['address'] as String?,
    );
  }
}

class LightProtocolError implements Exception {
  final String message;

  LightProtocolError(this.message);

  @override
  String toString() => 'LightProtocolError: $message';
}
