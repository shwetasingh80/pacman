
import 'package:flutter/material.dart';
import 'package:pacman/utils/routes/routes_name.dart';
import 'generated/assets.dart';
import 'main.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.pushReplacementNamed(context, RoutesName.drawer3DScreen);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff131827),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height:height * 0.15,
              width: height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.assetsPackmanText),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesName.startGame2Screen);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: height*0.02),
                height:height * 0.08,
                width: height * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.assetsPressStartText),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
