import 'dart:async';

import 'package:chatgame/chatgame.dart';
import 'package:chatgame/components/Map/berries.dart';
import 'package:chatgame/components/Map/collision_block.dart';
import 'package:chatgame/components/UI/textbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

enum PlayerState { idle, up, down, right, left, upleft, upright, downleft, downright, eat }

enum Direction { none, up, down, right, left, upleft, upright, downleft, downright }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<Chatgame>, KeyboardHandler, CollisionCallbacks {
  String playername;
  Player({required this.playername});
  double animationSpeed = 0.15;
  double moveSpeed = 100;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation eatAnimation;
  late final SpriteAnimation runUpAnimation;
  late final SpriteAnimation runDownAnimation;
  late final SpriteAnimation runRightAnimation;
  late final SpriteAnimation runLeftAnimation;
  late final SpriteAnimation runUpleftAnimation;
  late final SpriteAnimation runUprightAnimation;
  late final SpriteAnimation runDownleftAnimation;
  late final SpriteAnimation runDownrightAnimation;
  late TextComponent nickname;
  late final String playerID;

  Direction playerDirection = Direction.none;

  final String textfieldoverlay = 'TextField';
  bool isEating = false;

  @override
  FutureOr<void> onLoad() async {
    await loadAllAnimations();

    anchor = Anchor.center;
    priority = 10;

    nickname = TextComponent(
        text: playername,
        textRenderer:
            TextPaint(style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 10, 10, 1))),
        anchor: Anchor.bottomCenter,
        position: Vector2(anchor.x + size.x / 2, anchor.y));

    add(nickname);

    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    movePlayer(dt);
    nickname.position = Vector2(anchor.x + size.x / 2, anchor.y);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
    if (other is Berry) {
      if (isEating) {
        await other.collidedPlayer();
      }
    } else if (other is CollisionBlock) {
      final overlap =
          intersectionPoints.reduce((a, b) => a + b) / intersectionPoints.length.toDouble();

      // Determine the direction of the overlap
      if (overlap.y > position.y) {
        // Collision from above
        position.y = other.position.y + other.size.y;
      } else if (overlap.y < position.y) {
        // Collision from below
        position.y = other.position.y - size.y;
      } else if (overlap.x > position.x) {
        // Collision from the left
        position.x = other.position.x + other.size.x;
      } else if (overlap.x < position.x) {
        // Collision from the right
        position.x = other.position.x - size.x;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  FutureOr<void> loadAllAnimations() async {
    // idle state Animation Sheet
    final idlespriteSheet = SpriteSheet(
        image: await gameRef.images.load('Characters/Pikachu/Idle-Anim.png'),
        srcSize: Vector2(40.0, 56.0));

    idleAnimation = idlespriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 6);

    // running state Animation Sheet
    final runningspriteSheet = SpriteSheet(
        image: await gameRef.images.load('Characters/Pikachu/Walk-Anim.png'),
        srcSize: Vector2(32.0, 40.0));

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

    final eatingspriteSheet = SpriteSheet(
        image: await gameRef.images.load('Characters/Bulbasaur/Eat-Anim.png'),
        srcSize: Vector2(24.0, 32.0));

    eatAnimation = eatingspriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.eat: eatAnimation,
      PlayerState.up: runUpAnimation,
      PlayerState.down: runDownAnimation,
      PlayerState.right: runRightAnimation,
      PlayerState.left: runLeftAnimation,
      PlayerState.upleft: runUpleftAnimation,
      PlayerState.upright: runUprightAnimation,
      PlayerState.downleft: runDownleftAnimation,
      PlayerState.downright: runDownrightAnimation
    };

    current = PlayerState.idle;
  }

  void movePlayer(double dt) {
    if (!isEating) {
      switch (playerDirection) {
        case Direction.up:
          current = PlayerState.up;
          position.add(Vector2(0, -dt * moveSpeed));
          break;
        case Direction.down:
          current = PlayerState.down;
          position.add(Vector2(0, dt * moveSpeed));
          break;
        case Direction.left:
          current = PlayerState.left;
          position.add(Vector2(-dt * moveSpeed, 0));
          break;
        case Direction.right:
          current = PlayerState.right;
          position.add(Vector2(dt * moveSpeed, 0));
          break;
        case Direction.upleft:
          current = PlayerState.upleft;
          position.add(Vector2(-dt * moveSpeed, -dt * moveSpeed));
          break;
        case Direction.upright:
          current = PlayerState.upright;
          position.add(Vector2(dt * moveSpeed, -dt * moveSpeed));
          break;
        case Direction.downleft:
          current = PlayerState.downleft;
          position.add(Vector2(-dt * moveSpeed, dt * moveSpeed));
          break;
        case Direction.downright:
          current = PlayerState.downright;
          position.add(Vector2(dt * moveSpeed, dt * moveSpeed));
          break;
        case Direction.none:
          current = PlayerState.idle;
          break;
      }
    } else {
      current = PlayerState.eat;
    }
  }

  void addMessage(TextBox message) async {
    add(message);
    game.overlays.remove(textfieldoverlay);
    await Future.delayed(const Duration(seconds: 5), () {
      remove(message);
    });
  }
}
