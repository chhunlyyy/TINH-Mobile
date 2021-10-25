import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinh/const/colors_conts.dart';

class WidgetHelper {
  static Widget loadingWidget() {
    return Container(
      width: 100,
      height: 100,
      child: Column(
        children: [
          SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? ColorsConts.primaryColor : Colors.green,
                ),
              );
            },
          ),
          SizedBox(height: 10),
          Text(
            'សូមរងចាំ',
            style: TextStyle(color: ColorsConts.primaryColor, fontSize: 18),
          )
        ],
      ),
    );
  }

  static Widget animation(int index, Widget child) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}
