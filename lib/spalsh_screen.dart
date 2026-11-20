import 'package:flutter/material.dart';
import 'package:pacman/utils/routes/routes_name.dart';
import 'generated/assets.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutesName.startGameScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff131827),
      body: Center(
        child: Container(
          height:width * 0.25,
          width: width * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.assetsPackman),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
