import 'package:flutter/material.dart';

import 'generated/assets.dart';
class MyGhost extends StatelessWidget {
  const MyGhost({super.key});
@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(Assets.assetsGhost),
    );
  }
}
