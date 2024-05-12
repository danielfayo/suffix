import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suffix/views/home/home_screen.dart';

// void main() {
//   runApp(const Suffix());
// }
import 'package:device_preview/device_preview.dart';

void main() => runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => const Suffix(), // Wrap your app
      ),
    );

class Suffix extends StatelessWidget {
  const Suffix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MaterialApp(
          theme: ThemeData(textTheme: GoogleFonts.spaceGroteskTextTheme()),
          home: const HomeScreen()),
    );
  }
}
