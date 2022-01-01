import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/screens/home_screen/home_screen.dart';
import 'package:tinh/services/user/user_services.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/const/user_status.dart';

class LogOutScreen extends StatefulWidget {
  final MainStore mainStore;
  const LogOutScreen({Key? key, required this.mainStore}) : super(key: key);

  @override
  State<LogOutScreen> createState() => _LogOutScreenState();
}

class _LogOutScreenState extends State<LogOutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).whenComplete(() {
      AwesomeDialog(
          dismissOnTouchOutside: false,
          context: context,
          dialogType: DialogType.WARNING,
          borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
          width: MediaQuery.of(context).size.width,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
          headerAnimationLoop: false,
          animType: AnimType.BOTTOMSLIDE,
          desc: 'មុខងាររបស់កម្មវិធីនេះនិងដូចទៅនឹងមុខងាររបស់កម្មវិធីអតិថិជនពេលអ្នកចាកចេញ !! \nតើអ្នកពិតជាចង់ចាកចេញមែនទេ ?',
          showCloseIcon: false,
          btnCancelOnPress: () {
            Navigator.pop(context);
          },
          btnOkOnPress: () {
            Future.delayed(Duration.zero, () async {
              Map<String, dynamic> postData = {
                'token': await DeviceInfoHelper.getDivceId(),
              };
              await userServices.logOut(postData).then((value) {
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
                          style: TextStyle(fontSize: 16),
                        ),
                      ))
                    ..show();
                } else {
                  isShopOwner = false;
                  NavigationHelper.pushReplacement(context, HomeScreen(widget.mainStore));
                }
              });
            });
          })
        ..show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
