import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'package:tinh/screens/login/constants.dart';
import 'package:tinh/store/main/main_store.dart';

import 'components/cancel_button.dart';
import 'components/login_form.dart';
import 'components/register_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    animationController = AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context).viewInsets.bottom; // we are using this to determine Keyboard is opened or not
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);
    MainStore _mainStore = MainStore();
    containerSize = Tween<double>(begin: size.height * 0.1, end: defaultRegisterSize).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Observer(builder: (_) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // Lets add some decorations
                Positioned(
                    top: 100,
                    right: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: kPrimaryColor),
                    )),

                Positioned(
                    top: -50,
                    left: -50,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: kPrimaryColor),
                    )),

                // Cancel Button

                Visibility(
                  visible: !isLogin,
                  child: CancelButton(
                    isLogin: isLogin,
                    animationDuration: animationDuration,
                    size: size,
                    animationController: animationController,
                    tapEvent: isLogin
                        ? () {}
                        : () {
                            // returning null to disable the button
                            animationController.reverse();
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                  ),
                ),

                // Login Form
                LoginForm(mainStore: _mainStore, isLogin: isLogin, animationDuration: animationDuration, size: size, defaultLoginSize: defaultLoginSize),

                // Register Container
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    if (viewInset == 0 && isLogin) {
                      return buildRegisterContainer();
                    } else if (!isLogin) {
                      return buildRegisterContainer();
                    }

                    // Returning empty container to hide the widget
                    return Container();
                  },
                ),

                // Register Form
                RegisterForm(isLogin: isLogin, animationDuration: animationDuration, size: size, defaultLoginSize: defaultRegisterSize),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: kBackgroundColor),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();

                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? Text(
                  "មិនទាន់មានគណនីមែនទេ? ចុចទីនេះ",
                  style: TextStyle(color: kPrimaryColor, fontSize: 18),
                )
              : null,
        ),
      ),
    );
  }
}
