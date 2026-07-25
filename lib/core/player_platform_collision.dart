import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/main_player.dart';

bool checkCollisionPlayerWithPlatform(
  MainPlayer player,
  CollisionBlock collision,
) {
  // get player actual x and y position that result of using anchor center
  double playerLeft = player.position.x - (player.width / 2);
  double playerTop = player.position.y - (player.height / 2);

  // create player actual border
  double playerActualLeft = playerLeft + player.playerCustomHitbox.offsetX;
  double playerActualRight = playerActualLeft + player.playerCustomHitbox.width;
  double playerActualTop = playerTop + player.playerCustomHitbox.offsetY;
  double playerActualBottom =
      playerActualTop + player.playerCustomHitbox.height;

  // Get collision block edges
  double boxLeft = collision.position.x;
  double boxTop = collision.position.y;
  double boxRight = boxLeft + collision.width;
  double boxBottom = boxTop + collision.height;

  // Standard AABB Collision checks
  bool isCollideOnRight = playerActualRight > boxLeft;
  bool isCollideOnLeft = playerActualLeft < boxRight;
  bool isCollideOnBottom = playerActualBottom > boxTop;
  bool isCollideOnTop = playerActualTop < boxBottom;

  return isCollideOnRight &&
      isCollideOnLeft &&
      isCollideOnBottom &&
      isCollideOnTop;
}
