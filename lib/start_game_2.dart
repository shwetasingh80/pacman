
import 'package:flutter/material.dart';
import 'package:pacman/utils/routes/routes_name.dart';
import 'generated/assets.dart';
import 'main.dart';

class StartGame2Screen extends StatefulWidget {
  const StartGame2Screen({super.key});

  @override
  State<StartGame2Screen> createState() => _StartGame2ScreenState();
}

class _StartGame2ScreenState extends State<StartGame2Screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff131827),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height:height * 0.5,
              width: height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.assetsStartGameImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesName.homeScreen);
              },
              child: Container(
                height:height * 0.035,
                width: height * 0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.assetsPressEnterText),
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
