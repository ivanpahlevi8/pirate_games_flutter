import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:pirate_action/main_game.dart';

enum CloudPosition { left, centerToRight, centerToLeft, right }

class CloudObject extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  CloudObject({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  // variable for movement
  double movementDuration = 10.0;
  double movementInterval = 0.0;
  double offsetMoement = 200.0;
  CloudPosition currentPosition = CloudPosition.centerToRight;
  double targetPosition = 0.0;

  @override
  FutureOr<void> onLoad() {
    // get all images animation
    List<String> imagesAnimation = [
      "Treasure Hunters/Palm Tree Island/Sprites/Background/Small Cloud 1.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Background/Small Cloud 2.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Background/Small Cloud 3.png",
    ];

    final spriteList = imagesAnimation.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.05);

    priority = -10;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // update time
    movementInterval += dt;

    // get progress
    final movementProgress =
        (movementInterval / movementDuration).clamp(0.0, 1.0);

    // trasnform progress to curved progress
    final curvedProgress = Curves.easeInOut.transform(movementProgress);

    // case based on current position
    switch (currentPosition) {
      case CloudPosition.centerToRight:
        // update target position
        targetPosition = inputPosition.x + offsetMoement;

        // check if current position os on the target, which is right
        if (position.x >= targetPosition) {
          currentPosition = CloudPosition.right;

          // reset movement interval
          movementInterval = 0.0;

          break;
        }

        // update movement
        position.setFrom(inputPosition);
        position.lerp(Vector2(targetPosition, inputPosition.y), curvedProgress);

        break;

      case CloudPosition.right:
        // update target position
        targetPosition = inputPosition.x;

        // check if its reached target or not
        if (position.x <= targetPosition) {
          // update position
          currentPosition = CloudPosition.centerToLeft;

          // reset movement interval
          movementInterval = 0.0;

          break;
        }

        // update movement
        position
            .setFrom(Vector2(inputPosition.x + offsetMoement, inputPosition.y));
        position.lerp(Vector2(targetPosition, inputPosition.y), curvedProgress);

        break;

      case CloudPosition.centerToLeft:
        // update target position
        targetPosition = inputPosition.x - offsetMoement;

        // check if its reached target or not
        if (position.x <= targetPosition) {
          // update current position
          currentPosition = CloudPosition.left;

          // restart time
          movementInterval = 0.0;

          break;
        }

        // update movement
        position.setFrom(inputPosition);
        position.lerp(Vector2(targetPosition, inputPosition.y), curvedProgress);

        break;

      case CloudPosition.left:
        // update target position
        targetPosition = inputPosition.x;

        // check if reached the target or not
        if (position.x >= targetPosition) {
          // update current position
          currentPosition = CloudPosition.centerToRight;

          // restart timer
          movementInterval = 0.0;

          break;
        }

        // update movement
        position
            .setFrom(Vector2(inputPosition.x - offsetMoement, inputPosition.y));
        position.lerp(Vector2(targetPosition, inputPosition.y), curvedProgress);

        break;

      default:
        break;
    }

    super.update(dt);
  }
}
