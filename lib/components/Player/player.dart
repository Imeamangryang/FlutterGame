import 'dart:async';

import 'package:chatgame/chatgame.dart';
import 'package:chatgame/components/textbox.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum PlayerState { idle, up, down, right, left, upleft, upright, downleft, downright }

enum Direction { none, up, down, right, left, upleft, upright, downleft, downright }

class Player extends SpriteAnimationGroupComponent with HasGameRef<Chatgame>, KeyboardHandler {
  String playername;
  Player({required this.playername});
  double animationSpeed = 0.15;
  double moveSpeed = 100;

  late final SpriteAnimation idleAnimation;
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

  @override
  FutureOr<void> onLoad() async {
    await loadAllAnimations();
    debugMode = true;
    anchor = Anchor.center;

    nickname = TextComponent(
        text: playername,
        textRenderer:
            TextPaint(style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 10, 10, 1))),
        anchor: Anchor.bottomCenter,
        position: Vector2(anchor.x + size.x / 2, anchor.y));

    add(nickname);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    movePlayer(dt);
    nickname.position = Vector2(anchor.x + size.x / 2, anchor.y);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLEFTKeypressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRIGHTKeypressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUPKeypressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDOWNKeypressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);

    if (isLEFTKeypressed) {
      playerDirection = Direction.left;
    } else if (isRIGHTKeypressed) {
      playerDirection = Direction.right;
    } else if (isUPKeypressed) {
      playerDirection = Direction.up;
    } else if (isDOWNKeypressed) {
      playerDirection = Direction.down;
    } else {
      playerDirection = Direction.none;
    }
    return super.onKeyEvent(event, keysPressed);
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

    current = PlayerState.idle;
  }

  void movePlayer(double dt) {
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
  }

  void addMessage(TextBox message) async {
    add(message);
    game.overlays.remove(textfieldoverlay);
    await Future.delayed(const Duration(seconds: 5), () {
      remove(message);
    });
  }
}
