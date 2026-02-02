import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/obscura_api.dart';

/// API State Provider for Obscura Backend operations
class ApiProvider extends ChangeNotifier {
  final _apiService = ObscuraApiService.instance;

  // Health state
  HealthResponse? _healthData;
  bool _healthLoading = false;
  String? _healthError;

  HealthResponse? get healthData => _healthData;
  bool get healthLoading => _healthLoading;
  String? get healthError => _healthError;
  bool get isHealthy => _healthData?.isHealthy ?? false;

  // Transfer state
  IntentResponse? _transferIntent;
  bool _transferLoading = false;
  String? _transferError;

  IntentResponse? get transferIntent => _transferIntent;
  bool get transferLoading => _transferLoading;
  String? get transferError => _transferError;

  // Swap state
  IntentResponse? _swapIntent;
  bool _swapLoading = false;
  String? _swapError;

  IntentResponse? get swapIntent => _swapIntent;
  bool get swapLoading => _swapLoading;
  String? get swapError => _swapError;

  // Quotes state
  List<Quote> _quotes = [];
  bool _quotesLoading = false;
  String? _quotesError;

  List<Quote> get quotes => _quotes;
  bool get quotesLoading => _quotesLoading;
  String? get quotesError => _quotesError;

  /// Check API health
  Future<bool> checkHealth() async {
    _healthLoading = true;
    _healthError = null;
    notifyListeners();

    try {
      _healthData = await _apiService.health();
      _healthLoading = false;
      notifyListeners();
      return _healthData!.isHealthy;
    } catch (e) {
      _healthError = e.toString();
      _healthLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create private transfer
  Future<IntentResponse?> transfer(TransferRequest params) async {
    _transferLoading = true;
    _transferError = null;
    _transferIntent = null;
    notifyListeners();

    try {
      _transferIntent = await _apiService.transfer(params);
      _transferLoading = false;
      notifyListeners();
      return _transferIntent;
    } catch (e) {
      _transferError = e.toString();
      _transferLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Create private swap
  Future<IntentResponse?> swap(SwapRequest params) async {
    _swapLoading = true;
    _swapError = null;
    _swapIntent = null;
    notifyListeners();

    try {
      _swapIntent = await _apiService.swap(params);
      _swapLoading = false;
      notifyListeners();
      return _swapIntent;
    } catch (e) {
      _swapError = e.toString();
      _swapLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Get quotes for cross-chain swap
  Future<List<Quote>> getQuotes(QuoteRequest params) async {
    _quotesLoading = true;
    _quotesError = null;
    _quotes = [];
    notifyListeners();

    try {
      final response = await _apiService.getQuotes(params);
      _quotes = response.quotes;
      _quotesLoading = false;
      notifyListeners();
      return _quotes;
    } catch (e) {
      _quotesError = e.toString();
      _quotesLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// Get intent status
  Future<Map<String, dynamic>?> getIntentStatus(String intentId) async {
    try {
      return await _apiService.getIntent(intentId);
    } catch (e) {
      debugPrint('Failed to get intent status: $e');
      return null;
    }
  }

  /// Clear transfer state
  void clearTransferState() {
    _transferIntent = null;
    _transferError = null;
    notifyListeners();
  }

  /// Clear swap state
  void clearSwapState() {
    _swapIntent = null;
    _swapError = null;
    notifyListeners();
  }

  /// Clear quotes state
  void clearQuotesState() {
    _quotes = [];
    _quotesError = null;
    notifyListeners();
  }
}
