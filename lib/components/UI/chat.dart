import 'dart:async';

import 'package:chatgame/chatgame.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class ChatButton extends SpriteComponent with HasGameRef<Chatgame>, TapCallbacks {
  ChatButton();

  final margin = 32;
  final buttonSize = 64;
  final String textfieldoverlay = 'TextField';

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/ChatButton.png'));
    position = Vector2(game.size.x - margin - buttonSize, game.size.y - margin - buttonSize);
    size = size / 4;
    priority = 2;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position = Vector2(game.size.x - margin - buttonSize, game.size.y - margin - buttonSize);
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) {
    sprite = Sprite(game.images.fromCache('HUD/ChatButton.png'));
    super.onTapUp(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    //print('test');
    //game.player.addMessage(TextBox('테스트 채팅'));
    sprite = Sprite(game.images.fromCache('HUD/ChatButton_down.png'));
    game.overlays.add(textfieldoverlay);
    super.onTapDown(event);
  }
}
