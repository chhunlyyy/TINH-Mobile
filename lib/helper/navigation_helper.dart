import 'package:flutter/material.dart';

class NavigationHelper {
  static push(BuildContext context, Widget widget) {
    Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 50),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return widget;
        }));
  }
}
