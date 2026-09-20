import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:pirate_action/component/enemies/enemy_body_hitbox.dart';
import 'package:pirate_action/component/enemies/object_detection_hitbox.dart';
import 'package:pirate_action/component/enemies/player_detection_hitbox.dart';
import 'package:pirate_action/component/main_player/main_player.dart';
import 'package:pirate_action/main_game.dart';

enum CrabbyState { idle, run, jump, fall, attack, hit, dead, deadGround }

// create movement state
enum ConditionState { patrol, chase, idle, attack }

class CrabbyEnemey extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final Vector2 inputSize;
  final double maxLeft;
  final double maxRight;

  CrabbyEnemey(
      {required this.inputPosition,
      required this.inputSize,
      required this.maxLeft,
      required this.maxRight})
      : super(position: inputPosition, size: inputSize);

  // create animation for each state of crabby
  late SpriteAnimation idleAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation fallAnimation;
  late SpriteAnimation attackAnimation;
  late SpriteAnimation hitAnimation;
  late SpriteAnimation deadHitAnimation;
  late SpriteAnimation deadGroundAnimation;

  // variable for state condition
  late ConditionState movementState;
  bool faceRight = true;
  bool isMoving = false;
  Vector2 enemyAcceleration = Vector2(10, 12);
  Vector2 enemyVelocity = Vector2(0, 0);
  double targetPosition = 0.0;
  late Vector2 startPositionMovement;
  double movementDuration = 10.0;
  double counterDuration = 0.0;
  bool firstLoaded = true;

  // variable for jumo
  bool isJump = false;

  // variable for chasing player
  Vector2 playerTargetPosition = Vector2.zero();
  bool doChasePlayer = false;
  bool isGotPlayer = false;
  bool isFinishChase = false;

  // variable for attack player
  bool isEntterAttackMode = false;
  bool isOnCooldownBeforeAttack = false;
  bool isOnColldownAfterAttack = false;
  double cooldownCounter = 0.0;
  double cooldownDuration = 2.0;
  double cooldownBeforeAttackCounter = 0.0;
  double cooldownBeforeAttackDuration = 1.0;

  // variable for being attacked by player
  bool isBeingAttacked = false;

  // create ebnemy health
  double enemyHealth = 100;
  bool isHealthReduced = false;
  bool isDead = false;

  final Paint bgPaint = Paint()..color = const Color(0xFF333333);
  final Paint fgPaint = Paint()..color = const Color(0xFF4CAF50);
  final Paint borderPaint = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  FutureOr<void> onLoad() {
    // load every animation
    List<String> idleAnimationIMages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 04.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 05.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 06.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 07.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 08.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/01-Idle/Idle 09.png",
    ];

    idleAnimation = _loadAnimation(idleAnimationIMages);

    List<String> runAnimationImages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/02-Run/Run 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/02-Run/Run 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/02-Run/Run 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/02-Run/Run 04.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/02-Run/Run 05.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/02-Run/Run 06.png",
    ];

    runAnimation = _loadAnimation(runAnimationImages);

    List<String> jumpAnimationImages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/03-Jump/Jump 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/03-Jump/Jump 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/03-Jump/Jump 03.png",
    ];

    jumpAnimation = _loadAnimation(jumpAnimationImages);

    // load fall animation
    List<String> fallAnimationImages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/04-Fall/Fall 01.png",
    ];

    fallAnimation = _loadAnimation(fallAnimationImages);

    // load attack animation
    List<String> attackAnimationImages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/07-Attack/Attack 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/07-Attack/Attack 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/07-Attack/Attack 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/07-Attack/Attack 04.png",
    ];

    attackAnimation = _loadAnimation(attackAnimationImages);

    // load hit animation
    List<String> hitAnimationImages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/08-Hit/Hit 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/08-Hit/Hit 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/08-Hit/Hit 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/08-Hit/Hit 04.png",
    ];

    hitAnimation = _loadAnimation(hitAnimationImages);

    // load dead hit animation
    List<String> deadHitAnimationImages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/09-Dead Hit/Dead Hit 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/09-Dead Hit/Dead Hit 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/09-Dead Hit/Dead Hit 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/09-Dead Hit/Dead Hit 04.png",
    ];

    deadHitAnimation = _loadAnimation(deadHitAnimationImages);

    // load dead ground animation
    List<String> deadGroundAnimationImages = [
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/10-Dead Ground/Dead Ground 01.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/10-Dead Ground/Dead Ground 02.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/10-Dead Ground/Dead Ground 03.png",
      "Treasure Hunters/The Crusty Crew/Sprites/Crabby/10-Dead Ground/Dead Ground 04.png",
    ];

    deadGroundAnimation = _loadAnimation(deadGroundAnimationImages);

    // create animation
    animations = {
      CrabbyState.idle: idleAnimation,
      CrabbyState.run: runAnimation,
      CrabbyState.jump: jumpAnimation,
      CrabbyState.fall: fallAnimation,
      CrabbyState.attack: attackAnimation,
      CrabbyState.hit: hitAnimation,
      CrabbyState.dead: deadHitAnimation,
      CrabbyState.deadGround: deadGroundAnimation
    };

    // set initial animation as idle
    current = CrabbyState.idle;

    // set movement state
    movementState = ConditionState.idle;

    // add hitbox for detect main player and object around
    addAll([
      ObjectDetectionHitbox(
          inputPosition: Vector2(inputSize.x / 2, inputSize.y / 2),
          crabby: this),
      PlayerDetectionHitbox(
          inputPosition: Vector2(inputSize.x / 2, inputSize.y / 2),
          crabby: this)
    ]);

    add(EnemyBodyHitbox(
        inputPosition: Vector2(32, 12),
        inputSize: Vector2(128, inputSize.y - 22)));

    // set anchor
    anchor = Anchor.center;

    // set initial start position
    startPositionMovement = inputPosition;

    debugMode = false;

    priority = 10;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // handle reduced on health
    _reducedEnemeyHealth();

    if (!isDead) {
      // update animation state
      _updateStateBasedOnCondition();

      // update movement
      _updatePositionBasedOnCondition(dt);

      // handle gravity
      _handleGravity(dt);
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check if other was a player and in attack mode
    if (other is MainPlayer && other.isAttack && !isBeingAttacked) {
      // set being attack to true
      isBeingAttacked = true;

      // set state into idle
      movementState = ConditionState.idle;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (enemyHealth < 100 && enemyHealth > 0) {
      final barWidth = size.x;
      final barHeight = 6.0;

      final double x = anchor == Anchor.center ? (-size.x / 2) + 100.0 : 0.0;
      final double y = anchor == Anchor.center ? (-size.y / 2) + 40.0 : -12.0;

      final healthRatio = (enemyHealth / 100).clamp(0.0, 1.0);

      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        bgPaint,
      );

      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth * healthRatio, barHeight),
        fgPaint,
      );

      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        borderPaint,
      );
    }
  }

  void doJump() {
    if (!isJump) {
      enemyVelocity.y = -40;

      isJump = true;
    }
  }

  // function to handle gravity
  void _handleGravity(double dt) {
    // update vertical velocity
    enemyVelocity.y += enemyAcceleration.y * dt;

    // update position
    position.y += enemyVelocity.y * dt;

    // update start position y
    startPositionMovement.y = position.y;
  }

  // function to chase the player
  void chasePlayer(Vector2 playerPosition) {
    if (!isGotPlayer && !isBeingAttacked) {
      // chase player while it is not yet gotted
      // update state chase player
      if (movementState != ConditionState.chase) {
        movementState = ConditionState.chase;
        enemyVelocity.x = 0.0;
      }

      // keep update player position
      playerTargetPosition = playerPosition;

      // set do chase player to true
      doChasePlayer = true;
    }
  }

  // function to release player
  void releasedPlayer() {
    // chase player again
    isGotPlayer = false;

    // set on attack to false
    isEntterAttackMode = false;

    // set cooldown to zero
    cooldownCounter = 0.0;
    isOnColldownAfterAttack = false;
  }

  // function to finish chase player
  void finishChasePlayer() {
    // this function called when player out of the range
    movementState = ConditionState.idle;

    // set back velocity to zero
    enemyVelocity.x = 0;

    // set is moving to false
    isMoving = false;

    // set is finish chase to true
    isFinishChase = true;

    // set enter attack mode to false
    isEntterAttackMode = false;

    // set cooldown attack to false
    isOnColldownAfterAttack = false;
  }

  // function when get player
  void onGetPlayer() {
    if (!isGotPlayer) {
      // set do chase player
      doChasePlayer = false;

      // set enemy to idle for a while
      isGotPlayer = true;

      // set to idle state, it will be handle on idle scope
      movementState = ConditionState.idle;

      // set is moving to false
      isMoving = false;

      // set velocity back to 0
      enemyVelocity.x = 0;

      isFinishChase = true;

      // set current movement state to attack
      movementState = ConditionState.attack;

      // set cool down to true
      isOnCooldownBeforeAttack = true;
    }
  }

  // function to reduced health
  void _reducedEnemeyHealth() {
    if (isBeingAttacked && !isHealthReduced) {
      // update helath reduced
      isHealthReduced = true;

      // reduced health
      enemyHealth -= 10;
    }

    // check if enemy health and less then zero
    if (enemyHealth <= 0) {
      // set is dead to true
      isDead = true;

      // push enemy to the oposite side of the player
      if (position.x > game.player.position.x) {
        position.x += 10;
      } else {
        position.x -= 10;
      }

      // update current animation state into dead hit
      current = CrabbyState.dead;

      // called future function to remove  the enemy
      Future.delayed(Duration(milliseconds: 250), () {
        // update position
        position.y += 20;

        // update current state to dead ground
        current = CrabbyState.deadGround;

        // called future function to remove from parent
        Future.delayed(Duration(milliseconds: 350), () {
          removeFromParent();
        });
      });
    }
  }

  // function when released from plyer

  void _updatePositionBasedOnCondition(double dt) {
    // check every condition
    switch (movementState) {
      case ConditionState.idle:
        // check if first time loaded or not
        if (firstLoaded) {
          firstLoaded = false;

          if (!isMoving) {
            // set is moving to true
            isMoving = true;

            Future.delayed((Duration(milliseconds: 1000)), () {
              // update state
              movementState = ConditionState.patrol;

              // set target position
              targetPosition = maxRight - width;
            });
          }
        } else if (isGotPlayer) {
          if (!isMoving) {
            isMoving = true;

            Future.delayed((Duration(milliseconds: 200)), () {
              // make player silent for a while, before chasing again
              // set got to false again
              isGotPlayer = false;
            });
          }
        } else if (isBeingAttacked) {
          // stop player
          isMoving = false;

          // pushed player based on main player position
          if (game.player.position.x > position.x) {
            // main player on right, push enemy to left
            position.x -= 7.0;
          } else {
            // main player on left, push enemy to right
            position.x += 7.0;
          }
        } else {
          // update movement duration
          movementDuration = 20.0;

          if (!isMoving) {
            // set is moving to true
            isMoving = true;

            Future.delayed((Duration(milliseconds: 1000)), () {
              // update face to oposite direction
              faceRight = !faceRight;

              // update start position as current position
              startPositionMovement = position.clone();

              // update state
              movementState = ConditionState.patrol;

              // restart counter duration if it being interupt
              counterDuration = 0.0;

              // set target position
              if (!isFinishChase) {
                if (faceRight) {
                  targetPosition = maxRight - width;
                } else {
                  targetPosition = maxLeft + width;
                }
              }

              // update is finish chase to false
              isFinishChase = false;
            });
          }
        }

        break;
      case ConditionState.patrol:
        // validate face again
        if (targetPosition > position.x) {
          // target on the right, set face right to true
          faceRight = true;
        } else {
          faceRight = false;
        }

        // update counter duration
        counterDuration += dt;

        final movementProgress =
            (counterDuration / movementDuration).clamp(0.0, 1.0);

        // trasnform progress to curved progress
        final curvedProgress = Curves.easeInOut.transform(movementProgress);

        // check if already reach the target
        if (movementProgress >= 1.0) {
          // set back the state to idle
          movementState = ConditionState.idle;

          // set is moving to false
          isMoving = false;

          // reset counter duration
          counterDuration = 0.0;
        }

        // update movement
        position.setFrom(startPositionMovement);
        position.lerp(Vector2(targetPosition, position.y), curvedProgress);

        break;
      case ConditionState.chase:
        // chase condition
        if (doChasePlayer) {
          // check target player position
          if (playerTargetPosition.x < position.x) {
            // set player face to left
            faceRight = false;
          } else {
            faceRight = true;
          }
        }

        // do chase movement
        enemyVelocity.x += (faceRight ? 1 : -1) * (enemyAcceleration.x) * dt;

        position.x += enemyVelocity.x * dt;

        // set cooldown to false if its not
        isOnColldownAfterAttack = false;
      case ConditionState.attack:
        // on attack mode, set velocity to 0
        enemyVelocity.x = 0;

        // update cooldown counter
        cooldownCounter += dt;
        cooldownBeforeAttackCounter += dt;

        // check if cooldown is over
        if (cooldownCounter >= cooldownDuration) {
          // set back cooldown
          cooldownCounter = 0.0;

          // set on cooldown to false
          isOnColldownAfterAttack = false;
        }

        // check if cooldows is over
        if (cooldownBeforeAttackCounter >= cooldownBeforeAttackDuration) {
          // set back cooldown before attack
          cooldownBeforeAttackCounter = 0.0;

          isOnCooldownBeforeAttack = false;
        }
    }
  }

  void _updateStateBasedOnCondition() {
    if (faceRight) {
      scale.x = -1;
    } else {
      scale.x = 1;
    }

    // check every condition
    switch (movementState) {
      case ConditionState.idle:
        if (isBeingAttacked) {
          current = CrabbyState.hit;

          // set being attac to false, to stop the player position under attack
          isBeingAttacked = false;

          // call future function to update state to idle again
          Future.delayed(Duration(milliseconds: 250), () {
            isBeingAttacked = false;

            isHealthReduced = false;

            current = CrabbyState.idle;
          });
        } else {
          current = CrabbyState.idle;
        }

        break;
      case ConditionState.patrol:
      case ConditionState.chase:
        // check state based on movement
        if (enemyVelocity.y < 0) {
          current = CrabbyState.jump;
        } else if (enemyVelocity.y > 0) {
          current = CrabbyState.fall;
        } else {
          current = CrabbyState.run;
        }
      case ConditionState.attack:
        // attack condition, check if already attack or not
        if (!isEntterAttackMode &&
            !isOnColldownAfterAttack &&
            !isOnCooldownBeforeAttack) {
          // set to true
          isEntterAttackMode = true;
          isOnColldownAfterAttack = true;

          // set cooldown before attack
          isOnCooldownBeforeAttack = false;

          // set current animation to attack animation
          current = CrabbyState.attack;

          // set a future function to update current state to idle
          Future.delayed(Duration(milliseconds: 300), () {
            movementState = ConditionState.idle;
            counterDuration = 0.0;

            isEntterAttackMode = false;

            // update start position
            startPositionMovement = position.clone();
          });
        } else if (current == CrabbyState.run) {
          // check if crabby running at cooldown, set it to idle
          current = CrabbyState.idle;
        }
    }
  }

  SpriteAnimation _loadAnimation(List<String> images) {
    final spriteList = images.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}

