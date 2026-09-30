import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/component/ship_components/interiors/ship_window/ship_window_light.dart';
import 'package:pirate_action/main_game.dart';

class ShipWindow extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  ShipWindow({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // load all window image
    final listAllImages = List.generate(
      74,
      (i) =>
          "Treasure Hunters/Pirate Ship/Sprites/Decorations/Window/Window/${(i + 1).toString().padLeft(2, '0')}.png",
    );

    // get iamge
    final getImages = listAllImages.map((imgUrl) {
      return game.images.fromCache(imgUrl);
    }).toList();

    // get sprites
    final getSprites = getImages.map((img) {
      return Sprite(img);
    }).toList();

    // set animation
    animation = SpriteAnimation.spriteList(getSprites, stepTime: 0.05);

    // add window light
    add(ShipWindowLight(inputPosition: Vector2(-70.0, 5.0)));

    return super.onLoad();
  }
}
