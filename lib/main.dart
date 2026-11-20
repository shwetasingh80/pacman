import 'package:flutter/material.dart';
import 'package:pacman/utils/routes/routes.dart';
import 'package:pacman/utils/routes/routes_name.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}
double height = 0;
double width = 0;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: RoutesName.splashScreen,
      onGenerateRoute: (settings) {
        if (settings.name != null) {
          return MaterialPageRoute(
            builder: Routers.generateRoute(settings.name!),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

