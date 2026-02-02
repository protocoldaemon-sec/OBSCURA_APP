# Obscura Vault - Flutter App

Post-Quantum Secure Privacy Protocol for Cross-Chain Asset Management

## Features

- **Post-Quantum Security**: WOTS+ signatures resistant to quantum computer attacks
- **Privacy-Preserving Transfers**: Stealth addresses and Pedersen commitments
- **Multi-Chain Support**: Solana, Ethereum, Polygon, Arbitrum
- **Private Swap**: Swap tokens anonymously
- **Magic Block Integration**: Confidential computing via Arcium MPC
- **Light Protocol**: ZK Compression for 1000x cheaper storage
- **Helius**: Enhanced Solana RPC and transaction monitoring

## Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Provider**: State management
- **Solana**: Solana Web3 integration
- **Web3Dart**: Ethereum integration
- **Helius**: Enhanced Solana RPC
- **Light Protocol**: ZK Compression
- **Magic Block/Arcium**: MPC for confidential computing

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   ├── transfer_request.dart
│   ├── swap_request.dart
│   ├── intent_response.dart
│   ├── health_response.dart
│   ├── wallet_state.dart
│   └── quote_request.dart
├── providers/             # State management
│   ├── wallet_provider.dart
│   └── api_provider.dart
├── screens/               # UI screens
│   ├── home_screen.dart
│   ├── transfer_screen.dart
│   └── swap_screen.dart
├── widgets/               # Reusable widgets
│   ├── wallet_button.dart
│   ├── wallet_modal.dart
│   ├── action_card.dart
│   ├── privacy_level_card.dart
│   └── chip_selector.dart
├── services/              # API and external services
│   ├── obscura_api.dart
│   ├── helius_service.dart
│   ├── light_protocol_service.dart
│   └── magic_block_service.dart
└── theme/                 # Design system
    ├── app_theme.dart
    ├── app_colors.dart
    ├── app_spacing.dart
    ├── app_text_styles.dart
    ├── app_gradients.dart
    └── app_shadows.dart
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository
```bash
cd obscura-vault/obscura_flutter
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure environment variables
Create `lib/config/env.dart`:
```dart
class Env {
  static const String obscuraApiUrl = 'https://obscurabackend-production.up.railway.app';
  static const String heliusApiKey = 'YOUR_HELIUS_API_KEY';
  static const String magicBlockApiKey = 'YOUR_MAGIC_BLOCK_API_KEY';
  static const String solanaRpcUrl = 'https://api.devnet.solana.com';
}
```

4. Run the app
```bash
flutter run
```

## Configuration

### Environment Variables

The app uses the following environment variables (configure in `lib/config/env.dart`):

- `obscuraApiUrl`: Obscura backend API URL
- `heliusApiKey`: Helius API key for enhanced Solana RPC
- `magicBlockApiKey`: Magic Block API key for confidential computing
- `solanaRpcUrl`: Solana RPC URL (devnet/mainnet)

### Wallet Integration

The app supports:
- **Solana**: Phantom, Solflare, Backpack (via Mobile Wallet Adapter)
- **EVM**: MetaMask, Rainbow, Trust Wallet (via WalletConnect)

## Architecture

### State Management

Uses Provider pattern for state management:
- `WalletProvider`: Manages wallet connection, transactions, balance
- `ApiProvider`: Manages API calls to Obscura backend

### API Services

- `ObscuraApiService`: Main backend API client
- `HeliusService`: Solana RPC and transaction monitoring
- `LightProtocolService`: ZK Compression for storage
- `MagicBlockService`: Confidential computing via MPC

### Design System

Custom design system with:
- Dark theme optimized for privacy apps
- Purple/violet gradient branding
- Custom spacing, typography, and component styles

## Privacy Features

### Privacy Levels

1. **Shielded**: Maximum privacy with stealth addresses
2. **Compliant**: Privacy with viewing key support
3. **Transparent**: Debug mode with visible transactions

### Security

- WOTS+ post-quantum signatures
- Stealth addresses for recipient privacy
- Pedersen commitments for amount hiding
- ZK Compression for efficient storage

## Building for Production

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Contributing

Contributions are welcome! Please follow the existing code style and run tests before submitting PRs.

## License

MIT License - see LICENSE file for details
