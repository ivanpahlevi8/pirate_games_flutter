import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent with CollisionCallbacks {
  final Vector2 positionInput;
  final Vector2 sizeInput;
  final bool isPlatform;

  CollisionBlock({
    required this.positionInput,
    required this.sizeInput,
    required this.isPlatform,
  }) : super(position: positionInput, size: sizeInput);

  @override
  FutureOr<void> onLoad() {
    // add rectangle hitbox
    add(RectangleHitbox(position: Vector2(0, 0), size: sizeInput));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }
}
