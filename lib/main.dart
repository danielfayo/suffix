import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suffix/views/home_screen.dart';

void main() {
  runApp(const Suffix());
}

class Suffix extends StatelessWidget {
  const Suffix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: MaterialApp(
        theme: ThemeData(textTheme: GoogleFonts.spaceGroteskTextTheme()),
        home: const HomeScreen()),
    );
  }
}


