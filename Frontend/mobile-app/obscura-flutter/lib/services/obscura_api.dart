import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Obscura API Client
/// Connects Flutter app to Obscura backend
class ObscuraApiService {
  ObscuraApiService._({this.baseUrl = _defaultBaseUrl});

  static const String _defaultBaseUrl =
      'https://obscurabackend-production.up.railway.app';

  final String baseUrl;

  static ObscuraApiService? _instance;

  static ObscuraApiService get instance {
    _instance ??= ObscuraApiService._();
    return _instance!;
  }

  static void init(String? customBaseUrl) {
    _instance = ObscuraApiService._(
      baseUrl: customBaseUrl ?? _defaultBaseUrl,
    );
  }

  Future<T> _request<T>(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    late http.Response response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          ...?headers,
        });
        break;
      case 'POST':
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PATCH':
        response = await http.patch(
          url,
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'DELETE':
        response = await http.delete(url, headers: {
          'Content-Type': 'application/json',
          ...?headers,
        });
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }

    if (response.statusCode != 200) {
      final errorJson = jsonDecode(response.body);
      throw ApiError(
        message: errorJson['error'] ?? 'Unknown error',
        statusCode: response.statusCode,
      );
    }

    final responseJson = jsonDecode(response.body);
    return responseJson as T;
  }

  // Health check
  Future<HealthResponse> health() async {
    final json = await _request<Map<String, dynamic>>('/health');
    return HealthResponse.fromJson(json);
  }

  // Get API info
  Future<Map<String, dynamic>> info() async {
    return await _request<Map<String, dynamic>>('/');
  }

  // Create private transfer
  Future<IntentResponse> transfer(TransferRequest params) async {
    final json = await _request<Map<String, dynamic>>(
      '/api/v1/transfer',
      method: 'POST',
      body: params.toJson(),
    );
    return IntentResponse.fromJson(json);
  }

  // Create private swap
  Future<IntentResponse> swap(SwapRequest params) async {
    final json = await _request<Map<String, dynamic>>(
      '/api/v1/swap',
      method: 'POST',
      body: params.toJson(),
    );
    return IntentResponse.fromJson(json);
  }

  // Get intent status
  Future<Map<String, dynamic>> getIntent(String intentId) async {
    return await _request<Map<String, dynamic>>('/api/v1/intents/$intentId');
  }

  // Get quotes
  Future<QuoteResponse> getQuotes(QuoteRequest params) async {
    final json = await _request<Map<String, dynamic>>(
      '/api/v1/quotes',
      method: 'POST',
      body: params.toJson(),
    );
    return QuoteResponse.fromJson(json);
  }

  // Get pending batches
  Future<Map<String, dynamic>> getBatches() async {
    return await _request<Map<String, dynamic>>('/api/v1/batches');
  }

  // Create quote request for Dark OTC
  Future<Map<String, dynamic>> createQuoteRequest(Map<String, dynamic> params) async {
    return await _request<Map<String, dynamic>>(
      '/api/v1/rfq/quote-request',
      method: 'POST',
      body: params,
    );
  }

  // Get all quote requests
  Future<Map<String, dynamic>> getQuoteRequests() async {
    return await _request<Map<String, dynamic>>('/api/v1/rfq/quote-requests');
  }

  // Submit quote
  Future<Map<String, dynamic>> submitQuote(Map<String, dynamic> params) async {
    return await _request<Map<String, dynamic>>(
      '/api/v1/rfq/quote',
      method: 'POST',
      body: params,
    );
  }

  // Get quotes for a request
  Future<Map<String, dynamic>> getQuotesForRequest(String requestId) async {
    return await _request<Map<String, dynamic>>(
      '/api/v1/rfq/quote-request/$requestId/quotes',
    );
  }
}

class ApiError implements Exception {
  final String message;
  final int? statusCode;

  ApiError({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ApiError: $message${statusCode != null ? ' ($statusCode)' : ''}';
}
