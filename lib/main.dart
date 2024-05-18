import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suffix/models/game_service/offline_game_service_impl.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/home_screen.dart';

// void main() {
//   runApp(const Suffix());
// }
import 'package:device_preview/device_preview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OfflineGameServiceImpl().initGame();
  // SuffixAudioService().initAudio();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const Suffix(), // Wrap your app
    ),
  );
}

class Suffix extends StatelessWidget {
  const Suffix({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameplayViewModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: MaterialApp(
            theme: Theme.of(context)
                .copyWith(textTheme: GoogleFonts.spaceGroteskTextTheme()),
            // theme: ThemThemeData(textTheme: GoogleFonts.spaceGroteskTextTheme()),
            home: const HomeScreen()),
      ),
    );
  }
}
