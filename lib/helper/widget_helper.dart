import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:tinh/const/colors_conts.dart';

class WidgetHelper {
  static Widget item({required BuildContext context, required IconData icon, required Color color, required String fileName, required String label, double iconSize = 18, double fontSize = 12}) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: iconSize,
          color: color,
        ),
        SizedBox(width: 8),
        //Expanded(child: Text(fileName ?? label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: fontSize),)),
        Expanded(
            child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color, fontSize: fontSize),
        )),
      ],
    );
  }

  static Widget drawer({required BuildContext context, required Widget menuScreen, required Widget mainScreen, required ZoomDrawerController controller}) {
    return ZoomDrawer(
        backgroundColor: Colors.white54,
        showShadow: true,
        borderRadius: 24,
        angle: -10,
        slideWidth: MediaQuery.of(context).size.width * .65,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
        style: DrawerStyle.Style1,
        controller: controller,
        menuScreen: menuScreen,
        mainScreen: mainScreen);
  }

  static Widget loadingWidget(BuildContext context, double height) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
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
        delay: Duration(milliseconds: 80),
        duration: Duration(milliseconds: 500),
        verticalOffset: 100.0,
        child: FadeInAnimation(child: child),
      ),
    );
  }

  static Widget appBar(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
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
          Expanded(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Text(title, style: TextStyle(color: ColorsConts.primaryColor, fontSize: 22)),
            ),
          )),
        ],
      ),
    );
  }

  static Widget noDataFound() {
    return Center(
      child: Column(
        children: [
          Lottie.asset('assets/lottie/data-not-found.json'),
          Text('រកមិនឃើញទិន្នន័យ', style: TextStyle(color: Colors.red, fontSize: 24)),
        ],
      ),
    );
  }

  static Widget gridView({required BuildContext context, required List<Widget> children, double cellHeight = 300, int crossAxisCount = 2, int crossAxisCountForBigScreen = 3}) {
    var _crossAxisSpacing = 10;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = _screenWidth > 440 ? crossAxisCountForBigScreen : crossAxisCount;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var _aspectRatio = _width / cellHeight;
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: _crossAxisCount,
      mainAxisSpacing: 10,
      padding: EdgeInsets.all(1.0),
      childAspectRatio: _aspectRatio,
      children: children,
    );
  }
}
