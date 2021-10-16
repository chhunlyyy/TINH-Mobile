import 'package:TINH_Mobile/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TinhApp());
}

class TinhApp extends StatelessWidget {
  const TinhApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
