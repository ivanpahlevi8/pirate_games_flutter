import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class RightPlamTree extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  RightPlamTree({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // get all image
    List<String> allImageAnimation = [
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Right 01.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Right 02.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Right 03.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Right 04.png",
    ];

    // create sprites
    final spritesImageList = allImageAnimation.map((image) {
      // get image
      final getImageLoad = game.images.fromCache(image);

      // reutrn sprite from image
      return Sprite(getImageLoad);
    }).toList();

    // set animation from sprite list
    animation = SpriteAnimation.spriteList(spritesImageList, stepTime: 0.05);

    return super.onLoad();
  }
}