/**
 * Enemy Movement Logic
 * 1. Akan dilakukan pembuatan circle hitbox dengan radius 100 pixel dari enemy
 * 2. Circle hitbox ini akan mendeteksi setiap object yang ada disekitar player
 * sehingga, dapat dilakukan pengambilan keputusan berdasarkan object yang berada
 * dis sekitar enemy. beberapa object yang menjadi pertimbangan adalah
 * 1. dinding, dimana saat berada di dekat dining ini object akan mendeteksi berapa jarak dengan dinding dan juga ketinggian dari dinding.
 * jika dinding memiliki tinggi yang dapat dilompati, maka enemy akan bergerak mendekat ke dinding dan melakukan loncat, jika tidak
 * enemy akan berhenti dan berbalik arah.
 * 2. Player. Jika enemy mendeteksi player berada pada range, maka enemy akan bergerak ke arah player tersebut.
 * jika kondisi enemy sangat dekat dengan player maka enemy akan diam dan berganti ke attack modde.
 * 
 * Movement Logic
 * 1. Kondisi awal, enemy akan berada pada kondisi idle
 * 2. Seteleh beberapa detik kondisi idle, enemy akan berada pada kondisi patrol.
 * Pada kondisi patrol, akan memiliki movement logic seperti diatas
 */
