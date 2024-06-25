import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suffix/models/game_service/offline_game_service_impl.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// void main() {
//   runApp(const Suffix());
// }
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await OfflineGameServiceImpl().initGame();
  // SuffixAudioService().initAudio();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ChangeNotifierProvider(
          create: (context) => GameplayViewModel(),
          child: const Suffix()), // Wrap your app
    ),
  );
}

class Suffix extends StatefulWidget {
  const Suffix({super.key});

  @override
  State<Suffix> createState() => _SuffixState();
}

class _SuffixState extends State<Suffix> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(AppLifecycleListener(
      onStateChange: (value) {
        context.read<GameplayViewModel>().recordGame();
        OfflineGameServiceImpl().saveGameState();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MaterialApp(
          theme: Theme.of(context)
              .copyWith(textTheme: GoogleFonts.spaceGroteskTextTheme()),
          // theme: ThemThemeData(textTheme: GoogleFonts.spaceGroteskTextTheme()),
          home: const HomeScreen()),
    );
  }
}
