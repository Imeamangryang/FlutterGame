import 'dart:async';

import 'package:chatgame/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

class Charmander extends Player {
  @override
  FutureOr<void> onLoad() async {
    await loadAllAnimations();

    anchor = Anchor.center;
    nickname = TextComponent(
        text: '파이리',
        textRenderer:
            TextPaint(style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 10, 10, 1))),
        anchor: Anchor.bottomCenter,
        position: Vector2(anchor.x + size.x / 2, anchor.y));

    add(nickname);
  }

  @override
  FutureOr<void> loadAllAnimations() async {
    final idlespriteSheet = SpriteSheet(
        image: await gameRef.images.load('Characters/Charmander/Idle-Anim.png'),
        srcSize: Vector2(32.0, 40.0));

    idleAnimation = idlespriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);

    // running state Animation Sheet
    final runningspriteSheet = SpriteSheet(
        image: await gameRef.images.load('Characters/Charmander/Walk-Anim.png'),
        srcSize: Vector2(32.0, 32.0));

    runUpAnimation = runningspriteSheet.createAnimation(row: 4, stepTime: animationSpeed, to: 4);
    runDownAnimation = runningspriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);
    runRightAnimation = runningspriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 4);
    runLeftAnimation = runningspriteSheet.createAnimation(row: 6, stepTime: animationSpeed, to: 4);
    runUpleftAnimation =
        runningspriteSheet.createAnimation(row: 5, stepTime: animationSpeed, to: 4);
    runUprightAnimation =
        runningspriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 4);
    runDownleftAnimation =
        runningspriteSheet.createAnimation(row: 7, stepTime: animationSpeed, to: 4);
    runDownrightAnimation =
        runningspriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 4);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.up: runUpAnimation,
      PlayerState.down: runDownAnimation,
      PlayerState.right: runRightAnimation,
      PlayerState.left: runLeftAnimation,
      PlayerState.upleft: runUpleftAnimation,
      PlayerState.upright: runUprightAnimation,
      PlayerState.downleft: runDownleftAnimation,
      PlayerState.downright: runDownrightAnimation
    };
  }
}
