import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/screens/about_us/about_us_screen.dart';
import 'package:tinh/screens/add_phone_form/add_phone_form_screen.dart';
import 'package:tinh/screens/add_product_form/add_product_form_screen.dart';
import 'package:tinh/screens/login/login_screen/login.dart';
import 'package:tinh/screens/logout/logout_screen.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/const/user_status.dart';

class DrawerMenuScreen extends StatelessWidget {
  final MainStore mainStore;
  const DrawerMenuScreen({Key? key, required this.mainStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: ColorsConts.primaryColor,
      child: Column(
        children: [
          isShopOwner
              ? _drawerItem(
                  context,
                  'បន្ថែមទូរស័ព្ទ',
                  Icons.add,
                  () => NavigationHelper.push(
                      context,
                      AddPhoneFormScreen(
                        onDispose: () {},
                        mainStore: mainStore,
                        phoneProductModel: null,
                      )))
              : SizedBox.shrink(),
          isShopOwner
              ? _drawerItem(
                  context,
                  'បន្ថែមផលិតផលផ្សេងៗ',
                  Icons.add,
                  () => NavigationHelper.push(
                      context,
                      AddProductFormScreen(
                        onDispose: () {},
                        mainStore: mainStore,
                        productModel: null,
                      )))
              : SizedBox.shrink(),
          _drawerItem(context, 'អំពីយើង', Icons.person_pin_circle_rounded, () => NavigationHelper.push(context, AboutUsScreen())),
          !isShopOwner
              ? _drawerItem(context, 'ចូល', Icons.login, () => NavigationHelper.push(context, LoginScreen(mainStore)))
              : _drawerItem(context, 'ចាកចេញ', Icons.logout, () => NavigationHelper.push(context, LogOutScreen(mainStore: mainStore))),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String text, IconData iconData, Function onTap) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.withOpacity(.5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
