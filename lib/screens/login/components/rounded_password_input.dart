import 'package:flutter/material.dart';
import 'package:tinh/screens/login/components/input_container.dart';
import 'package:tinh/screens/login/constants.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({Key? key, required this.hint, required this.controller}) : super(key: key);

  final String hint;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      controller: controller,
      cursorColor: kPrimaryColor,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock, color: kPrimaryColor),
        hintText: hint,
        border: InputBorder.none,
      ),
    ));
  }
}
