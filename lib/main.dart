import 'package:chessnomer/game/screenGame.dart';
import 'package:chessnomer/providers/provider_game.dart';
import 'package:chessnomer/providers/provider_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ProviderPrefs>(
            create: (context) => ProviderPrefs(),
          ),
          ChangeNotifierProvider<ProviderGame>(
            create: (context) => ProviderGame(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChessFormer',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ScreenGame(),
        ));
  }
}
