import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';
import 'package:web3dart/web3dart.dart';
import '../models/models.dart';
import '../services/helius_service.dart';

/// Wallet Provider for Obscura App
/// Supports both Solana (Mobile Wallet Adapter) and EVM (WalletConnect)
class WalletProvider with ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();

  WalletState _state = const WalletState();
  WalletState get state => _state;
  bool get connected => _state.connected;
  String? get address => _state.address;
  String? get balance => _state.balance;
  ChainType get chain => _state.chain;
  WalletType? get walletType => _state.walletType;

  // Stream controllers for event handling
  final _connectionController = StreamController<WalletState>.broadcast();
  Stream<WalletState> get connectionStream => _connectionController.stream;

  /// Initialize wallet provider and restore session if available
  Future<void> initialize() async {
    try {
      final savedChain = await _secureStorage.read(key: 'wallet_chain');
      final savedAddress = await _secureStorage.read(key: 'wallet_address');
      final savedWalletType = await _secureStorage.read(key: 'wallet_type');

      if (savedAddress != null && savedChain != null && savedWalletType != null) {
        final chain = ChainType.values.firstWhere(
          (c) => c.name == savedChain,
          orElse: () => ChainType.solana,
        );

        final type = WalletType.values.firstWhere(
          (t) => t.name == savedWalletType,
          orElse: () => WalletType.solana,
        );

        _state = WalletState(
          connected: true,
          address: savedAddress,
          chain: chain,
          walletType: type,
        );

        await refreshBalance();
        _connectionController.add(_state);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to restore wallet session: $e');
    }
  }

  /// Connect to Solana wallet
  Future<void> connectSolana() async {
    _state = _state.copyWith(loading: true);
    notifyListeners();

    try {
      // In a real implementation, this would integrate with:
      // - Phantom wallet via deep linking
      // - Solflare wallet
      // - Backpack wallet
      // - Mobile Wallet Adapter protocol

      // For demo purposes, generate a keypair
      final keypair = await Ed25519HDKeyPair.random();
      final address = keypair.address;

      // Get balance from Helius
      final balance = await HeliusService.instance.getBalance(address);

      _state = WalletState(
        connected: true,
        address: address,
        solanaPublicKey: keypair.publicKey,
        chain: ChainType.solana,
        balance: '${balance.toStringAsFixed(4)} SOL',
        loading: false,
        walletType: WalletType.solana,
      );

      await _saveSession();
      _connectionController.add(_state);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false);
      notifyListeners();
      rethrow;
    }
  }

  /// Connect to EVM wallet (Ethereum, Polygon, Arbitrum)
  Future<void> connectEVM(ChainType selectedChain) async {
    _state = _state.copyWith(loading: true);
    notifyListeners();

    try {
      // In a real implementation, this would integrate with:
      // - WalletConnect v2 protocol
      // - MetaMask via deep linking
      // - Rainbow wallet
      // - Trust Wallet

      // For demo purposes, simulate connection
      await Future.delayed(const Duration(seconds: 1));

      // Generate a mock address
      final random = DateTime.now().millisecondsSinceEpoch;
      final mockAddress =
          '0x${random.toRadixString(16).padLeft(40, '0').substring(0, 40)}';

      _state = WalletState(
        connected: true,
        address: mockAddress,
        evmAddress: EthereumAddress.fromHex(mockAddress),
        chain: selectedChain,
        balance: '0.15 ${selectedChain.symbol}',
        loading: false,
        walletType: WalletType.evm,
      );

      await _saveSession();
      _connectionController.add(_state);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false);
      notifyListeners();
      rethrow;
    }
  }

  /// Main connect function
  Future<void> connect(ChainType chain) async {
    if (chain == ChainType.solana) {
      await connectSolana();
    } else {
      await connectEVM(chain);
    }
  }

  /// Disconnect wallet
  Future<void> disconnect() async {
    await _clearSession();
    _state = const WalletState();
    _connectionController.add(_state);
    notifyListeners();
  }

  /// Switch chain
  Future<void> switchChain(ChainType newChain) async {
    if (!connected) return;

    final isSolana = newChain == ChainType.solana;
    final currentIsSolana = chain == ChainType.solana;

    if (isSolana != currentIsSolana) {
      // Switching between Solana and EVM requires reconnect
      await disconnect();
      await connect(newChain);
    } else if (!isSolana) {
      // Just update chain for EVM networks
      _state = _state.copyWith(chain: newChain);
      await _saveSession();
      notifyListeners();
    }
  }

  /// Sign message with wallet
  Future<String?> signMessage(String message) async {
    if (!connected) return null;

    try {
      if (walletType == WalletType.solana) {
        // Sign with Solana wallet
        // In real implementation, this would use Mobile Wallet Adapter
        final messageBytes = utf8.encode(message);
        final signature = base64Encode(messageBytes);
        return signature;
      } else {
        // Sign with EVM wallet
        // In real implementation, this would use WalletConnect
        return '0x${List.generate(130, (_) => '0').join()}';
      }
    } catch (e) {
      debugPrint('Sign message failed: $e');
      return null;
    }
  }

  /// Sign transaction with wallet
  Future<String?> signTransaction(Map<String, dynamic> transaction) async {
    if (!connected) return null;

    try {
      if (walletType == WalletType.solana) {
        // Sign Solana transaction
        // In real implementation, use Mobile Wallet Adapter
        return await _signSolanaTransaction(transaction);
      } else {
        // Sign EVM transaction
        // In real implementation, use WalletConnect
        return await _signEVMTransaction(transaction);
      }
    } catch (e) {
      debugPrint('Sign transaction failed: $e');
      return null;
    }
  }

  Future<String> _signSolanaTransaction(
      Map<String, dynamic> transaction) async {
    // In real implementation:
    // 1. Create Solana Transaction object
    // 2. Request signature from wallet
    // 3. Send signed transaction
    // 4. Return transaction signature

    // For demo, return mock signature
    final random = DateTime.now().millisecondsSinceEpoch;
    return base64Encode(
        List.generate(64, (_) => random % 256).map((e) => e as int).toList());
  }

  Future<String> _signEVMTransaction(Map<String, dynamic> transaction) async {
    // In real implementation:
    // 1. Create EVM transaction
    // 2. Request signature from wallet via WalletConnect
    // 3. Return transaction hash

    // For demo, return mock signature
    final random = DateTime.now().millisecondsSinceEpoch;
    return '0x${random.toRadixString(16).padLeft(64, '0')}';
  }

  /// Refresh balance from RPC
  Future<void> refreshBalance() async {
    if (!connected || address == null) return;

    try {
      String newBalance;

      if (walletType == WalletType.solana) {
        final balance = await HeliusService.instance.getBalance(address!);
        newBalance = '${balance.toStringAsFixed(4)} SOL';
      } else {
        // EVM balance - in real implementation, use web3dart
        newBalance = '0.15 ${chain.symbol}';
      }

      _state = _state.copyWith(balance: newBalance);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to refresh balance: $e');
    }
  }

  /// Save session to secure storage
  Future<void> _saveSession() async {
    await _secureStorage.write(
      key: 'wallet_chain',
      value: chain.name,
    );
    await _secureStorage.write(
      key: 'wallet_address',
      value: address,
    );
    await _secureStorage.write(
      key: 'wallet_type',
      value: walletType?.name,
    );
  }

  /// Clear session from secure storage
  Future<void> _clearSession() async {
    await _secureStorage.delete(key: 'wallet_chain');
    await _secureStorage.delete(key: 'wallet_address');
    await _secureStorage.delete(key: 'wallet_type');
  }

  @override
  void dispose() {
    _connectionController.close();
    super.dispose();
  }

  // Helper functions
  String formatAddress(String? addr) {
    if (addr == null || addr.length < 12) return addr ?? '';
    return '${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}';
  }

  String get formatWalletAddress => formatAddress(address);
}
