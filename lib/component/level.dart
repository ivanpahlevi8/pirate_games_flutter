import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pirate_action/component/main_player.dart';
import 'package:pirate_action/main_game.dart';

class Level extends World with HasGameReference<MainGame> {
  //final Player player;
  final String levelTitle;
  final MainPlayer player;

  Level({required this.levelTitle, required this.player});

  // create tiled component
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    // load tiled component from assets
    level = await TiledComponent.load("$levelTitle.tmx", Vector2.all(16));

    add(level);

    //_drawBackground();

    add(player);

    return super.onLoad();
  }
}
