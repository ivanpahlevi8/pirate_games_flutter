import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class ShipChain extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;
  final bool isBig;

  ShipChain(
      {required this.inputPosition,
      required this.inputSize,
      required this.isBig})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // get image of each chain
    final bigChainImgs = List.generate(
        8,
        (index) =>
            "Treasure Hunters/Pirate Ship/Sprites/Decorations/Chains/Big/0${index + 1}.png");

    final smallChainImgs = List.generate(
        8,
        (index) =>
            "Treasure Hunters/Pirate Ship/Sprites/Decorations/Chains/Small/0${index + 1}.png");

    final bigChainSpriteList = bigChainImgs.map((url) {
      final getImage = game.images.fromCache(url);

      return Sprite(getImage);
    }).toList();

    final smallChainSpriteList = smallChainImgs.map((url) {
      final getImage = game.images.fromCache(url);

      return Sprite(getImage);
    }).toList();

    // create animation for each
    final bigChainAnimation =
        SpriteAnimation.spriteList(bigChainSpriteList, stepTime: 0.05);

    final smallChainAnimation =
        SpriteAnimation.spriteList(smallChainSpriteList, stepTime: 0.05);

    // select animation based on input
    if (isBig) {
      animation = bigChainAnimation;
    } else {
      animation = smallChainAnimation;
    }

    return super.onLoad();
  }
}
