import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class ShipCandleLight extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  ShipCandleLight({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // get local image
    final imgUrls = List.generate(
        4,
        (index) =>
            "Treasure Hunters/Pirate Ship/Sprites/Decorations/Candle/Candle Light/0${index + 1}.png");

    // get sprite
    final getSprites = imgUrls.map((url) {
      final getImage = game.images.fromCache(url);

      return Sprite(getImage);
    }).toList();

    // set animation
    animation = SpriteAnimation.spriteList(getSprites, stepTime: 0.05);

    return super.onLoad();
  }
}
