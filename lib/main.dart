import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pirate_action/main_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  MainGame game = MainGame();
  runApp(
    // Wrapping in MaterialApp ensures your UI/UX implementations have the proper styling context
    MaterialApp(
      home: Scaffold(body: GameWidget(game: game)),
    ),
  );
}
