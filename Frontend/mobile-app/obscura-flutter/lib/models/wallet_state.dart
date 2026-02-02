import 'package:web3dart/web3dart.dart';
import 'package:solana/solana.dart';
import 'transfer_request.dart';

class WalletState {
  final bool connected;
  final String? address;
  final Ed25519HDPublicKey? solanaPublicKey;
  final EthereumAddress? evmAddress;
  final ChainType chain;
  final String? balance;
  final bool loading;
  final WalletType? walletType;

  const WalletState({
    this.connected = false,
    this.address,
    this.solanaPublicKey,
    this.evmAddress,
    this.chain = ChainType.solana,
    this.balance,
    this.loading = false,
    this.walletType,
  });

  WalletState copyWith({
    bool? connected,
    String? address,
    Ed25519HDPublicKey? solanaPublicKey,
    EthereumAddress? evmAddress,
    ChainType? chain,
    String? balance,
    bool? loading,
    WalletType? walletType,
  }) {
    return WalletState(
      connected: connected ?? this.connected,
      address: address ?? this.address,
      solanaPublicKey: solanaPublicKey ?? this.solanaPublicKey,
      evmAddress: evmAddress ?? this.evmAddress,
      chain: chain ?? this.chain,
      balance: balance ?? this.balance,
      loading: loading ?? this.loading,
      walletType: walletType ?? this.walletType,
    );
  }

  WalletState cleared() {
    return const WalletState();
  }
}

enum WalletType { solana, evm }

enum WalletConnectionError {
  noWalletFound,
  connectionRejected,
  networkError,
  unknownError,
}
