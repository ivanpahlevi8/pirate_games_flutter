import 'dart:async';

import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

enum ShipDoorState { open, close }

class ShipDoor extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  ShipDoor({
    required this.inputPosition,
    required this.inputSize,
  }) : super(position: inputPosition, size: inputSize);

  // variable for swithcing from open and close door
  bool isOpen = true;
  double counterChangeDoorState = 0.0;
  final doorChangeStateTime = 1.0;

  @override
  FutureOr<void> onLoad() {
    // load open animation
    final openImageList = [
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Opening/01.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Opening/02.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Opening/03.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Opening/04.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Opening/05.png",
    ];

    final openAnimation = _loadAnimation(openImageList);

    // load close animation
    final closeImageList = [
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Closing/01.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Closing/02.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Closing/03.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Closing/04.png",
      "Treasure Hunters/Pirate Ship/Sprites/Decorations/Door/Closing/05.png",
    ];

    final closeAnimation = _loadAnimation(closeImageList);

    // create animations
    animations = {
      ShipDoorState.open: openAnimation,
      ShipDoorState.close: closeAnimation,
    };

    // set curretn animation to open
    current = ShipDoorState.open;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // count timer
    counterChangeDoorState += dt;

    // check for time
    if (counterChangeDoorState >= doorChangeStateTime) {
      // reset timer
      counterChangeDoorState = 0.0;

      // change state
      if (isOpen) {
        // chance state to close
        current = ShipDoorState.close;
      } else {
        current = ShipDoorState.open;
      }

      // update state
      isOpen = !isOpen;
    }

    super.update(dt);
  }

  SpriteAnimation _loadAnimation(List<String> imageList) {
    final spriteList = imageList.map((image) {
      // get image
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05, loop: false);
  }
}
