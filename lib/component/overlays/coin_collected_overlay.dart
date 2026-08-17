import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pirate_action/component/overlays/collected_items_overlay.dart';

class CoinCollectedOverlay extends StatelessWidget {
  final ValueNotifier<int> collectedGold;
  final ValueNotifier<int> collectedSilver;
  const CoinCollectedOverlay(
      {super.key, required this.collectedGold, required this.collectedSilver});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // overlay for gold coin
            CollectedItemsOverlay(
                score: collectedGold,
                pathToImage:
                    "assets/images/Treasure Hunters/Pirate Treasure/Sprites/Gold Coin/01.png"),
            SizedBox(
              width: 4,
            ),
            VerticalDivider(
              width: 1.5,
            ),
            SizedBox(
              width: 4,
            ),
            CollectedItemsOverlay(
                score: collectedSilver,
                pathToImage:
                    "assets/images/Treasure Hunters/Pirate Treasure/Sprites/Silver Coin/01.png"),
          ],
        ),
      ),
    );
  }
}
