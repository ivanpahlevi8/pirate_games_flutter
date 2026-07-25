import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/core/player_platform_collision.dart';
import 'package:pirate_action/main_game.dart';

enum playerState { Idle, Run, Jump, Fall }

class MainPlayer extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame> {
  // create state for each player state
  late final SpriteAnimation playerIdleAnimation;
  late final SpriteAnimation playerRunAnimation;
  late final SpriteAnimation playerJumpAnimation;
  late final SpriteAnimation playerFallAnimation;

  // parameter player to move
  int playerDirectionMove = 0;
  int playerVelocity = 150;
  int gravity_speed = 10;
  Vector2 velocity = Vector2.all(0);

  // parameter for handle jump
  bool isJump = false;

  // list of all collision blocks
  List<CollisionBlock> allCollisionBlock = [];

  @override
  FutureOr<void> onLoad() {
    size = Vector2(128, 128);

    anchor = Anchor.center;
    /**
     * NOTES FOR ANCHOR
     * Because of the anchor was set to center, the player posiiton become differet,
     * now it will draw on the center of the image, so for comparison
     * 1. If the anchor was set to top left then the coordinate of the top left of the box become (100, 100) or initial value that being set for the player
     * 2. If the anchor was set to center then the coordinate become (100 - (64/2), (100 - (64/2))), it because the player was drawn with perspective to the center of the player
     * which is why the top left coordinate is being substract by the half of the player size
     * It also same as the bottom, it will be (100 + (64/2), 100 + (64/2))
     */

    debugMode = true;

    // load all player
    _loadAllPlayerState();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // update player movement
    _handlePlayerMovement(dt);

    // update collision with platform
    _handleCollisionWithPlatform();

    // handle player gravity
    _handleGravity(dt);

    _handleVerticalCollisionPlatform();

    _handleJump(dt);

    // update palyer state
    _handlePlayerState();

    super.update(dt);
  }

  void _loadAllPlayerState() async {
    // create image list for idle animation
    List<String> idleAnimationList = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/01-Idle/Idle 01.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/01-Idle/Idle 02.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/01-Idle/Idle 03.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/01-Idle/Idle 04.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/01-Idle/Idle 05.png",
    ];

    playerIdleAnimation = await _createPlayerAnimation(idleAnimationList);

    // create image list for run animation
    List<String> runAnimationList = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/02-Run/Run 01.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/02-Run/Run 02.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/02-Run/Run 03.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/02-Run/Run 04.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/02-Run/Run 05.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/02-Run/Run 06.png",
    ];

    playerRunAnimation = await _createPlayerAnimation(runAnimationList);

    // create image list for jump animation
    List<String> jumpAnimationList = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/03-Jump/Jump 01.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/03-Jump/Jump 02.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/03-Jump/Jump 03.png",
    ];

    playerJumpAnimation = await _createPlayerAnimation(jumpAnimationList);

    // create image list for fall animation
    List<String> fallAnimationList = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Captain Clown Nose without Sword/04-Fall/Fall 01.png",
    ];

    playerFallAnimation = await _createPlayerAnimation(fallAnimationList);

    animations = {
      playerState.Idle: playerIdleAnimation,
      playerState.Run: playerRunAnimation,
      playerState.Jump: playerJumpAnimation,
      playerState.Fall: playerFallAnimation,
    };

    current = playerState.Idle;
  }

  // function to handle player movement
  void _handlePlayerMovement(double dt) {
    // update player position
    position.x += (playerDirectionMove * playerVelocity) * dt;
  }

  // function to handle player state
  void _handlePlayerState() {
    if (playerDirectionMove < 0) {
      scale.x = -1.0;
    } else {
      scale.x = 1.0;
    }

    // handle horizontal case
    if (playerDirectionMove != 0 && velocity.y == 0) {
      current = playerState.Run;
    } else if (velocity.y > 0) {
      // player fall
      current = playerState.Fall;
    } else if (velocity.y < 0) {
      // player jump
      current = playerState.Jump;
    } else {
      current = playerState.Idle;
    }
  }

  Future<SpriteAnimation> _createPlayerAnimation(List<String> imageUrl) async {
    // generate list of sprite
    final listOfSprites = imageUrl.map((path) {
      // 💡 Crucial: Pull directly from your preloaded game instance cache!
      final cachedImage = game.images.fromCache(path);
      return Sprite(cachedImage);
    }).toList();

    // generate sprite animation
    return SpriteAnimation.spriteList(listOfSprites, stepTime: 0.05);
  }

  // function to handle collision with
  void _handleCollisionWithPlatform() {
    for (final platform in allCollisionBlock) {
      // check is collide
      final isCollide = checkCollisionPlayerWithPlatform(this, platform);

      // check collision on horizontal
      if (playerDirectionMove != 0) {
        if (isCollide && playerDirectionMove > 0) {
          // collision happen on right, update player position
          position.x = platform.position.x - width / 2;

          // set velocity to 0
          playerDirectionMove = 0;
        } else if (isCollide && playerDirectionMove < 0) {
          // collision happen on left, update
          position.x = platform.position.x + platform.width + width / 2;

          // set player direction
          playerDirectionMove = 0;
        }
      }
    }
  }

  void _handleVerticalCollisionPlatform() {
    for (final platform in allCollisionBlock) {
      // check is collide
      final isCollide = checkCollisionPlayerWithPlatform(this, platform);

      // check collision on vertical
      if (isCollide && velocity.y > 0) {
        position.y = platform.y - width / 2;

        velocity.y = 0;
      }
    }
  }

  // function to handle gravity
  void _handleGravity(double dt) {
    velocity.y += gravity_speed * dt;

    position.y += velocity.y;
  }

  // function to handle jump
  void _handleJump(double dt) {
    if (isJump) {
      velocity.y = -10;

      position.y += velocity.y;
    }
  }
}
