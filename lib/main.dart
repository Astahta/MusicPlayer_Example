import 'package:flutter/material.dart';
import 'package:music_player_example/route_generator.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      title: 'MediaPlayer',
      theme: ThemeData(
        // This is the theme of your application.
        fontFamily: 'NeoSans',
        primaryColor: BasePalette.primary,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
    );
  }
}

