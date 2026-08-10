import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/main_game.dart';

// create enum for state of canon ball
enum CanonBallState { idle, explosion, destroyed }

class CanonBall extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  CanonBall({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  late SpriteAnimation canonBallIdleAnimation;
  late SpriteAnimation canonBallExplosionAnimation;
  late SpriteAnimation canonBallDestroyedAnimation;

  // canon ball trajectory, it moves to the left and applied with gravuty
  Vector2 velocity = Vector2(-6, 0);
  Vector2 accelaration = Vector2(-5, 9.8);

  // collide parameters
  bool isBallCollide = false;

  @override
  FutureOr<void> onLoad() {
    // load ball idle animation
    List<String> cannonBallIdleImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Idle/1.png",
    ];

    canonBallIdleAnimation = _createSpriteAnimation(cannonBallIdleImages);

    // load ball explosion animation
    List<String> cannonBallExplosionImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Explosion/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Explosion/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Explosion/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Explosion/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Explosion/5.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Explosion/6.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Explosion/7.png",
    ];

    canonBallExplosionAnimation = _createSpriteAnimation(
      cannonBallExplosionImages,
    );

    // load ball destroyed animation
    List<String> cannonBallDestroyedImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Destroyed/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Destroyed/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Ball Destroyed/3.png",
    ];

    canonBallDestroyedAnimation = _createSpriteAnimation(
      cannonBallDestroyedImages,
    );

    // load all animation
    animations = {
      CanonBallState.idle: canonBallIdleAnimation,
      CanonBallState.explosion: canonBallExplosionAnimation,
      CanonBallState.destroyed: canonBallDestroyedAnimation,
    };

    // set current animation
    current = CanonBallState.idle;

    // add hitbox
    add(RectangleHitbox(position: Vector2(0, 0), size: inputSize));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isBallCollide) {
      _updateCanonBallTrajectory(dt);
      _applyGravity(dt);
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with collision block
    if (other is CollisionBlock && !isBallCollide) {
      // update velocity to ze
      // set ball to freeze
      isBallCollide = true;

      // update state to explosion
      current = CanonBallState.explosion;

      Future.delayed(Duration(milliseconds: 400), () {
        // update state into destroyed
        current = CanonBallState.destroyed;

        // remove ball from parent
        Future.delayed(Duration(milliseconds: 200), () {
          removeFromParent();
        });
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  // function to update canon ball trajectory
  void _updateCanonBallTrajectory(double dt) {
    // add x speed based on accleration
    velocity.x += accelaration.x * dt;

    // update canon ball on x direction
    position.x += velocity.x;
  }

  // function to apply gravity to bullet
  void _applyGravity(dt) {
    // add y speed based on acclearation
    velocity.y += accelaration.y * dt;

    // update position
    position.y += velocity.y;
  }

  SpriteAnimation _createSpriteAnimation(List<String> imagesList) {
    // create sprite list
    final spriteList = imagesList.map((image) {
      // get image
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
