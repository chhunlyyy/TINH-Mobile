import 'package:flutter/material.dart';
import 'package:tinh/screens/login/components/input_container.dart';
import 'package:tinh/screens/login/constants.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({Key? key, required this.isPhoneInput, required this.icon, required this.hint, required this.textEditingController}) : super(key: key);
  final bool isPhoneInput;
  final IconData icon;
  final String hint;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      controller: textEditingController,
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        icon: Icon(icon, color: kPrimaryColor),
        hintText: hint,
        border: InputBorder.none,
      ),
    ));
  }
}
