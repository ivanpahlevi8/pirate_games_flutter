import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/main_player.dart';
import 'package:pirate_action/main_game.dart';

// diamond treasure state
enum DiamonTreasureState { idle, collected }

class DiamondTreasure extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final String diamonColor;

  DiamondTreasure({required this.inputPosition, required this.diamonColor})
      : super(position: inputPosition, size: Vector2(32, 32));

  // create state
  late SpriteAnimation idleAnimation;
  late SpriteAnimation collectedAnimation;

  // collision state
  bool isCollideWithPlayer = false;

  @override
  FutureOr<void> onLoad() {
    // load idle animation
    List<String> idleAnimationImages = [
      "Treasure Hunters/Pirate Treasure/Sprites/$diamonColor Diamond/01.png",
      "Treasure Hunters/Pirate Treasure/Sprites/$diamonColor Diamond/02.png",
      "Treasure Hunters/Pirate Treasure/Sprites/$diamonColor Diamond/03.png",
      "Treasure Hunters/Pirate Treasure/Sprites/$diamonColor Diamond/04.png",
    ];

    idleAnimation = _loadAnimation(idleAnimationImages);

    // load collected animation
    List<String> collectedAnimationImages = [
      "Treasure Hunters/Pirate Treasure/Sprites/Diamond Effect/01.png",
      "Treasure Hunters/Pirate Treasure/Sprites/Diamond Effect/02.png",
      "Treasure Hunters/Pirate Treasure/Sprites/Diamond Effect/03.png",
      "Treasure Hunters/Pirate Treasure/Sprites/Diamond Effect/04.png",
    ];

    collectedAnimation = _loadAnimation(collectedAnimationImages);

    // create animation
    animations = {
      DiamonTreasureState.idle: idleAnimation,
      DiamonTreasureState.collected: collectedAnimation,
    };

    // set current idle animation
    current = DiamonTreasureState.idle;

    // create hitbox for diamond
    add(RectangleHitbox(position: Vector2(8, 8), size: Vector2(8, 8)));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with player
    if (other is MainPlayer && !isCollideWithPlayer) {
      // update collide state
      isCollideWithPlayer = true;

      // update collected diamond
      game.updateCollectedDiamond(diamonColor);

      // update current state into collected
      current = DiamonTreasureState.collected;

      // called function to remove the diamond
      Future.delayed(Duration(milliseconds: 250), () {
        // remove diamond from parent
        removeFromParent();
      });
    }
    super.onCollision(intersectionPoints, other);
  }

  // function to load
  SpriteAnimation _loadAnimation(List<String> images) {
    final spriteList = images.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
