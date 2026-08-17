import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pirate_action/component/overlays/coin_collected_overlay.dart';
import 'package:pirate_action/component/overlays/collected_items_overlay.dart';
import 'package:pirate_action/component/overlays/diamond_collected_overlay.dart';
import 'package:pirate_action/main_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  MainGame game = MainGame();
  runApp(
    // Wrapping in MaterialApp ensures your UI/UX implementations have the proper styling context
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: GameWidget(
        game: game,
        overlayBuilderMap: {
          "Diamond": (BuildContext context, MainGame game) {
            return SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: DiamondCollectedOverlay(
                  blueDiamondScore: game.collectedBlueDiamond,
                  redDiamondScore: game.collectedRedDiamond,
                  greenDiamondScore: game.collectedGreenDiamond,
                ),
              ),
            );
          },
          "Coin": (BuildContext context, MainGame game) {
            return SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: CoinCollectedOverlay(
                  collectedGold: game.collectedGoldCoin,
                  collectedSilver: game.collectedSilverCoin,
                ),
              ),
            );
          },
        },
        initialActiveOverlays: const ["Diamond", "Coin"],
      )),
    ),
  );
}
