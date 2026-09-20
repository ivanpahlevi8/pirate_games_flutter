import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/main_player/main_player.dart';
import 'package:pirate_action/component/ship_components/ship/ship_component.dart';
import 'package:pirate_action/main_game.dart';

// create enum for sail
enum SailState { noWind, transitionToNoWind, transitionToWind, wind }

class SailComponent extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final Vector2 inputSize;
  final ShipComponent ship;

  SailComponent(
      {required this.inputPosition,
      required this.inputSize,
      required this.ship})
      : super(position: inputPosition, size: inputSize);

  @override
  FutureOr<void> onLoad() {
    // load no wind
    List<String> noWindImages = [
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/3.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/4.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/5.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/6.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/7.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/No Wind/8.png",
    ];

    final noWindAnimation = _loadAnimation(noWindImages);

    // load transition to no wind
    List<String> transitionToNoWindImages = [
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Transition to No Wind/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Transition to No Wind/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Transition to No Wind/3.png",
    ];

    final transitionToNoWindAnimation =
        _loadAnimation(transitionToNoWindImages);

    // load transition to wind
    List<String> transitionToWindImages = [
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Transition to Wind/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Transition to Wind/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Transition to Wind/3.png",
    ];

    final transitionToWindAnimation = _loadAnimation(transitionToWindImages);

    // load wind
    final windImages = [
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Wind/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Wind/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Wind/3.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Sail/Wind/4.png",
    ];

    final windAnimation = _loadAnimation(windImages);

    // create animation
    animations = {
      SailState.noWind: noWindAnimation,
      SailState.transitionToNoWind: transitionToNoWindAnimation,
      SailState.transitionToWind: transitionToWindAnimation,
      SailState.wind: windAnimation,
    };

    // select default animation
    current = SailState.noWind;

    // add hitbox for collision
    add(RectangleHitbox(
      position: Vector2.all(0.0),
      size: inputSize,
    ));

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collide with main player
    if (other is MainPlayer) {
      print("Collide with sail");
      // call function for delay
      Future.delayed(Duration(milliseconds: 200), () {
        // called once when collision happen, update state
        current = SailState.transitionToWind;

        // called function to update ship movement
        Future.delayed(Duration(milliseconds: 250), () {
          print("Set is ship moving to true");
          ship.isShipMoving = true;
        });
      });
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    // check if ship moving
    if (ship.isShipMoving) {
      // set current animation to wind,
      if (current != SailState.wind) {
        current = SailState.wind;
      }
    }

    super.update(dt);
  }

  // function to load animation
  SpriteAnimation _loadAnimation(List<String> imageResList) {
    // parse image into sprite
    List<Sprite> spriteList = imageResList.map((image) {
      // create image
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    // return animation
    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
