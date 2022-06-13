import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //theme: CustomTheme.lighttheme,
        title: 'Material App',
        home: Builder(builder: (context) {
          return const SplashScreen();
        }));
  }
}
