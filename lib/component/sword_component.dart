import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pirate_action/component/main_player.dart';
import 'package:pirate_action/core/custom_hitbox.dart';
import 'package:pirate_action/main_game.dart';

class SwordComponent extends SpriteAnimationComponent
    with HasGameReference<MainGame>, CollisionCallbacks {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  SwordComponent({required this.inputPosition, required this.inputSize})
    : super(position: inputPosition, size: inputSize);

  // create hitbox
  CustomHitbox swordCustomHitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 56,
    height: 56,
  );

  @override
  FutureOr<void> onLoad() {
    // load all sword animation
    List<String> allSwordAnimatioNResource = [
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 01.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 02.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 03.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 04.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 05.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 06.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 07.png",
      "Treasure Hunters/Captain Clown Nose/Sprites/Captain Clown Nose/Sword/21-Sword Idle/Sword Idle 08.png",
    ];

    // create image sprite
    final spriteList = allSwordAnimatioNResource.map((resource) {
      final cacheImage = game.images.fromCache(resource);

      return Sprite(cacheImage);
    }).toList();

    // create animation
    final swordAnimation = SpriteAnimation.spriteList(
      spriteList,
      stepTime: 0.05,
    );

    // set the animation
    animation = swordAnimation;

    // add hitbox
    add(
      RectangleHitbox(
        position: Vector2(swordCustomHitbox.offsetX, swordCustomHitbox.offsetY),
        size: Vector2(swordCustomHitbox.width, swordCustomHitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // check when collide with player
    if (other is MainPlayer) {
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}
