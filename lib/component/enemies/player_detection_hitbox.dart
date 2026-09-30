import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/enemies/enemy_interface.dart';
import 'package:pirate_action/component/main_player/main_player.dart';

class PlayerDetectionHitbox extends PositionComponent with CollisionCallbacks {
  final EnemyInterface enemy;
  final Vector2 inputPosition;
  final Vector2 inputSize;

  PlayerDetectionHitbox(
      {required this.inputPosition,
      required this.enemy,
      required this.inputSize})
      : super(position: inputPosition, size: inputSize, anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    // add hitbox
    add(RectangleHitbox(
        position: Vector2.all(0.0), size: inputSize, isSolid: true));

    debugMode = true;

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with other player
    if (other is MainPlayer) {
      // called function to chase the player
      enemy.chasePlayer(other.position);
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // check parent
    if (other is MainPlayer) {
      enemy.finishChasePlayer();
    }

    super.onCollisionEnd(other);
  }
}
