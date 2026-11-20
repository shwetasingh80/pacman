import 'package:flutter/material.dart';
import 'package:pacman/utils/routes/routes_name.dart';

import '../../home_page.dart';
import '../../spalsh_screen.dart';
import '../../start_game_2.dart';
import '../../start_game_screen.dart';

class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splashScreen:
        return (context) => const SplashScreen();
      case RoutesName.startGameScreen:
        return (context) => const StartGameScreen();
      case RoutesName.startGame2Screen:
        return (context) => const StartGame2Screen();
      case RoutesName.homeScreen:
        return (context) => const HomePage();
      default:
        return (context) => const Scaffold(
          body: Center(
            child: Text(
              'No Route Found!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        );
    }
  }
}
