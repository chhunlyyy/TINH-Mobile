import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tinh/const/animated_button.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/screens/login/components/rounded_input.dart';
import 'package:tinh/screens/login/components/rounded_password_input.dart';
import 'package:tinh/screens/login/login_screen/login.dart';
import 'package:tinh/services/user/user_services.dart';
import 'package:tinh/store/main/main_store.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.mainStore,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  final MainStore mainStore;

  @override
  Widget build(BuildContext context) {
    //
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    //
    void _onRegister() {
      Future.delayed(Duration.zero, () async {
        await DeviceInfoHelper.getDivceId().then((token) {
          if (_phoneController.text.isEmpty || _nameController.text.isEmpty || _passwordController.text.isEmpty) {
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
              'name': _nameController.text,
              'phone': _phoneController.text,
              'password': _passwordController.text,
              'token': token,
              'isLogIn': '1',
            };
            Future.delayed(Duration.zero, () async {
              await userServices.registerAccount(postData).then((value) {
                if (value.status != '200') {
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
                          style: TextStyle(fontSize: 20),
                        ),
                      ))
                    ..show();
                } else {
                  AwesomeDialog(
                      dismissOnTouchOutside: false,
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.SCALE,
                      body: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          value.message,
                          style: TextStyle(fontSize: 20),
                        ),
                      ))
                    ..show();
                  Future.delayed(Duration(seconds: 3)).whenComplete(() {
                    NavigationHelper.pushReplacement(context, LoginScreen(mainStore));
                  });
                }
              });
            });
          }
        });
      }).whenComplete(() {});
    }

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
                    // child: Image.asset('assets/images/shooping2.png'),
                    child: Lottie.asset('assets/lottie/register-lottie.json'),
                  ),
                  RoundedInput(
                    isPhoneInput: true,
                    icon: Icons.phone,
                    hint: 'លេខទូរស័ព្ទ',
                    textEditingController: _phoneController,
                  ),
                  RoundedInput(isPhoneInput: false, icon: Icons.face_rounded, hint: 'ឈ្មោះ', textEditingController: _nameController),
                  RoundedPasswordInput(hint: 'ពាក្យសម្ងាត់', controller: _passwordController),
                  SizedBox(height: 10),
                  CustomeAnimatedButton(
                    isShowShadow: true,
                    backgroundColor: ColorsConts.primaryColor,
                    width: MediaQuery.of(context).size.width * .8,
                    hegith: 55,
                    title: 'បង្កើតគណនី',
                    onTap: _onRegister,
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
