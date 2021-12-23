import 'package:flutter/material.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/screens/login/login_screen/login.dart';
import 'package:tinh/store/main/main_store.dart';

class DrawerMenuScreen extends StatelessWidget {
  final MainStore mainStore;
  const DrawerMenuScreen({Key? key, required this.mainStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: ColorsConts.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _drawerItem(context, 'អំពីយើង', Icons.person_pin_circle_rounded, () {}),
          SizedBox(height: 20),
          !mainStore.isShopOwner ? _drawerItem(context, 'ចូល', Icons.login, () => NavigationHelper.push(context, LoginScreen(mainStore))) : _drawerItem(context, 'ចាកចេញ', Icons.logout, () {}),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String text, IconData iconData, Function onTap) {
    return Container(
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
                  size: 45,
                ),
                SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
