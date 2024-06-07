import 'dart:async';

import 'package:chatgame/components/Map/collision_block.dart';
import 'package:chatgame/components/Player/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;
  Level({required this.levelName});
  late TiledComponent level;

  // Constructor
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(32)); // level의 맵 정보 Load
    add(level); // World에 추가

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collision');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Wall':
            final wall = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height));
            add(wall);
            break;
        }
      }
    }

    return super.onLoad();
  }

  // Player Add 함수
  void addPlayer(Player user) {
    //Player player = user;
    final spawnpointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoint');

    for (final spawnpoint in spawnpointLayer!.objects) {
      if (spawnpoint.class_ == 'Spawn') {
        user.position = Vector2(spawnpoint.x, spawnpoint.y);
        add(user);
      }
    }
  }
}
