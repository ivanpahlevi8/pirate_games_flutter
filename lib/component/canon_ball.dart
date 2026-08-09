import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

// create enum for state of canon ball
enum CanonBallState { idle, explosion, destroyed }

class CanonBall extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  CanonBall({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  late SpriteAnimation canonBallIdleAnimation;
  late SpriteAnimation canonBallExplosionAnimation;
  late SpriteAnimation canonBallDestroyedAnimation;

  // canon ball trajectory, it moves to the left and applied with gravuty
  Vector2 velocity = Vector2(-500, 9.8);
  double gravitySum = 0.0;

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

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateCanonBallTrajectory(dt);
    _applyGravity(dt);

    super.update(dt);
  }

  // function to update canon ball trajectory
  void _updateCanonBallTrajectory(double dt) {
    // update canon ball on x direction
    position.x += velocity.x * dt;
  }

  // function to apply gravity to bullet
  void _applyGravity(dt) {
    gravitySum += velocity.y * dt;
    position.y += gravitySum;
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
