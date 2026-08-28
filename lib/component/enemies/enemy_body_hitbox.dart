import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/enemies/crabby_enemy.dart';
import 'package:pirate_action/component/main_player/main_player.dart';

class EnemyBodyHitbox extends RectangleHitbox {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  EnemyBodyHitbox({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // set debug mode
    debugMode = false;
    triggersParentCollision = false;
    collisionType = CollisionType.passive;
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    // 2. THE FIX: Check the PARENT of the hitbox, not the hitbox itself
    if (other.parent is CollisionBlock) {
      if (parent is CrabbyEnemey) {
        CrabbyEnemey enemy = parent as CrabbyEnemey;

        // We also need to get the CollisionBlock to read its position
        CollisionBlock platform = other.parent as CollisionBlock;

        // check enemy movement
        if (enemy.enemyVelocity.y > 0) {
          // enemy fall, set velocity back to zero
          enemy.enemyVelocity.y = 0;

          // rearrange position to top of platform using the platform's Y
          enemy.position.y = platform.position.y - (enemy.height / 2) + 10;

          // set is jump to false again
          enemy.isJump = false;
        }
      }
    } else if (other.parent is MainPlayer) {
      // handle collision when its collide with player
      if (parent is CrabbyEnemey) {
        final getCrabby = parent as CrabbyEnemey;

        getCrabby.onGetPlayer();
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(ShapeHitbox other) {
    // check collide with
    if (other.parent is MainPlayer) {
      (parent as CrabbyEnemey).releasedPlayer();
    }
    super.onCollisionEnd(other);
  }
}
