import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/main_player/main_player.dart';
import 'package:pirate_action/component/ship_components/ship/sail_component.dart';
import 'package:pirate_action/main_game.dart';

class ShipComponent extends SpriteAnimationComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  ShipComponent({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  // parameter for ship movement
  final Vector2 shipAcceleration = Vector2(15.0, 0.0);
  Vector2 shipSpeed = Vector2(0.0, 0.0);
  bool isShipMoving = false;
  double endOfShip = 4452.0;

  @override
  FutureOr<void> onLoad() {
    // get all images
    final imagesString = [
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Ship/Idle/1.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Ship/Idle/2.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Ship/Idle/3.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Ship/Idle/4.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Ship/Idle/5.png",
      "Treasure Hunters/Merchant Ship/Sprites/Ship/Ship/Idle/6.png",
    ];

    // cast into sprite
    final spriteList = imagesString.map((img) {
      // get iamge
      final getImage = game.images.fromCache(img);

      return Sprite(getImage);
    }).toList();

    // set current animation
    animation = SpriteAnimation.spriteList(spriteList, stepTime: 0.05);

    // add hitbox on top of the ship, for player paltform
    add(RectangleHitbox(
        position: Vector2(0.0, 10.0), size: Vector2(inputSize.x, 20)));

    // add sailing
    final sailingHeight = 180.0;
    final sailingWidth = 64.0;
    add(SailComponent(
        inputPosition: Vector2(inputSize.x / 2, -(sailingHeight - 10.0)),
        inputSize: Vector2(sailingWidth, sailingHeight),
        ship: this));

    debugMode = true;

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with main player
    if (other is MainPlayer) {
      // check if main player have position y velocity
      if (other.velocity.y > 0) {
        // player fall, set to zero
        other.velocity.y = 0.0;

        // update its position
        other.position.y = position.y -
            other.playerCustomHitbox.height -
            other.playerCustomHitbox.offsetY +
            (other.height / 2) +
            10.0;

        // set player on board ship
        other.isOnBoardShip = true;
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // set user is not on board
    if (other is MainPlayer) {
      // set on board to false
      other.isOnBoardShip = false;
    }
    super.onCollisionEnd(other);
  }

  @override
  void update(double dt) {
    // update ship movement based ship movement
    if (isShipMoving) {
      // update ship speed
      shipSpeed.x += shipAcceleration.x * dt;

      if (shipSpeed.x >= 30.0) shipSpeed.x = 30.0;

      // update ship position
      position.x += shipSpeed.x * dt;

      // update player position based on the ship
      game.player.position.x += shipSpeed.x * dt;

      // check when ship already reach the end
      if ((position.x + inputSize.x) >= endOfShip) {
        // called function on game to stop
        print("Ship reached end");
        game.loadOnShip();
      }
    }
    super.update(dt);
  }
}
