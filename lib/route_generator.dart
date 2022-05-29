import 'package:flutter/material.dart';
import 'package:music_player_example/transitions/size_route.dart';
import 'package:music_player_example/transitions/slide_route.dart';
import 'package:music_player_example/views/auth/login_view.dart';
import 'package:music_player_example/views/launcher_view.dart';
import 'package:music_player_example/views/main/music_player_view.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LauncherPage());
      case '/login':
        return SizeRoute(page: LoginPage());
      case '/musicplayer':
        return SlideUpRoute(page: MusicPlayerPage());
      default:
        return _errorRoute();
    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text('Page not found')),
      );
    });
  }
}
