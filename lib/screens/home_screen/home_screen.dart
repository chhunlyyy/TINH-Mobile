import 'dart:convert';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mobx/mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/const/enum.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/deparment/department_model.dart';
import 'package:tinh/services/department/department_service.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double _width;
  LoadingState _loadingState = LoadingState.LOADING;
  late double _height;
  List<DepartmentModel> _departmentmodelList = [];
  int _cartNum = 0;
  bool _isShowAllDepartent = false;

  void _getDepartment() {
    _loadingState = LoadingState.LOADING;
    Future.delayed(Duration.zero, () async {
      await departmentServices.getDepartmentModel().then((value) {
        setState(() {
          _departmentmodelList = value;
          _loadingState = LoadingState.DONE;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDepartment();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _loadingState == LoadingState.DONE
          ? SafeArea(child: _buildBody())
          : Container(
              width: _width,
              height: _height,
              child: Center(
                child: WidgetHelper.loadingWidget(),
              ),
            ),
    );
  }

  Widget _buildBody() {
    return Container(
      height: _height,
      width: _width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _searchWidget()),
                _cartWidget(),
              ],
            ),
            _departmentLabel(),
            _departmentWidget(),
          ],
        ),
      ),
    );
  }

  Widget _departmentLabel() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      width: _width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ផ្នែកផលិតផល',
              style: TextStyle(fontSize: 18),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isShowAllDepartent = !_isShowAllDepartent;
              });
            },
            child: Text(
              !_isShowAllDepartent ? 'មើលទាំងអស់' : 'បង្រួម',
              style: TextStyle(color: ColorsConts.primaryColor, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  Widget _departmentWidget() {
    List<Widget> _departmentItemList = [];

    _departmentmodelList.forEach((departmentModel) {
      _departmentItemList.add(_departmentItem(departmentModel));
    });

    return !_isShowAllDepartent
        ? Container(
            margin: EdgeInsets.only(top: 10),
            width: _width,
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _departmentItemList.map((child) {
                return WidgetHelper.animation(_departmentItemList.indexOf(child), child);
              }).toList(),
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 20, left: 5, right: 5),
            child: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              crossAxisCount: 4,
              physics: new NeverScrollableScrollPhysics(),
              children: _departmentItemList.map((child) {
                return WidgetHelper.animation(_departmentItemList.indexOf(child), child);
              }).toList(),
            ));
  }

  Widget _departmentItem(DepartmentModel departmentModel) {
    return Container(
      width: 70,
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                image: DecorationImage(image: MemoryImage(base64Decode(departmentModel.image))),
                color: Color.fromRGBO(255, 236, 223, 1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: Text(
              departmentModel.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _cartWidget() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: ColorsConts.primaryColor, width: .5), shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.7),
          blurRadius: 3,
          spreadRadius: .5,
          offset: Offset(0, 2),
        )
      ]),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, left: 8),
            child: Icon(
              FontAwesomeIcons.shoppingCart,
              size: 18,
              color: ColorsConts.primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 2),
            child: Text(
              _cartNum.toString(),
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  Widget _searchWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
      width: _width,
      height: 40,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        style: TextStyle(color: ColorsConts.primaryColor),
        cursorColor: ColorsConts.primaryColor,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: 'ស្វែងរកទំនិញ',
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              size: 26,
              color: ColorsConts.primaryColor,
            )),
      ),
    );
  }
}
