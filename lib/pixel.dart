import 'package:flutter/material.dart';
import 'package:pacman/generated/assets.dart';

class MyPixel extends StatelessWidget {
  final child;

  MyPixel({this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(Assets.assetsBlueTile))
            ),
          // color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
