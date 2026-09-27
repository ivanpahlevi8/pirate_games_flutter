import 'package:flame/components.dart';

abstract interface class EnemyInterface {
  void chasePlayer(Vector2 playerPosition);
  void finishChasePlayer();
}
