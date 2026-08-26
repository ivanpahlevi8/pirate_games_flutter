import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/enemies/crabby_enemy.dart';

class ObjectDetectionHitbox extends RectangleHitbox {
  final Vector2 inputPosition;

  ObjectDetectionHitbox({required this.inputPosition})
      : super(
            position: inputPosition,
            size: Vector2(280, 8),
            isSolid: false,
            anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    // check collision for collision block
    if (other.parent is CollisionBlock) {
      if (parent is CrabbyEnemey) {
        CrabbyEnemey getParent = parent as CrabbyEnemey;
        CollisionBlock getOther = other.parent as CollisionBlock;

        // // set most bottom parent
        // double parentMostBottom = getParent.position.y + 16;

        // // check where parent facing
        // if (getParent.faceRight) {
        //   // check the distance with block
        //   if ((getOther.position.x - getParent.position.x <= 100) &&
        //       (getOther.position.y < parentMostBottom) &&
        //       !getParent.isJump) {
        //     print("${getParent.position.x} - ${getOther.position.x}");
        //     print("other height ${getOther.position.y}");
        //     print(
        //         "Most bottom enemy : ${getParent.position.y + getParent.height}");
        //     print("Do jump facing right");
        //     // do jump
        //     getParent.doJump();
        //   }
        // } else {
        //   // check the distance with block
        //   if ((getParent.position.x - (getOther.position.x + getOther.size.x) <=
        //           150) &&
        //       (getOther.position.y < parentMostBottom) &&
        //       !getParent.isJump) {
        //     print("Do jump facing left");
        //     print("${getParent.position.x} - ${getOther.position.x}");
        //     print("other height ${getOther.position.y}");
        //     print(
        //         "Most bottom enemy : ${getParent.position.y + getParent.height}");
        //     // do jump
        //     getParent.doJump();
        //   }
        // }
        if ((getParent.position.y + (getParent.height / 2)) >
            getOther.position.y) {
          print("Do jump");
          getParent.doJump();
        }
      }
    }

    super.onCollision(intersectionPoints, other);
  }
}
