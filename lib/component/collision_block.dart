import 'dart:async';

import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
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
    return super.onLoad();
  }
}
