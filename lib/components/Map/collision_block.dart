import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent with CollisionCallbacks {
  CollisionBlock({position, size}) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(position: position, size: size, collisionType: CollisionType.passive));
    debugMode = false;
    return super.onLoad();
  }
}
