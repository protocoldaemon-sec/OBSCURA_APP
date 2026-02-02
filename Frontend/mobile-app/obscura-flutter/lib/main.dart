import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/swap_screen.dart';
import 'providers/wallet_provider.dart';
import 'providers/api_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ObscuraApp());
}

class ObscuraApp extends StatelessWidget {
  const ObscuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
      ],
      child: MaterialApp(
        title: 'Obscura Vault',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
        routes: {
          '/transfer': (context) => const TransferScreen(),
          '/swap': (context) => const SwapScreen(),
        },
      ),
    );
  }
}
