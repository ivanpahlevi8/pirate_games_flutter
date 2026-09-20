import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class WaterTopComponent extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  WaterTopComponent({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // get all images
    final allImagesString = [
      "Treasure Hunters/Merchant Ship/Sprites/Water/Water/Top/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Water/Water/Top/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Water/Water/Top/3.png",
      "Treasure Hunters/Merchant Ship/Sprites/Water/Water/Top/4.png",
    ];

    // load string as sprite list
    List<Sprite> spriteList = allImagesString.map((e) {
      // get image
      final getImage = game.images.fromCache(e);

      return Sprite(getImage);
    }).toList();

    // load animation
    animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.05);

    return super.onLoad();
  }
}
