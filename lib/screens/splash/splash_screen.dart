import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinh/screens/login/login_screen/login.dart';
import 'package:tinh/services/user/user_services.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigate(BuildContext context) {
      Future.delayed(Duration(seconds: 2)).whenComplete(() async {
        await DeviceInfoHelper.getDivceId().then((token) async {
          await userServices.checkUserToken(token).then((value) {
            if (value == '200') {
              NavigationHelper.pushReplacement(context, HomeScreen());
            } else {
              NavigationHelper.pushReplacement(context, LoginScreen());
            }
          });
        });
      });
    }

    navigate(context);
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
  }
}
