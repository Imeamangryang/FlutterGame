import 'dart:async';

import 'package:chatgame/components/player.dart';
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
    return super.onLoad();
  }

  // Player Add 함수
  void addPlayer(Player user) {
    Player player = user;
    final spawnpointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoint');

    for (final spawnpoint in spawnpointLayer!.objects) {
      if (spawnpoint.class_ == 'Spawn') {
        player.position = Vector2(spawnpoint.x, spawnpoint.y);
        add(player);
      }
    }
  }
}
