import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:tinh/const/animated_button.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/screens/home_screen/home_screen.dart';
import 'package:tinh/screens/login/components/rounded_input.dart';
import 'package:tinh/screens/login/components/rounded_password_input.dart';
import 'package:tinh/services/user/user_services.dart';
import 'package:tinh/store/main/main_store.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.mainStore,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);
  final MainStore mainStore;
  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _onLogin() {
    Future.delayed(Duration.zero, () async {
      if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
        AwesomeDialog(
            btnOkColor: ColorsConts.primaryColor,
            btnOkOnPress: () {},
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.SCALE,
            body: Container(
              margin: EdgeInsets.all(10),
              child: Text(
                'សូមបំពេញរាល់ពត៍មានទាំងអស់',
                style: TextStyle(fontSize: 20),
              ),
            ))
          ..show();
      } else {
        Map<String, dynamic> postData = {
          'phone': _phoneController.text,
          'password': _passwordController.text,
        };
        Future.delayed(Duration.zero, () async {
          await userServices.login(postData, widget.mainStore).then((value) {
            if (widget.mainStore.userServiceStore.isMessage) {
              AwesomeDialog(
                  btnOkColor: value.status == '500' ? Colors.red : ColorsConts.primaryColor,
                  btnOkOnPress: () {},
                  context: context,
                  dialogType: value.status == '500' ? DialogType.ERROR : DialogType.WARNING,
                  animType: AnimType.SCALE,
                  body: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      value.message,
                      style: TextStyle(fontSize: 16),
                    ),
                  ))
                ..show();
            } else {
              NavigationHelper.pushReplacement(context, HomeScreen(widget.mainStore));
            }
          });
        });
      }
    }).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AnimatedOpacity(
        opacity: widget.isLogin ? 1.0 : 0.0,
        duration: widget.animationDuration * 4,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: widget.size.width,
            height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'សូមស្វាគមន៍',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    // child: Image.asset('assets/images/shooping-img.png'),
                    child: Lottie.asset('assets/lottie/login-lottie.json'),
                  ),
                  RoundedInput(
                    isPhoneInput: true,
                    icon: Icons.phone,
                    hint: 'លេខទូរស័ព្ទ',
                    textEditingController: _phoneController,
                  ),
                  RoundedPasswordInput(
                    hint: 'ពាក្យសម្ងាត់',
                    controller: _passwordController,
                  ),
                  SizedBox(height: 10),
                  CustomeAnimatedButton(
                    isShowShadow: true,
                    backgroundColor: ColorsConts.primaryColor,
                    width: MediaQuery.of(context).size.width * .8,
                    hegith: 55,
                    title: 'ចូល',
                    onTap: _onLogin,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
