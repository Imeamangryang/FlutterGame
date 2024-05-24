import 'dart:async';

import 'package:chatgame/chatgame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Berry extends SpriteComponent with HasGameRef<Chatgame>, CollisionCallbacks {
  final String berry;
  Berry({this.berry = 'cheri-berry', position}) : super(position: position);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Berries/$berry.png'));
    position = position;
    size = size / 3;
    priority = 1;
    add(RectangleHitbox(
        position: Vector2(2, 2), size: Vector2(12, 12), collisionType: CollisionType.passive));
    debugMode = true;
    return super.onLoad();
  }

  FutureOr<void> collidedPlayer() async {
    removeFromParent();
  }
}
