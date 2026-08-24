import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HealtOverlay extends StatelessWidget {
  final ValueNotifier<int> healthValue;
  const HealtOverlay({super.key, required this.healthValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ValueListenableBuilder<int>(
          valueListenable: healthValue,
          builder: (context, value, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.health_and_safety,
                  size: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                )
              ],
            );
          }),
    );
  }
}
