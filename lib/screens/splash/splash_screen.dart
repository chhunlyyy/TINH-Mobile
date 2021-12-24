import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinh/services/user/user_services.dart';

import 'package:tinh/store/main/main_store.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainStore _mainStore = MainStore();

    Future<void> checkUserLogin() async {
      await DeviceInfoHelper.getDivceId().then((token) async {
        await userServices.checkUserToken(token, _mainStore).then((value) {
          if (value == '200') {
            _mainStore.userStore.changeUserStatus(true);
          } else {
            _mainStore.userStore.changeUserStatus(false);
          }
        });
      });
    }

    void navigate(BuildContext context) {
      Future.delayed(Duration(seconds: 2)).whenComplete(() async {
        await checkUserLogin();
        NavigationHelper.pushReplacement(context, HomeScreen(_mainStore));
      });
    }

    navigate(context);
    return Observer(builder: (_) {
      return Scaffold(
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: ColorsConts.primaryColor,
            child: SingleChildScrollView(
              child: AnimationLimiter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => ScaleAnimation(
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
