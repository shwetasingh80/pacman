import 'package:flutter/material.dart';
import 'package:pacman/generated/assets.dart';
class MyPlayer extends StatelessWidget {
  const MyPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(Assets.assetsPackman),
    );
  }
}
