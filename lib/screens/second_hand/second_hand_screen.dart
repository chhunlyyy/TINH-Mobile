import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/phone_category/phone_category_model.dart';
import 'package:tinh/screens/home_screen/components/product_item.dart';
import 'package:tinh/store/main/main_store.dart';

class SecondHandScreen extends StatefulWidget {
  const SecondHandScreen({Key? key}) : super(key: key);

  @override
  _SecondHandScreenState createState() => _SecondHandScreenState();
}

class _SecondHandScreenState extends State<SecondHandScreen> {
  MainStore _mainStore = MainStore();
  int categoryIndex = 0;

  int _pageSize = 6;
  int _pageIndex = 0;

  Future<void> _loadPhone() async {
    if (categoryIndex == 0) {
      await _mainStore.phoneProductStore.loadData(pageSize: _pageSize, pageIndex: _pageIndex, isNew: 0);
    } else {
      await _mainStore.phoneProductStore.loadPhoneByCategory(
        isNew: 0,
        pageSize: _pageSize,
        pageIndex: _pageIndex,
        brandId: 2,
        categoryId: categoryIndex,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPhone();
    _mainStore.phoneCategoryStore.loadData().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Material(
          child: SafeArea(
            child: _buildBody(),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Observer(builder: (_) {
      return Column(
        children: [
          _titleWidget(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: EasyRefresh(
                header: BallPulseHeader(color: ColorsConts.primaryColor),
                onLoad: () async {
                  _pageIndex = _pageIndex + _pageSize;
                  await _loadPhone();
                },
                onRefresh: () {
                  _mainStore.phoneProductStore.phoneProductModelList.clear();
                  _pageIndex = 0;
                  _pageSize = 6;
                  return _loadPhone();
                },
                child: Column(
                  children: [
                    _productWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _productWidget() {
    Widget content = WidgetHelper.loadingWidget(context, MediaQuery.of(context).size.height);

    if (!_mainStore.phoneProductStore.isLoading) {
      content = _mainStore.phoneProductStore.phoneProductModelList.isNotEmpty
          ? GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.all(1.0),
              childAspectRatio: 8 / 12.0,
              children: List<Widget>.generate(_mainStore.phoneProductStore.phoneProductModelList.length, (index) {
                return GridTile(
                    child: WidgetHelper.animation(
                        index,
                        ProductItem(
                            onDispose: () {
                              _mainStore.phoneProductStore.phoneProductModelList.clear();
                              _pageIndex = 0;
                              _pageSize = 6;
                              _loadPhone();
                            },
                            mainStore: _mainStore,
                            productModel: _mainStore.phoneProductStore.phoneProductModelList[index])));
              }))
          : WidgetHelper.noDataFound();
    }

    return content;
  }

  Widget _titleWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.4),
          blurRadius: 2,
          spreadRadius: 2,
          offset: Offset(0, 1),
        )
      ]),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
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
                  child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Center(
                  child: Text(
                    'ទំនិញមួយទឹក',
                    style: TextStyle(color: ColorsConts.primaryColor, fontSize: 22),
                  ),
                ),
              ))
            ],
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _mainStore.phoneCategoryStore.phoneCategoryModelList.map((e) {
                return _categoryItem(e, _mainStore.phoneCategoryStore.phoneCategoryModelList.length);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryItem(PhoneCategoryModel phoneCategoryModel, int size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _pageSize = 6;
            _pageIndex = 0;
            categoryIndex = phoneCategoryModel.id;
            _mainStore.phoneProductStore.phoneProductModelList.clear();
            _loadPhone();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              phoneCategoryModel.name,
              style: TextStyle(color: categoryIndex == phoneCategoryModel.id ? ColorsConts.primaryColor : Colors.grey),
            ),
            SizedBox(height: 5),
            Container(width: MediaQuery.of(context).size.width / size, height: 1, color: categoryIndex == phoneCategoryModel.id ? ColorsConts.primaryColor : Colors.white)
          ],
        ),
      ),
    );
  }
}
