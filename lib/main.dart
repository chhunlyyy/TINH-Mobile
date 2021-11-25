import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tinh/screens/login/login_screen/login.dart';

import 'package:tinh/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:tinh/store/main/main_store.dart';

void main() {
  runApp(TinhApp());
}

class TinhApp extends StatelessWidget {
  const TinhApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MainStore>(create: (_) => MainStore()),
      ],
      child: Observer(
        builder: (_) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
