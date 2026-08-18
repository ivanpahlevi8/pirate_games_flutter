import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/head_trap/wood_spike.dart';
import 'package:pirate_action/component/main_player/main_player.dart';
import 'package:pirate_action/main_game.dart';

// create enum animation
enum TottemHeadState { attack, destroyed, hit, idle }

class TottemHead extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final int headOption;
  final int shapeOption;

  TottemHead(
      {required this.inputPosition,
      required this.headOption,
      required this.shapeOption})
      : super(position: inputPosition, size: Vector2.all(56));

  // create animation for first head
  late SpriteAnimation attackAnimation;
  late SpriteAnimation destroyedAnimation;
  late SpriteAnimation hitAnimation;
  late SpriteAnimation idleAnimation;

  // variable to handle user attack
  bool isAttack = false;
  int numberHit = 5;

  // variable to handle firing
  bool isFiring = false;
  double timeInterval = 0.0;

  @override
  FutureOr<void> onLoad() {
    // load first attack animation
    List<String> attackAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Attack $shapeOption/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Attack $shapeOption/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Attack $shapeOption/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Attack $shapeOption/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Attack $shapeOption/5.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Attack $shapeOption/6.png",
    ];

    attackAnimation = _loadAnimation(attackAnimationImages);

    // load destroyed animation
    List<String> destroyedAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Destroyed/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Destroyed/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Destroyed/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Destroyed/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Destroyed/5.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Destroyed/6.png",
    ];

    destroyedAnimation = _loadAnimation(destroyedAnimationImages);

    // load hit animation
    List<String> hitAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Hit $shapeOption/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Hit $shapeOption/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Hit $shapeOption/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Hit $shapeOption/4.png",
    ];

    hitAnimation = _loadAnimation(hitAnimationImages);

    // load idle animation
    List<String> idleAnimationImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Totems/Head $headOption/Idle $shapeOption/1.png",
    ];

    idleAnimation = _loadAnimation(idleAnimationImages);

    // create animation
    animations = {
      TottemHeadState.attack: attackAnimation,
      TottemHeadState.destroyed: destroyedAnimation,
      TottemHeadState.hit: hitAnimation,
      TottemHeadState.idle: idleAnimation,
    };

    // set current animation
    current = TottemHeadState.idle;

    // add rectangle hitbox
    add(RectangleHitbox(position: Vector2.all(0.0), size: Vector2.all(56)));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check attack by user
    if (other is MainPlayer && other.isAttack && !isAttack) {
      // set is attack to true
      isAttack = true;

      // update current state int hit
      current = TottemHeadState.hit;

      // run function to update state into idle again
      Future.delayed(Duration(milliseconds: 250), () {
        // update state into idle
        current = TottemHeadState.idle;

        // update attack condition
        isAttack = false;

        // update number hit
        numberHit -= 1;

        if (numberHit <= 0) {
          // update state into destroyed
          current = TottemHeadState.destroyed;

          // run function to remove tottem from parent
          removeFromParent();
        }
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    // handle attack
    timeInterval += dt;

    if (timeInterval >= 4 && !isFiring) {
      // set is firing to true
      isFiring = true;

      // update state into attack state
      current = TottemHeadState.attack;

      // spawn wood spike
      parent!.add(WoodSpike(
          inputPosition: Vector2(inputPosition.x, inputPosition.y + 56 / 2)));

      // run function to set back animation to idle
      Future.delayed(Duration(milliseconds: 350), () {
        current = TottemHeadState.idle;

        // update parameter
        isFiring = false;
        timeInterval = 0;
      });
    }

    super.update(dt);
  }

  // function to load animation
  SpriteAnimation _loadAnimation(List<String> imageList) {
    final spriteList = imageList.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
