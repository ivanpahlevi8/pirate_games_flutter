import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/main_player.dart';
import 'package:pirate_action/main_game.dart';

enum CoinState { idle, collected }

class CoinTreasure extends SpriteAnimationGroupComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final String coinColor;

  CoinTreasure({required this.inputPosition, required this.coinColor})
      : super(position: inputPosition, size: Vector2(32, 32));

  late SpriteAnimation idleCoinAnimation;
  late SpriteAnimation collectedCoinAnimation;

  // variable collected
  bool isCollected = false;

  @override
  FutureOr<void> onLoad() {
    List<String> idleAnimationImages = [
      "Treasure Hunters/Pirate Treasure/Sprites/$coinColor Coin/01.png",
      "Treasure Hunters/Pirate Treasure/Sprites/$coinColor Coin/02.png",
      "Treasure Hunters/Pirate Treasure/Sprites/$coinColor Coin/03.png",
      "Treasure Hunters/Pirate Treasure/Sprites/$coinColor Coin/04.png",
    ];

    idleCoinAnimation = _loadAnimation(idleAnimationImages);

    List<String> collectedAnimationImages = [
      "Treasure Hunters/Pirate Treasure/Sprites/Coin Effect/01.png",
      "Treasure Hunters/Pirate Treasure/Sprites/Coin Effect/02.png",
      "Treasure Hunters/Pirate Treasure/Sprites/Coin Effect/03.png",
    ];

    collectedCoinAnimation = _loadAnimation(collectedAnimationImages);

    animations = {
      CoinState.idle: idleCoinAnimation,
      CoinState.collected: collectedCoinAnimation
    };

    current = CoinState.idle;

    // add hitbox
    add(RectangleHitbox(position: Vector2.all(8.0), size: Vector2.all(8)));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check collision with player
    if (other is MainPlayer && !isCollected) {
      // set is collected to true
      isCollected = true;

      // add coin collecter
      game.updateCollectedCoin(coinColor);

      // update state into collected
      current = CoinState.collected;

      // call fucntion to remove coin from parent
      Future.delayed(Duration(milliseconds: 200), () {
        removeFromParent();
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  SpriteAnimation _loadAnimation(List<String> images) {
    final spriteList = images.map((image) {
      final getImage = game.images.fromCache(image);

      return Sprite(getImage);
    }).toList();

    return SpriteAnimation.spriteList(spriteList, stepTime: 0.05);
  }
}
