import 'dart:async';

import 'package:chatgame/chatgame.dart';
import 'package:chatgame/components/textbox.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class ChatButton extends SpriteComponent with HasGameRef<Chatgame>, TapCallbacks {
  ChatButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/ChatButton.png'));
    position = Vector2(game.size.x - margin - buttonSize, game.size.y - margin - buttonSize);
    size = size / 4;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    print('test');
    game.player.addMessage(TextBox('테스트 채팅'));
    super.onTapDown(event);
  }
}
