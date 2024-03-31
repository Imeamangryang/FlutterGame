import 'package:chatgame/chatgame.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  Chatgame game = Chatgame();
  runApp(
    GameWidget(game: kDebugMode ? Chatgame() : game),
  );
}
