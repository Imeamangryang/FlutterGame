import 'dart:async';

import 'package:chatgame/chatgame.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class EatingButton extends SpriteComponent with HasGameRef<Chatgame>, TapCallbacks {
  EatingButton();

  final margin = 38;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/EatingButton.png'));
    position = Vector2(game.size.x - margin - buttonSize, game.size.y - margin - buttonSize - 80);
    size = size / 7;
    priority = 2;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position = Vector2(game.size.x - margin - buttonSize, game.size.y - margin - buttonSize - 80);
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.isEating = false;
    sprite = Sprite(game.images.fromCache('HUD/EatingButton.png'));
    super.onTapUp(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.isEating = true;
    sprite = Sprite(game.images.fromCache('HUD/EatingButton_down.png'));
    super.onTapDown(event);
  }
}
