import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlayerDetectionHitbox extends CircleHitbox {
  final Vector2 inputPosition;

  PlayerDetectionHitbox({required this.inputPosition})
      : super(
            position: inputPosition,
            radius: 100,
            isSolid: false,
            anchor: Anchor.center);
}
