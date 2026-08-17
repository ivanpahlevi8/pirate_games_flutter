import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pirate_action/component/overlays/collected_items_overlay.dart';

class DiamondCollectedOverlay extends StatelessWidget {
  final ValueNotifier<int> blueDiamondScore;
  final ValueNotifier<int> redDiamondScore;
  final ValueNotifier<int> greenDiamondScore;
  const DiamondCollectedOverlay(
      {super.key,
      required this.blueDiamondScore,
      required this.redDiamondScore,
      required this.greenDiamondScore});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // items for blue diamond
            CollectedItemsOverlay(
                score: blueDiamondScore,
                pathToImage:
                    "assets/images/Treasure Hunters/Pirate Treasure/Sprites/Blue Diamond/01.png"),
            SizedBox(
              width: 4,
            ),
            VerticalDivider(
              width: 1.5,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            // items for red diamond
            CollectedItemsOverlay(
                score: redDiamondScore,
                pathToImage:
                    "assets/images/Treasure Hunters/Pirate Treasure/Sprites/Red Diamond/01.png"),
            SizedBox(
              width: 4,
            ),
            VerticalDivider(
              width: 1.5,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            // items for green diamond
            CollectedItemsOverlay(
                score: greenDiamondScore,
                pathToImage:
                    "assets/images/Treasure Hunters/Pirate Treasure/Sprites/Green Diamond/01.png"),
          ],
        ),
      ),
    );
  }
}
