import 'package:flutter/material.dart';

import 'generated/assets.dart';

class MyGhost2 extends StatelessWidget {
  const MyGhost2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Image.asset(Assets.assetsGhost2),
    );
  }
}
