import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class WaterReflect extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final bool isBig;
  final Vector2 inputSize;

  WaterReflect(
      {required this.inputPosition, required this.inputSize, this.isBig = true})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // load animation
    List<String> imageList = [
      "Treasure Hunters/Palm Tree Island/Sprites/Background/Water Reflect Big 01.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Background/Water Reflect Big 02.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Background/Water Reflect Big 03.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Background/Water Reflect Big 04.png",
    ];

    final spriteList = imageList.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.05);

    priority = -10;

    return super.onLoad();
  }
}
