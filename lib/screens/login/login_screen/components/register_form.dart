import 'package:flutter/material.dart';
import 'package:tinh/const/animated_button.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/screens/login/components/rounded_button.dart';
import 'package:tinh/screens/login/components/rounded_input.dart';
import 'package:tinh/screens/login/components/rounded_password_input.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 0.0 : 1.0,
      duration: animationDuration * 5,
      child: Visibility(
        visible: !isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'បង្កើតគណនីថ្មី',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.asset('assets/images/shooping2.png'),
                  ),
                  RoundedInput(icon: Icons.phone, hint: 'លេខទូរស័ព្ទ'),
                  RoundedInput(icon: Icons.face_rounded, hint: 'ឈ្មោះ'),
                  RoundedPasswordInput(hint: 'ពាក្យសម្ងាត់'),
                  SizedBox(height: 10),
                  AnimatedButton(
                    isShowShadow: true,
                    backgroundColor: ColorsConts.primaryColor,
                    width: MediaQuery.of(context).size.width * .8,
                    hegith: 55,
                    title: 'បង្កើតគណនី',
                    onTap: () {},
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
