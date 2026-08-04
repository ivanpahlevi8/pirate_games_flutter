import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class LeftPalmTree extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  LeftPalmTree({required this.inputPosition, required this.inputSize})
    : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // get all image animation
    List<String> imageAnimations = [
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Left 01.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Left 02.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Left 03.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Left 04.png",
    ];

    // create sprite image from images
    final listSpriteImage = imageAnimations.map((image) {
      // get image
      final getImage = game.images.fromCache(image);

      // return sprite
      return Sprite(getImage);
    }).toList();

    // create animation
    animation = SpriteAnimation.spriteList(listSpriteImage, stepTime: 0.05);

    return super.onLoad();
  }
}
