import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class CanonFireComponent extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  CanonFireComponent({required this.inputPosition, required this.inputSize})
    : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // create get animation images
    List<String> animationImage = [
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire Effect/1.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire Effect/2.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire Effect/3.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire Effect/4.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire Effect/5.png",
      "Treasure Hunters/Shooter Traps/Sprites/Cannon/Cannon Fire Effect/6.png",
    ];

    // cast into sprite list
    final spriteList = animationImage.map((image) {
      // get image
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.05);

    // set scale
    scale.x = -1;

    // function to be called to remove from parent
    Future.delayed(Duration(milliseconds: 350), () {
      removeFromParent();
    });

    return super.onLoad();
  }
}
