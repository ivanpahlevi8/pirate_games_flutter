import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/enemies/crabby_enemy.dart';

class ObjectDetectionHitbox extends PositionComponent with CollisionCallbacks {
  final Vector2 inputPosition;
  final CrabbyEnemey crabby;

  ObjectDetectionHitbox({required this.inputPosition, required this.crabby})
      : super(
            position: inputPosition,
            size: Vector2(280, 8),
            anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    debugMode = false;

    // add hitbox
    add(RectangleHitbox(
        position: Vector2.all(0.0), size: Vector2(280, 8), isSolid: true));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision for collision block
    if (other is CollisionBlock) {
      // check object condition
      if ((crabby.position.y + (crabby.height / 2)) > other.position.y) {
        crabby.doJump();
      }
    }

    super.onCollision(intersectionPoints, other);
  }
}
