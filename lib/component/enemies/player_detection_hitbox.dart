import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/enemies/crabby_enemy.dart';
import 'package:pirate_action/component/main_player/main_player.dart';

class PlayerDetectionHitbox extends PositionComponent with CollisionCallbacks {
  final CrabbyEnemey crabby;
  final Vector2 inputPosition;

  PlayerDetectionHitbox({required this.inputPosition, required this.crabby})
      : super(
            position: inputPosition,
            size: Vector2(500, 500),
            anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    // add hitbox
    add(RectangleHitbox(
        position: Vector2.all(0.0), size: Vector2.all(500), isSolid: true));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with other player
    if (other is MainPlayer) {
      // called function to chase the player
      crabby.chasePlayer(other.position);
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // check parent
    if (other is MainPlayer) {
      crabby.finishChasePlayer();
    }

    super.onCollisionEnd(other);
  }
}
