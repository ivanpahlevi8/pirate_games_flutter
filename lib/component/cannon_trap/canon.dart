import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/cannon_trap/canon_ball.dart';
import 'package:pirate_action/component/cannon_trap/canon_fire_component.dart';
import 'package:pirate_action/component/main_player/main_player.dart';
import 'package:pirate_action/core/custom_hitbox.dart';
import 'package:pirate_action/main_game.dart';

// create canon state
enum CanonState { idle, hit, fire, destroyed }

class Canon extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  // create state for hit
  bool isHit = false;

  Canon({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  // create each state for canon
  late SpriteAnimation canonIdleAnimation;
  late SpriteAnimation canonHitAnimation;
  late SpriteAnimation canonFireAnimation;
  late SpriteAnimation canonDestroyedAnimation;

  // time var
  double timePass = 0.0;
  bool isShooting = false;

  @override
  FutureOr<void> onLoad() {
    // load idle state
    List<String> idleAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Idle/1.png",
    ];

    canonIdleAnimation = _createAnimation(idleAnimationImages);

    // load hit animation
    List<String> hitAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Hit/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Hit/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Hit/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Hit/4.png",
    ];

    canonHitAnimation = _createAnimation(hitAnimationImages);

    // load fire animation
    List<String> fireAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire/5.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire/6.png",
    ];

    canonFireAnimation = _createAnimation(fireAnimationImages);

    // load destroyed animation
    List<String> destroyedAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Destroyed/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Destroyed/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Destroyed/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Destroyed/4.png",
    ];

    canonDestroyedAnimation = _createAnimation(destroyedAnimationImages);

    // create animations
    animations = {
      CanonState.idle: canonIdleAnimation,
      CanonState.hit: canonHitAnimation,
      CanonState.fire: canonFireAnimation,
      CanonState.destroyed: canonDestroyedAnimation,
    };

    // set current animation as idle animation
    current = CanonState.idle;

    // create hit box
    CustomHitbox customHitbox = CustomHitbox(
      offsetX: 0,
      offsetY: 0,
      width: width,
      height: height,
    );

    add(
      RectangleHitbox(
        position: Vector2(customHitbox.offsetX, customHitbox.offsetY),
        size: Vector2(customHitbox.width, customHitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // update to spawn canon ball, every 5 second
    timePass += dt;

    if (timePass >= 8.0 && !isShooting) {
      // update state into fire state
      current = CanonState.fire;

      // set is shooting to false, so that this scope called once
      isShooting = true;

      Future.delayed(Duration(milliseconds: 300), () {
        // set back current animation as idle
        current = CanonState.idle;

        // set time pass back
        timePass = 0.0;

        // set is shooting back to false
        isShooting = false;

        // spawn explosion
        CanonFireComponent canonFireComponent = CanonFireComponent(
          inputPosition: Vector2(inputPosition.x + 5, inputPosition.y + 16),
          inputSize: Vector2(32, 32),
        );

        parent!.add(canonFireComponent);

        // spawn canon ball
        CanonBall canonBall = CanonBall(
          inputPosition: Vector2(inputPosition.x, inputPosition.y + 16),
          inputSize: Vector2(32, 32),
        );

        parent!.add(canonBall);
      });
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is MainPlayer) {
      // check if player is on attack and not get hit
      if (other.isAttack && !isHit) {
        // play animation for being hit
        current = CanonState.hit;

        // set hit to true
        isHit = true;

        // add future function to update state
        Future.delayed((Duration(milliseconds: 200)), () {
          current = CanonState.idle;

          isHit = false;
        });
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  SpriteAnimation _createAnimation(List<String> imageList) {
    // create sprite
    final spriteList = imageList.map((image) {
      // get image
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}


/**
 * Note before forget :
 * 1. After this, the canon ball and the canon smoke class will be created derived from SpriteAnimationComponent.
 * 2. for ball, it will has initial x velocity, and will implement with gravity or not. and it will move once it being appeard by canon
 * 3. So for that, we will create a function in game level that can be called by the canon (still need to check what best practice for this)
 * Updated version:
 * it tursn out that we can called the parent from out current child which is level
 * so the bullet animation, will be addedd by calling these parent.
 */