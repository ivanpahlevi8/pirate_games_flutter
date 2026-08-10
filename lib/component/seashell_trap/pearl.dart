import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/main_game.dart';

enum PearlState { idle, destroyed }

class Pearl extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;

  Pearl({required this.inputPosition})
      : super(position: inputPosition, size: Vector2.all(56));

  // create state
  late SpriteAnimation pearlIdleAnimation;
  late SpriteAnimation pearlDestroyedAnimation;

  // variable for movement
  Vector2 velocity = Vector2(-100, 0);
  Vector2 accelerate = Vector2(-10, 0);

  @override
  FutureOr<void> onLoad() {
    // load pearl idle animation
    List<String> pearlIdleAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Pearl Idle/1.png",
    ];

    pearlIdleAnimation = _loadAnimation(pearlIdleAnimationImages);

    // load pearl destroyed animation
    List<String> pearlDestroyedAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Pearl Destroyed/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Pearl Destroyed/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Pearl Destroyed/3.png",
    ];

    pearlDestroyedAnimation = _loadAnimation(pearlDestroyedAnimationImages);

    // load animations
    animations = {
      PearlState.idle: pearlIdleAnimation,
      PearlState.destroyed: pearlDestroyedAnimation,
    };

    // set current animation as idle animation
    current = PearlState.idle;

    // add rectangle hitbox
    add(RectangleHitbox(position: Vector2.all(10.0), size: Vector2.all(24)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // update moement
    _handleHorizontalMovement(dt);

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with collision block
    if (other is CollisionBlock) {
      // make pearl movement to zero
      velocity = Vector2.zero();
      accelerate = Vector2.zero();

      // set current animation to destroyed
      current = PearlState.destroyed;

      // remove the pearl after animation played
      Future.delayed(Duration(milliseconds: 200), () {
        removeFromParent();
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  // handle function to move horizontally
  void _handleHorizontalMovement(double dt) {
    // update velocity
    velocity.x += accelerate.x * dt;

    // update position
    position.x += velocity.x * dt;
  }

  // function to load sprite animation
  SpriteAnimation _loadAnimation(List<String> imageList) {
    final spriteList = imageList.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
