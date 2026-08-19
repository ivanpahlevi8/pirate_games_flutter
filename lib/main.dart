import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pirate_action/component/overlays/coin_collected_overlay.dart';
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
        backgroundBuilder: (context) {
          return Column(
            // 👈 Stacks items from top to bottom
            children: [
              // 1. THE REPEATING TOP SECTION
              Container(
                // 💡 Change this number to however many pixels you want to "drag down"
                height: 32,
                width: double.infinity, // Stretch horizontally
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    // Replace with your top image name
                    image: AssetImage(
                        'assets/images/Treasure Hunters/Palm Tree Island/Sprites/Background/Additional Sky.png'),
                    repeat:
                        ImageRepeat.repeatX, // 👈 Tiles the image horizontally
                  ),
                ),
              ),

              Container(
                // 💡 Change this number to however many pixels you want to "drag down"
                height: 32,
                width: double.infinity, // Stretch horizontally
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    // Replace with your top image name
                    image: AssetImage(
                        'assets/images/Treasure Hunters/Palm Tree Island/Sprites/Background/Additional Sky.png'),
                    repeat:
                        ImageRepeat.repeatX, // 👈 Tiles the image horizontally
                  ),
                ),
              ),

              Container(
                // 💡 Change this number to however many pixels you want to "drag down"
                height: 32,
                width: double.infinity, // Stretch horizontally
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    // Replace with your top image name
                    image: AssetImage(
                        'assets/images/Treasure Hunters/Palm Tree Island/Sprites/Background/Additional Sky.png'),
                    repeat:
                        ImageRepeat.repeatX, // 👈 Tiles the image horizontally
                  ),
                ),
              ),

              // 2. THE STRETCHED BOTTOM SECTION
              Expanded(
                  // 👈 Automatically fills the remaining screen space below!
                  child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/Treasure Hunters/Palm Tree Island/Sprites/Background/BG Image.png'),
                    // 💡 Change this line to stretch the image!
                    fit: BoxFit.cover,
                  ),
                ),
              )),
            ],
          );
        },
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
