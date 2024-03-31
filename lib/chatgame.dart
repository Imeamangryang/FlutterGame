import 'dart:async';

import 'package:chatgame/components/levels.dart';
import 'package:chatgame/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

class Chatgame extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFFE7DDB9);
  Player player = Player(character: 'Pikachu');
  late CameraComponent cam;
  late JoystickComponent joystick;
  bool showjoystick = true;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final Level world = Level(levelName: 'lobby');

    cam = CameraComponent.withFixedResolution(world: world, width: 480, height: 320);
    cam.viewfinder.anchor = Anchor.center;

    await addAll([cam, world]);

    world.addPlayer(player);
    cam.follow(player);

    if (showjoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showjoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
        player.playerDirection = Direction.left;
        break;
      case JoystickDirection.right:
        player.playerDirection = Direction.right;
        break;
      case JoystickDirection.up:
        player.playerDirection = Direction.up;
        break;
      case JoystickDirection.down:
        player.playerDirection = Direction.down;
        break;
      case JoystickDirection.upLeft:
        player.playerDirection = Direction.upleft;
        break;
      case JoystickDirection.upRight:
        player.playerDirection = Direction.upright;
        break;
      case JoystickDirection.downLeft:
        player.playerDirection = Direction.downleft;
        break;
      case JoystickDirection.downRight:
        player.playerDirection = Direction.downright;
        break;
      default:
        player.playerDirection = Direction.none;
        break;
    }
  }
}
