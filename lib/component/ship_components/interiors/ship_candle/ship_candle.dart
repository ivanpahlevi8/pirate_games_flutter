import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/component/ship_components/interiors/ship_candle/ship_candle_light.dart';
import 'package:pirate_action/main_game.dart';

class ShipCandle extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  ShipCandle({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // load image url
    final imgUrl = [
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Candle/Candle/01.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Candle/Candle/02.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Candle/Candle/03.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Candle/Candle/04.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Candle/Candle/05.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Candle/Candle/06.png",
    ];

    // load image
    final getImages = imgUrl.map((url) {
      return game.images.fromCache(url);
    }).toList();

    // load sprite
    final spriteList = getImages.map((img) {
      return Sprite(img);
    }).toList();

    // load animation
    animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.05);

    // add candle light
    add(ShipCandleLight(
        inputPosition: Vector2(0.0, -30.0), inputSize: Vector2.all(72)));

    return super.onLoad();
  }
}
