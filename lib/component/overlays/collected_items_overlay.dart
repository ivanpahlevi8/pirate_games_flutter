import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CollectedItemsOverlay extends StatelessWidget {
  final ValueNotifier<int> score;
  final String pathToImage;
  const CollectedItemsOverlay(
      {super.key, required this.score, required this.pathToImage});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: score,
        builder: (context, currentScore, child) {
          // draw Row with text and input
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                score.value.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
              Image.asset(
                pathToImage,
                height: 56,
                width: 56,
              )
            ],
          );
        });
  }
}
