/// Environment configuration for Obscura Vault
///
/// Configure your API keys and endpoints here
class Env {
  // Obscura Backend API
  static const String obscuraApiUrl =
      'https://obscurabackend-production.up.railway.app';

  // Helius (Solana RPC)
  static const String heliusApiKey = 'YOUR_HELIUS_API_KEY';
  static const String solanaRpcUrl = 'https://api.devnet.solana.com';

  // Magic Block / Arcium (Confidential Computing)
  static const String magicBlockApiKey = 'YOUR_MAGIC_BLOCK_API_KEY';
  static const String magicBlockUrl = 'https://api.magicblock.xyz';

  // Light Protocol (ZK Compression)
  static const String lightProtocolRpc =
      'https://rpc.helius.xyz'; // Use Helius for Light Protocol

  // WalletConnect (for EVM wallets)
  static const String walletConnectProjectId = 'YOUR_WALLETCONNECT_PROJECT_ID';

  // App Configuration
  static const String appName = 'Obscura Vault';
  static const String appUrl = 'https://obscura.app';
  static const int commitmentTimeout = 60; // seconds
}
