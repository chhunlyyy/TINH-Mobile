import 'package:flutter/material.dart';
import 'package:tinh/screens/login/components/rounded_button.dart';
import 'package:tinh/screens/login/components/rounded_input.dart';
import 'package:tinh/screens/login/components/rounded_password_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
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
      opacity: isLogin ? 1.0 : 0.0,
      duration: animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: size.width,
          height: defaultLoginSize,
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
                  child: Image.asset('assets/images/shooping-img.png'),
                ),
                RoundedInput(icon: Icons.phone, hint: 'លេខទូរស័ព្ទ'),
                RoundedPasswordInput(hint: 'ពាក្យសម្ងាត់'),
                SizedBox(height: 10),
                RoundedButton(title: 'ចូល'),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
