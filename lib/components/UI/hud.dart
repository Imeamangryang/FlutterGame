import 'dart:async';
import 'dart:ui';

import 'package:chatgame/chatgame.dart';
import 'package:flame/components.dart';

class HUD extends PositionComponent with HasGameRef<Chatgame> {
  HUD() : super();

  late TextComponent onlinePlayerText;

  @override
  FutureOr<void> onLoad() {
    onlinePlayerText = TextComponent(
      text: 'Online Player : ${game.onlineplayerCount}',
      anchor: Anchor.center,
      position: Vector2(100, 20),
    );

    add(onlinePlayerText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    onlinePlayerText.text = 'Online Player : ${game.onlineplayerCount}';
    super.update(dt);
  }
}
