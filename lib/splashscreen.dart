import 'package:flutter/material.dart';
import 'dart:async';
import 'loginscreen.dart';
 
class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(
      const Duration(seconds:3),
      () => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const LoginScreen())
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(50),
                child: Image.asset('assets/images/EAS.png'))
            ],
          ),
        ),
    );
  }
}