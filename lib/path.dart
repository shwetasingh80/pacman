import 'package:flutter/material.dart';

class MyPath extends StatelessWidget {

  final innerColor;
  final outerColor;
  final child;
  const MyPath({super.key, this.innerColor,this.outerColor, this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(6),
      child: Container(
          margin: EdgeInsets.all(1.0),
          padding: EdgeInsets.all(12),
          color: outerColor,
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Container(
              color: innerColor,
              alignment: Alignment.center,
              child: child,
            ),
          )
      ),
    );
  }
}
