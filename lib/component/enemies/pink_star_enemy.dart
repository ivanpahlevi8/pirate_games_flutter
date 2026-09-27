import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/enemies/crabby_enemy.dart';
import 'package:pirate_action/component/enemies/enemy_interface.dart';
import 'package:pirate_action/component/enemies/player_detection_hitbox.dart';
import 'package:pirate_action/component/main_player/main_player.dart';
import 'package:pirate_action/main_game.dart';

enum PinkStarState { idle, run, hit, attack, deadHit, deadGround }

class PinkStarEnemy extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks
    implements EnemyInterface {
  final Vector2 inputPosition;
  final Vector2 inputSize;
  final double maxRight;
  final double maxLeft;

  PinkStarEnemy(
      {required this.inputPosition,
      required this.inputSize,
      required this.maxRight,
      required this.maxLeft})
      : super(position: inputPosition, size: inputSize);

  // variable for patrol
  ConditionState currentCondition = ConditionState.idle;
  int moveDirection = 1; // 1 means direction move to right, -1 to left
  double targetPatrol = 0.0;
  bool initialLoad = true;

  // variable for player movement
  Vector2 acceleration = Vector2(15.0, 9.8);
  Vector2 speed = Vector2(0.0, 0.0);
  final maxSpeed = 20.0;

  // variable for chasing player
  bool isChasePlayer = false;
  Vector2 mainPlayerPosition = Vector2.zero();
  bool gotPlayer = false;

  // variable to attack mode
  bool isOnAttack = false;
  double cooldownBeforeAttackCounter = 0.0;
  final cooldownBeforeAttackTime = 1.0;

  @override
  FutureOr<void> onLoad() {
    // get image for idle
    final idleImageList = [
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 04.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 05.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 06.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 07.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/01-Idle/Idle 08.png",
    ];

    SpriteAnimation idleAnimation = _loadAnimation(idleImageList);

    // get iamge run
    final runImageList = [
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/02-Run/Run 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/02-Run/Run 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/02-Run/Run 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/02-Run/Run 04.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/02-Run/Run 05.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/02-Run/Run 06.png",
    ];

    SpriteAnimation runAnimation = _loadAnimation(runImageList);

    // get attack animation
    final attackImageList = [
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/07-Attack/Attack 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/07-Attack/Attack 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/07-Attack/Attack 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Pink Star/07-Attack/Attack 04.png",
    ];

    SpriteAnimation attackAnimation = _loadAnimation(attackImageList);

    // create animation
    animations = {
      PinkStarState.idle: idleAnimation,
      PinkStarState.run: runAnimation,
      PinkStarState.attack: attackAnimation,
    };

    // select current animation
    current = PinkStarState.idle;

    anchor = Anchor.center;

    debugMode = true;

    // add hitbox
    add(RectangleHitbox(position: Vector2.all(0.0), size: inputSize));

    // add player detection hitbox
    add(PlayerDetectionHitbox(
        inputPosition: Vector2(inputSize.x / 2, inputSize.y / 2),
        enemy: this,
        inputSize: Vector2(500, 40)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // movement update
    _updateMovement(dt);

    // apply gravity
    _applyGravity(dt);

    // state update
    _updateState();

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with collision block
    if (other is CollisionBlock) {
      // set y velocity to zero
      speed.y = 0.0;

      // update player position
      position.y = other.position.y - (inputSize.y / 2) + 10.0;
    }

    if (other is MainPlayer) {
      // check if already got player or noty
      if (!gotPlayer) {
        // enemy got on player, set got player to true
        gotPlayer = true;

        // set current condition to idle
        currentCondition = ConditionState.idle;

        // set velocity to zero
        speed.x = 0.0;
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // check end collision with player
    if (other is MainPlayer) {
      // reset again
      gotPlayer = false;

      // set to zero for counter
      cooldownBeforeAttackCounter = 0.0;
    }

    super.onCollisionEnd(other);
  }

  @override
  void chasePlayer(Vector2 playerPosition) {
    // check if player get caught, chase only when player not caught
    if (!gotPlayer) {
      // set condition to chase
      currentCondition = ConditionState.chase;
      isChasePlayer = true;

      // update main player position
      mainPlayerPosition = playerPosition;
    }
  }

  @override
  void finishChasePlayer() {
    // set current condition to idle
    currentCondition = ConditionState.idle;
    isChasePlayer = false;

    // set state to idle
    current = PinkStarState.idle;

    // set velocity to zero
    speed.x = 0.0;
  }

  // function to update movement
  void _updateMovement(double dt) {
    // check based on state
    switch (currentCondition) {
      case ConditionState.idle:
        // idle condition, set current state into idle
        if (current != PinkStarState.idle) {
          current = PinkStarState.idle;
        }

        // check for initial load
        if (initialLoad) {
          // set initial target on the right
          targetPatrol = maxRight;

          // set initial load to false
          initialLoad = false;

          // run future function to update condition state to patrol
          if (currentCondition != ConditionState.patrol) {
            Future.delayed(Duration(milliseconds: 2000), () {
              currentCondition = ConditionState.patrol;
            });
          }
        } else {
          // check if main playe caught before idle
          if (gotPlayer) {
            cooldownBeforeAttackCounter += dt;

            if (cooldownBeforeAttackCounter >= cooldownBeforeAttackTime) {
              // set cooldown to zero again
              cooldownBeforeAttackCounter = 0.0;

              // set current condition to attack
              currentCondition = ConditionState.attack;
            }

            return;
          }

          // check if player already reached target position or not
          if ((position.x + (inputSize.x / 2)) >= maxRight ||
              (position.x - (inputSize.x / 2)) <= (targetPatrol + 20.0)) {
            // player already reached the target, set next target based on player
            // position
            if (position.x >= inputPosition.x) {
              // next target are on the left
              targetPatrol = maxLeft;
            } else {
              // next target are on the right
              targetPatrol = maxRight;
            }
          } else {
            // player not yet reached the target, probably because interupt by
            // player, set target as initial target
            targetPatrol = targetPatrol;
          }

          // run future function to update condition state back to patrol
          if (currentCondition != ConditionState.patrol) {
            Future.delayed(Duration(milliseconds: 2000), () {
              currentCondition = ConditionState.patrol;
            });
          }
        }

        break;
      case ConditionState.patrol:
        // patrol condition
        // check if player reached target patrol or not
        if (targetPatrol > inputPosition.x) {
          // target player on the right
          if ((position.x + (inputSize.x / 2)) >= targetPatrol) {
            // player reached the target, set to idle
            currentCondition = ConditionState.idle;

            // set velocity to default
            speed = Vector2.zero();

            return;
          }
        } else {
          if ((position.x - (inputSize.x / 2)) <= (targetPatrol + 20.0)) {
            currentCondition = ConditionState.idle;

            // set velocity to default
            speed = Vector2.zero();

            return;
          }
        }

        // check on target patrol
        if (targetPatrol > position.x) {
          // set acceleration to positive
          acceleration.x = 15.0;

          // update speed
          speed.x += acceleration.x * dt;

          // set max speed
          if (speed.x >= 20.0) {
            speed.x = 20.0;
          }

          // update position
          position.x += speed.x * dt;
        } else {
          // set acceleration to positive
          acceleration.x = -15.0;

          // update speed
          speed.x += acceleration.x * dt;

          // set max speed
          if (speed.x <= -20.0) {
            speed.x = -20.0;
          }

          // update position
          position.x += speed.x * dt;
        }
        break;
      case ConditionState.chase:
        if (isOnAttack || gotPlayer) {
          return;
        }
        const double chaseAccel = 15.0;
        const double maxChaseSpeed = 20.0;

        // chase condition, check main player position
        if (position.x < mainPlayerPosition.x) {
          speed.x = (speed.x + chaseAccel * dt).clamp(0.0, maxChaseSpeed);
        } else {
          speed.x = (speed.x - chaseAccel * dt).clamp(-maxChaseSpeed, 0.0);
        }

        // update position
        position.x += speed.x * dt;

        break;
      case ConditionState.attack:
        if (!isOnAttack) {
          // update current state into attack
          current = PinkStarState.attack;

          // set on attack to true
          isOnAttack = true;

          // called future function to update state
          Future.delayed((Duration(milliseconds: 300)), () {
            // set current state to idle before attack
            currentCondition = ConditionState.idle;

            // // set on attack to false
            isOnAttack = false;
          });
        }
        break;
    }
  }

  // function to update state
  void _updateState() {
    // check if on attack
    if (isOnAttack) {
      return;
    }

    // check horizontal movement
    if (speed.x != 0) {
      // player movement, update state into run
      current = PinkStarState.run;

      // check based on player speed
      if (speed.x > 0) {
        // set scale to zero
        scale.x = -1.0;
      } else {
        scale.x = 1.0;
      }
    }
  }

  // function to apply gravity
  void _applyGravity(double dt) {
    // update vertical speed
    speed.y += acceleration.y * dt;

    // update vertical position
    position.y += speed.y * dt;
  }

  SpriteAnimation _loadAnimation(List<String> imageList) {
    // cast image into sprite
    List<Sprite> spriteList = imageList.map((data) {
      // get iamge
      final getImage = game.images.fromCache(data);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
