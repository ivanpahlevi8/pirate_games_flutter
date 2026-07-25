import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/main_player.dart';

bool checkCollisionPlayerWithPlatform(
  MainPlayer player,
  CollisionBlock collision,
) {
  // get player actual x and y position that result of using anchor center
  double playerLeft = player.position.x - (player.width / 2);
  double playerTop = player.position.y - (player.height / 2);
  double playerRight = playerLeft + player.width;
  double playerBottom = playerTop + player.height;

  // Get collision block edges
  double boxLeft = collision.position.x;
  double boxTop = collision.position.y;
  double boxRight = boxLeft + collision.width;
  double boxBottom = boxTop + collision.height;

  // Standard AABB Collision checks
  bool isCollideOnRight = playerRight > boxLeft;
  bool isCollideOnLeft = playerLeft < boxRight;
  bool isCollideOnBottom = playerBottom > boxTop;
  bool isCollideOnTop = playerTop < boxBottom;

  return isCollideOnRight &&
      isCollideOnLeft &&
      isCollideOnBottom &&
      isCollideOnTop;
}
