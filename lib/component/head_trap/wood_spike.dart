import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/main_game.dart';

enum WoodSpikeState { idle, destroyed }

class WoodSpike extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;

  WoodSpike({required this.inputPosition})
      : super(position: inputPosition, size: Vector2(32, 32));

  // create two state of wood spike
  late SpriteAnimation woodIdleAnimation;
  late SpriteAnimation woodDestroyedAnimation;

  // variable for horizontal movement
  Vector2 accelerate = Vector2(-15, 0);
  Vector2 velocity = Vector2(-50, 0);

  @override
  FutureOr<void> onLoad() {
    // load idle animation
    List<String> woodIdleAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Wood Spike/Idle/1.png",
    ];

    woodIdleAnimation = _loadAnimation(woodIdleAnimationImages);

    // load destroyed animation
    List<String> woodDestroyedAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Wood Spike/Destroyed/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Wood Spike/Destroyed/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Wood Spike/Destroyed/3.png",
    ];

    woodDestroyedAnimation = _loadAnimation(woodDestroyedAnimationImages);

    // create animations
    animations = {
      WoodSpikeState.idle: woodIdleAnimation,
      WoodSpikeState.destroyed: woodDestroyedAnimation,
    };

    // set current animation
    current = WoodSpikeState.idle;

    // add collision box
    add(RectangleHitbox(position: Vector2(8, 8), size: Vector2(12, 12)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // update horizontal movement
    velocity.x +=
        accelerate.x * dt; // kecepatan adalah integral dari percepatan (a . dt)

    // create movement
    double movementX =
        velocity.x * dt; // perpindahan adalah integral dari kecepatan

    // update new position
    position.x += movementX;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // handle collide with collision block
    if (other is CollisionBlock) {
      // update velocity and acclerate to 0
      velocity = Vector2.zero();
      accelerate = Vector2.zero();

      // change current state to destroyed
      current = WoodSpikeState.destroyed;

      // call function to remove from parent
      Future.delayed(Duration(milliseconds: 200), () {
        removeFromParent();
      });
    }
    super.onCollision(intersectionPoints, other);
  }

  SpriteAnimation _loadAnimation(List<String> animationImages) {
    final spriteList = animationImages.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
