import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/screens/home_screen/components/product_item.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/screens/product/components/product_item.dart' as nonPhone;

class DiscountScreen extends StatefulWidget {
  final String title;
  const DiscountScreen({Key? key, required this.title}) : super(key: key);

  @override
  _DiscountScreenState createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  MainStore _mainStore = MainStore();

  int _pageSize = 6;
  int _pageIndex = 0;
  int selectedIndex = 0;

  Future<void> _loadData(int index, bool isLoadMore) async {
    _pageSize = 6;
    _pageIndex = isLoadMore ? _pageIndex + _pageSize : 0;
    if (index == 0) {
      if (!isLoadMore) {
        _mainStore.phoneProductStore.phoneProductModelList.clear();
      }
      await _mainStore.phoneProductStore.getDiscountPhone(pageSize: _pageSize, pageIndex: _pageIndex);
    } else {
      if (!isLoadMore) {
        _mainStore.productStore.productModelList.clear();
      }
      await _mainStore.productStore.getDiscountProduct(pageSize: _pageSize, pageIndex: _pageIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    _mainStore.phoneProductStore.getDiscountPhone(pageSize: _pageSize, pageIndex: _pageIndex);
  }

  @override
  void dispose() {
    super.dispose();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Material(
        child: SafeArea(
          child: _buildBody(),
        ),
      );
    });
  }

  Widget _buildBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          _titleWidget(),
          Expanded(child: _contentWidget()),
        ],
      ),
    );
  }

  Widget _contentWidget() {
    return EasyRefresh(
      header: BallPulseHeader(color: ColorsConts.primaryColor),
      onRefresh: () async {
        await _loadData(selectedIndex, false);
      },
      onLoad: () async {
        await _loadData(selectedIndex, true);
      },
      child: selectedIndex == 0 ? _phoneProductWidget() : _productWidget(),
    );
  }

  Widget _productWidget() {
    Widget content = WidgetHelper.loadingWidget(context, MediaQuery.of(context).size.height / 1.3);
    if (!_mainStore.productStore.isLoading) {
      content = _mainStore.productStore.productModelList.isEmpty
          ? WidgetHelper.noDataFound()
          : GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.all(1.0),
              childAspectRatio: 8 / 12.0,
              children: List<Widget>.generate(_mainStore.productStore.productModelList.length, (index) {
                return GridTile(
                    child: WidgetHelper.animation(
                        index,
                        nonPhone.ProductItem(
                          mainStore: _mainStore,
                          productModel: _mainStore.productStore.productModelList[index],
                        )));
              }));
    }
    return content;
  }

  Widget _phoneProductWidget() {
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
                return GridTile(child: WidgetHelper.animation(index, ProductItem(mainStore: _mainStore, productModel: _mainStore.phoneProductStore.phoneProductModelList[index])));
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
                  widget.title,
                  style: TextStyle(color: ColorsConts.primaryColor, fontSize: 20),
                )),
              ))
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              _categoryItem('ទូរស័ព្ទដៃ', 0),
              _categoryItem('ទំនិញផ្សេងៗ', 1),
            ],
          )
        ],
      ),
    );
  }

  Widget _categoryItem(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
          _loadData(index, false);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            style: TextStyle(color: selectedIndex == index ? ColorsConts.primaryColor : Colors.grey),
          ),
          SizedBox(height: 5),
          Container(width: MediaQuery.of(context).size.width / 2, height: 1, color: selectedIndex == index ? ColorsConts.primaryColor : Colors.white)
        ],
      ),
    );
  }
}
