import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class DustMovement extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final double scaleValue;
  final String initialState;

  DustMovement(
      {required this.inputPosition,
      this.scaleValue = 1.0,
      required this.initialState})
      : super(
            position: inputPosition,
            size: Vector2(52, 20),
            removeOnFinish: true);

  // create each animation
  late SpriteAnimation fallAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation runAnimation;

  @override
  FutureOr<void> onLoad() {
    // load each animation
    List<String> fallAnimationImages = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Fall 01.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Fall 02.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Fall 03.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Fall 04.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Fall 05.png",
    ];

    fallAnimation = _loadAnimation(fallAnimationImages);

    List<String> jumpAnimationImages = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Jump 01.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Jump 02.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Jump 03.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Jump 04.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Jump 05.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Jump 06.png",
    ];

    jumpAnimation = _loadAnimation(jumpAnimationImages);

    List<String> runAnimationImages = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Run 01.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Run 02.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Run 03.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Run 04.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Dust Particles/Run 05.png",
    ];

    runAnimation = _loadAnimation(runAnimationImages);

    switch (initialState) {
      case "jump":
        animation = jumpAnimation;

        break;
      case "fall":
        animation = fallAnimation;

        break;
      default:
        animation = runAnimation;

        break;
    }

    return super.onLoad();
  }

  // function to load animation
  SpriteAnimation _loadAnimation(List<String> imagesAnimation) {
    final spriteList = imagesAnimation.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05, loop: false);
  }
}
