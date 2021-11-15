import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinh/const/colors_conts.dart';

class WidgetHelper {
  static Widget loadingWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
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
        ),
      ),
    );
  }

  static Widget animation(int index, Widget child) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        verticalOffset: 100.0,
        child: FadeInAnimation(child: child),
      ),
    );
  }

  static Widget appBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: ColorsConts.primaryColor,
                        ),
                      ),
                    ),
                  ),
                )),
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.1), shape: BoxShape.circle),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
