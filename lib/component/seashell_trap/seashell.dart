import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/main_player.dart';
import 'package:pirate_action/component/seashell_trap/pearl.dart';
import 'package:pirate_action/main_game.dart';

// create enum state for seashell
enum SeashellState { bite, destroyed, fire, hit, idle, opening }

class Seashell extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  Seashell({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  // create seashell state
  late SpriteAnimation seashellBiteAnimation;
  late SpriteAnimation seashellDestroyedAnimation;
  late SpriteAnimation seashellFireAnimation;
  late SpriteAnimation seashellHitAnimation;
  late SpriteAnimation seashellIdleAnimation;
  late SpriteAnimation seashellOpeningAnimation;

  // variable to watch player position
  late double playerPositionRange = 0.0;

  // create idle animation state
  bool isSeashellOpen = false;
  double seashellOpenDuration = 0.0;

  // vriable for shooting
  double seashellShootingInterval = 0.0;
  bool isSeashellShooting = false;

  // variable for being attack
  bool isBeingAttacked = false;
  int beingHitLife = 5;

  @override
  FutureOr<void> onLoad() {
    // update player position range based on most left edge
    playerPositionRange = 400.0;

    // load bite animation
    List<String> seashellBiteImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Bite/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Bite/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Bite/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Bite/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Bite/5.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Bite/6.png",
    ];

    seashellBiteAnimation = _loadSpriteAnimation(seashellBiteImages);

    // load destroyed animation
    List<String> seashellDestroyedImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Destroyed/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Destroyed/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Destroyed/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Destroyed/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Destroyed/5.png",
    ];

    seashellDestroyedAnimation = _loadSpriteAnimation(seashellDestroyedImages);

    // load fire animation
    List<String> seashellFireImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Fire/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Fire/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Fire/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Fire/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Fire/5.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Fire/6.png",
    ];

    seashellFireAnimation = _loadSpriteAnimation(seashellFireImages);

    // load hit animation
    List<String> seashellHitImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Hit/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Hit/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Hit/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Hit/4.png",
    ];

    seashellHitAnimation = _loadSpriteAnimation(seashellHitImages);

    // load seashell idle animation
    List<String> seashellIdleImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Idle/1.png",
    ];

    seashellIdleAnimation = _loadSpriteAnimation(seashellIdleImages);

    // load seashell opening animation
    List<String> seashellOpeningImages = [
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Opening/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Opening/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Opening/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Opening/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Seashell/Seashell Opening/5.png",
    ];

    seashellOpeningAnimation = _loadSpriteAnimation(seashellOpeningImages);

    // create animations
    animations = {
      SeashellState.bite: seashellBiteAnimation,
      SeashellState.destroyed: seashellDestroyedAnimation,
      SeashellState.fire: seashellFireAnimation,
      SeashellState.hit: seashellHitAnimation,
      SeashellState.idle: seashellIdleAnimation,
      SeashellState.opening: seashellOpeningAnimation,
    };

    // set current animation
    current = SeashellState.idle;

    // add collision rectangle hitbox
    add(RectangleHitbox(position: Vector2.all(0.0), size: inputSize));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    bool isPlayerAround = false;

    if ((position.x - game.player.x) < playerPositionRange) {
      isPlayerAround = true;
    }

    // handle idle condition
    if (!isBeingAttacked) {
      _handleIdleCondition(dt, isPlayerAround);

      // handle seashell shooting
      _handleSeashellShooting(dt, isPlayerAround);
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with player
    if (other is MainPlayer && other.isAttack) {
      if (!isBeingAttacked) {
        // set is being attacked to true
        isBeingAttacked = true;

        // update state into hit state
        current = SeashellState.hit;

        // update back the state to idle
        Future.delayed(Duration(milliseconds: 250), () {
          // set state back to idle
          current = SeashellState.idle;

          // set is attack parameter
          isBeingAttacked = false;

          // update being hit
          beingHitLife -= 1;

          if (beingHitLife <= 0) {
            // update state into destroyed state
            current = SeashellState.destroyed;

            Future.delayed(Duration(milliseconds: 200), () {
              // remove from parent after destroyed
              removeFromParent();
            });
          }
        });
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  // function to handle idle condition
  void _handleIdleCondition(double dt, bool isPlayerAround) {
    if (!isPlayerAround) {
      // update duration
      seashellOpenDuration += dt;

      // check if its not yet open
      if (!isSeashellOpen && seashellOpenDuration >= 5) {
        // update state into open state
        current = SeashellState.opening;

        // update seashell open state
        isSeashellOpen = true;

        // called function to close again
        Future.delayed(Duration(milliseconds: 350), () {
          // resetting the open parameter
          seashellOpenDuration = 0.0;
          isSeashellOpen = false;

          // update state again to idle
          current = SeashellState.idle;
        });
      }
    }
  }

  // function to handle seashell shooting
  void _handleSeashellShooting(double dt, bool isPlayerAround) {
    if (isPlayerAround) {
      // update shooting interval
      seashellShootingInterval += dt;

      // shoots every 5 second and at idle condition
      if (!isSeashellShooting && seashellShootingInterval >= 3.0) {
        // update state into shooting stateR
        current = SeashellState.fire;

        // emit pearl
        Pearl pearl = Pearl(
          inputPosition:
              Vector2(inputPosition.x, inputPosition.y + (inputSize.y / 2) - 7),
        );

        parent!.add(pearl);

        // set shooting state to true
        isSeashellShooting = true;

        Future.delayed(Duration(milliseconds: 350), () {
          // update state back to idle
          current = SeashellState.idle;

          // update shooting interval to 0
          seashellShootingInterval = 0.0;
          isSeashellShooting = false;
        });
      }
    }
  }

  SpriteAnimation _loadSpriteAnimation(List<String> imageList) {
    final spriteList = imageList.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
