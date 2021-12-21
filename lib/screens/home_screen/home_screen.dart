import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:flutter/material.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/department/department_model.dart';
import 'package:tinh/screens/categories/categories_screen.dart';
import 'package:tinh/screens/home_screen/components/phone_brand_item.dart';
import 'package:tinh/screens/home_screen/components/product_item.dart';
import 'package:tinh/screens/second_hand/second_hand_screen.dart';
import 'package:tinh/store/main/main_store.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final MainStore mainStore;
  HomeScreen(this.mainStore);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double _width;
  late double _height;
  TextEditingController _searchController = TextEditingController();
  MainStore _mainStore = MainStore();

  ScrollController _scrollController = ScrollController();

  int _pageSize = 6;
  int _pageIndex = 0;

  void _onSearch(String text) {
    if (_searchController.text.isNotEmpty) {
      _mainStore.phoneProductStore.phoneProductModelList.clear();
      _mainStore.phoneProductStore.search(phoneName: text);
    } else {
      _mainStore.phoneProductStore.phoneProductModelList.clear();
      _mainStore.phoneProductStore.loadData(pageSize: 6, pageIndex: 0, isNew: 1);
    }
  }

  Future<void> _getData() async {
    setState(() {});
    _pageIndex = 0;
    _pageSize = 6;
    _searchController.text = '';
    _mainStore.departmentStore.departmentList.clear();
    _mainStore.phoneBrandStore.phoneBrandList.clear();
    _mainStore.phoneProductStore.phoneProductModelList.clear();
    return Future.delayed(Duration.zero, () async {
      _mainStore.phoneBrandStore.loadData();
      _mainStore.phoneProductStore.loadData(pageSize: _pageSize, pageIndex: _pageIndex, isNew: 1);
      await _mainStore.departmentStore.loadData().then((value) {
        setState(() {});
      });
    });
  }

  Future<void> _onLoad() {
    return Future.delayed(Duration.zero, () async {
      _mainStore.phoneProductStore.loadData(pageSize: _pageSize, pageIndex: _pageIndex += _pageSize, isNew: 1);
    });
  }

  @override
  void initState() {
    super.initState();
    _mainStore = widget.mainStore;

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Observer(builder: (_) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        height: _height,
        width: _width,
        child: EasyRefresh(
          header: BallPulseHeader(color: ColorsConts.primaryColor),
          onLoad: _onLoad,
          onRefresh: _getData,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _searchWidget()),
                  _searchButton(true),
                  _searchButton(false),
                ],
              ),
              _departmentLabel(),
              _departmentWidget(),
              _phoneBrandLabel(),
              _phoneBrandWidget(),
              _productLabel(),
              _productWidget(),
            ],
          ),
        ),
      );
    });
  }

  Widget departmentItem(DepartmentModel departmentModel) {
    return Text(departmentModel.name);
  }

  Widget _searchButton(bool isSearch) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: AnimatedButton(
        isFixedHeight: false,
        width: 80,
        height: 40,
        color: isSearch ? Colors.blue : Colors.deepOrange,
        pressEvent: () {
          if (isSearch) {
            if (_searchController.text.isNotEmpty && _searchController.text != ' ') {
              _onSearch(_searchController.text);
            }
          } else {
            if (_searchController.text.isNotEmpty && _searchController.text != ' ') {
              _searchController.text = '';
              _mainStore.phoneProductStore.phoneProductModelList.clear();
              _mainStore.phoneProductStore.loadData(pageSize: 6, pageIndex: 0, isNew: 1);
            }
          }
        },
        borderRadius: BorderRadius.circular(5),
        text: isSearch ? 'ស្វែងរក' : 'បោះបង់',
      ),
    );
  }

  Widget _productLabel() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      width: _width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ផលិតផលទូរស័ព្ទទាំងអស់',
              style: TextStyle(fontSize: 18),
            ),
          ),
          //
        ],
      ),
    );
  }

  Widget _departmentItem(DepartmentModel departmentModel) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: ColorsConts.primaryColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.4), offset: Offset(1, 0), spreadRadius: 1, blurRadius: 0)]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (departmentModel.id == 1) {
                NavigationHelper.push(context, SecondHandScreen());
              } else if (departmentModel.id == 2) {
                NavigationHelper.push(context, CategoriesScreen(title: departmentModel.name));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  departmentModel.name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _departmentWidget() {
    List<Widget> _departmentItemList = [];

    _mainStore.departmentStore.departmentList.forEach((departmentModel) {
      _departmentItemList.add(_departmentItem(departmentModel));
    });

    return _mainStore.departmentStore.departmentList.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(top: 10),
            height: 65,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _departmentItemList.map((child) {
                return WidgetHelper.animation(_departmentItemList.indexOf(child), child);
              }).toList(),
            ),
          )
        : Container();
  }

  Widget _departmentLabel() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      width: _width,
      child: Text(
        'ប្រភេទផលិតផល',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _phoneBrandLabel() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      width: _width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ម៉ាកផលិតផល',
              style: TextStyle(fontSize: 18),
            ),
          ),
          GestureDetector(
            onTap: () => _mainStore.phoneBrandStore.changeCategoryDisplay(),
            child: Text(
              !_mainStore.phoneBrandStore.isShowAllCategory ? 'មើលទាំងអស់' : 'បង្រួម',
              style: TextStyle(color: ColorsConts.primaryColor, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  Widget _productWidget() {
    Widget content = WidgetHelper.loadingWidget(context, MediaQuery.of(context).size.height / 3);
    if (!_mainStore.phoneProductStore.isLoading) {
      content = _mainStore.phoneProductStore.phoneProductModelList.isNotEmpty && _mainStore.phoneBrandStore.isLoading == false
          ? GridView.count(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.all(1.0),
              childAspectRatio: 8 / 12.0,
              children: List<Widget>.generate(_mainStore.phoneProductStore.phoneProductModelList.length, (index) {
                return GridTile(child: WidgetHelper.animation(index, ProductItem(mainStore: _mainStore, productModel: _mainStore.phoneProductStore.phoneProductModelList[index])));
              }))
          : WidgetHelper.noDataFound();
    }
    return content;
  }

  Widget _phoneBrandWidget() {
    List<Widget> _departmentItemList = [];

    _mainStore.phoneBrandStore.phoneBrandList.forEach((phoneBrandModel) {
      _departmentItemList.add(PhoneBrandItem(mainStore: _mainStore, phoneBrandModel: phoneBrandModel));
    });

    Widget content = Container();

    if (!_mainStore.phoneBrandStore.isLoading) {
      content = !_mainStore.phoneBrandStore.isShowAllCategory
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
    return content;
  }

  Widget _searchWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
      width: _width,
      height: 40,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: _searchController,
        style: TextStyle(color: ColorsConts.primaryColor),
        cursorColor: ColorsConts.primaryColor,
        decoration: InputDecoration(
            contentPadding: new EdgeInsets.only(top: 0),
            hintText: 'ស្វែងរក',
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
