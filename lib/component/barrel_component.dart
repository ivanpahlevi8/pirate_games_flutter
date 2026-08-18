import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/main_player/main_player.dart';
import 'package:pirate_action/component/treasure/coin_treasure.dart';
import 'package:pirate_action/core/custom_hitbox.dart';
import 'package:pirate_action/main_game.dart';

// create enum for barrel state
enum BarrelState { idle, hit, destroyed }

class BarrelComponent extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  // size and position input
  final Vector2 inputPosition;
  final Vector2 inputSize;

  BarrelComponent({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  // create animation for each state
  late SpriteAnimation idleAnimation;
  late SpriteAnimation hitAnimation;
  late SpriteAnimation breakAnimation;

  // create number of hit
  int numberOfHit = 5;
  bool isStillOnHit = false;
  bool changeToIdleState = false;

  // create custom hitbox
  late CustomHitbox customHitbox;

  @override
  FutureOr<void> onLoad() {
    // create animation for idle animation
    List<String> listIdleAnimationImage = [
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Idle/1.png",
    ];
    idleAnimation = _createSpriteAnimation(listIdleAnimationImage);

    // create animation for destroyed animation
    List<String> listDestroyedAnimationImage = [
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Destroyed/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Destroyed/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Destroyed/3.png",
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Destroyed/4.png",
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Destroyed/5.png",
    ];
    breakAnimation = _createSpriteAnimation(listDestroyedAnimationImage);

    // create animation for hit animation
    List<String> listHitAnimationImage = [
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Hit/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Hit/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Barrel/Hit/3.png",
    ];
    hitAnimation = _createSpriteAnimation(listHitAnimationImage);

    // set animations
    animations = {
      BarrelState.idle: idleAnimation,
      BarrelState.hit: hitAnimation,
      BarrelState.destroyed: breakAnimation,
    };

    // set current animation
    current = BarrelState.idle;

    customHitbox = CustomHitbox(
      offsetX: 0,
      offsetY: 0,
      width: inputSize.x,
      height: inputSize.y,
    );

    // add hitbox
    add(
      RectangleHitbox(
        position: Vector2(customHitbox.offsetX, customHitbox.offsetY),
        size: Vector2(customHitbox.width, customHitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is MainPlayer) {
      if (!isStillOnHit && other.isAttack && numberOfHit > 0) {
        current = BarrelState.hit;

        if (!changeToIdleState) {
          changeToIdleState = true;

          Future.delayed(Duration(milliseconds: 250), () {
            current = BarrelState.idle;

            isStillOnHit = false;

            numberOfHit -= 1;

            changeToIdleState = false;

            if (numberOfHit == 0) {
              current = BarrelState.destroyed;

              Future.delayed(Duration(milliseconds: 300), () {
                removeFromParent();

                // emit gold from destroyed barrel,
                // set x position to emit, based on player position
                double xOffsetGoldEmit = 0.0;

                if (game.player.position.x <= position.x) {
                  // maje it appear on right
                  xOffsetGoldEmit = size.x;
                }
                if (game.player.position.x >= position.x) {
                  // make it appear on left
                  xOffsetGoldEmit = -48;
                }

                parent!.add(CoinTreasure(
                    inputPosition: Vector2(
                        inputPosition.x + 16.0 + xOffsetGoldEmit,
                        inputPosition.y + 32.0),
                    coinColor: "Gold"));
              });
            }
          });
        }
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  // function to create sprite aimation
  SpriteAnimation _createSpriteAnimation(List<String> listImages) {
    final imagesSprite = listImages.map((image) {
      // get iamge from cache
      final getImageFromCache = game.images.fromCache(image);

      // return sprite
      return Sprite(getImageFromCache);
    }).toList();

    // create sprite animation
    final animation = SpriteAnimation.spriteList(imagesSprite, stepTime: 0.05);

    return animation;
  }
}
