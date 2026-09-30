import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class ShipWindowLight extends SpriteComponent with HasGameReference<MainGame> {
  final Vector2 inputPosition;

  ShipWindowLight({required this.inputPosition})
      : super(position: inputPosition, size: Vector2(132.0, 132.0));

  // --- Ship Motion (Rocking & Swaying) ---
  double _motionTimer = 0.0;
  final double rockSpeed = 1.2; // Speed of the ship rolling on waves
  final double maxRockAngle = 0.08; // ~4.5 degrees rotation sway (in radians)
  final double maxSwayDistance = 4.0; // Horizontal shift distance in pixels

  // --- Light Shimmer (Flicker) ---
  double _shimmerTimer = 0.0;
  final double minOpacity = 0.4;
  final double maxOpacity = 1.0;
  final double shimmerSpeed = 2.8;

  final Random _random = Random();

  @override
  FutureOr<void> onLoad() {
    // get image
    String imageUrl =
        "Treasure Hunters/Pirate Ship/Sprites/Decorations/Window/Window Light/01.png";

    // load image
    final image = game.images.fromCache(imageUrl);

    // assign sprite
    sprite = Sprite(image);

    paint.blendMode = BlendMode.screen;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    _motionTimer += dt * rockSpeed;

    // Smooth ocean wave oscillation (-1.0 to 1.0)
    double waveFactor = sin(_motionTimer);

    // Gently rotate the light beam around its origin (window frame)
    angle = waveFactor * maxRockAngle;

    // Slightly shift the light beam horizontally as the ship pitches
    position.x = inputPosition.x + (waveFactor * maxSwayDistance);

    _shimmerTimer += dt * shimmerSpeed;

    double sinePulse = (sin(_shimmerTimer) + 1.0) / 2.0;
    double organicFlicker = (_random.nextDouble() - 0.5) * 0.06;

    double calculatedOpacity =
        minOpacity + (maxOpacity - minOpacity) * sinePulse + organicFlicker;

    paint.color = paint.color.withOpacity(
      calculatedOpacity.clamp(minOpacity, maxOpacity),
    );
    super.update(dt);
  }
}
