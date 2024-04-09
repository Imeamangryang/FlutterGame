import 'package:chatgame/pages/homepage.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(MaterialApp(
    title: 'Flame Pokemon',
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.bungeeInlineTextTheme(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
    home: const MainMenu(),
  ));
}
