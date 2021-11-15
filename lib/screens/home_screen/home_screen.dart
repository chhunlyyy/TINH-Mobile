import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobx/mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/category/category_model.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/screens/home_screen/components/category_item.dart';
import 'package:tinh/screens/home_screen/components/product_item.dart';
import 'package:tinh/screens/home_screen/components/search_filter_dialog.dart';
import 'package:tinh/store/main/main_store.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double _width;
  late double _height;
  TextEditingController _searchController = TextEditingController();

  List<ProductModel>? _productModelList = [];
  List<ProductModel>? _searchProductList = [];
  List<CategoryModel>? _categoryModelList = [];
  int _cartNum = 0;
  int _productPageIndex = 0;
  int _productPageSize = 5;
  int _searchPageSize = 5;
  int _searchPageIndex = 0;

  MainStore _mainStore = MainStore();

  void _onSearch(String text) {
    if (_searchController.text.isEmpty) {
      _productModelList!.clear();
      _productPageSize = 5;
      _productPageIndex = 0;
      _mainStore.productStore.loadData(pageIndex: _productPageIndex, pageSize: _productPageSize);
    } else {
      _searchPageSize = 5;
      _searchProductList!.clear();
      _mainStore.productStore.search(name: text, pageIndex: _searchPageIndex, pageSize: _searchPageSize);
    }
  }

  Future<void> _getData() async {
    _mainStore.categoryStore.loadData();

    _productModelList!.clear();
    _productPageIndex = 0;
    if (_searchController.text.isEmpty) {
      _productPageSize = 5;
      _productPageIndex = 0;
      _mainStore.productStore.loadData(pageIndex: _productPageIndex, pageSize: _productPageSize);
    } else {
      _searchPageSize = 5;
      _searchPageIndex = 0;
      _searchProductList!.clear();
      _mainStore.productStore.search(name: _searchController.text, pageIndex: _searchPageIndex, pageSize: _searchPageSize);
    }
  }

  Future<void> _onLoad() {
    if (_searchController.text.isEmpty) {
      return _mainStore.productStore.loadData(pageSize: _productPageSize, pageIndex: _productPageIndex += _productPageSize);
    } else {
      return _mainStore.productStore.search(name: _searchController.text, pageSize: _searchPageSize, pageIndex: _searchPageSize += _searchPageSize);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainStore.homeScreenStore.changeLoading();
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
    Widget body = WidgetHelper.loadingWidget(context);
    return Observer(builder: (_) {
      final observableProductFuture = _mainStore.productStore.observableFutureProduct;
      final observableCategoryFuture = _mainStore.categoryStore.observableFutureCategory;
      if (observableProductFuture != null && observableCategoryFuture != null) {
        if (observableProductFuture.value != null && observableCategoryFuture.value != null) {
          if (_searchController.text.isNotEmpty) {
            for (var item in observableProductFuture.value!) {
              if (!_searchProductList!.contains(item)) {
                _searchProductList!.add(item);
              }
            }
          } else {
            for (var item in observableProductFuture.value!) {
              _productModelList!.add(item);
            }
          }
        }

        _categoryModelList = observableCategoryFuture.value;

        if (_mainStore.homeScreenStore.isLoading) {
          body = WidgetHelper.loadingWidget(context);
        } else {
          body = Container(
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
                      _cartWidget(),
                    ],
                  ),
                  _categoryLabel(),
                  _categoryWidget(),
                  _productLabel(),
                  _productWidget(),
                ],
              ),
            ),
          );
        }
      }

      return body;
    });
  }

  Widget _productLabel() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      width: _width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ផលិតផលទាំងអស់',
              style: TextStyle(fontSize: 18),
            ),
          ),
          //
        ],
      ),
    );
  }

  Widget _categoryLabel() {
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
            onTap: () => _mainStore.categoryStore.changeCategoryDisplay(),
            child: Text(
              !_mainStore.categoryStore.isShowAllCategory ? 'មើលទាំងអស់' : 'បង្រួម',
              style: TextStyle(color: ColorsConts.primaryColor, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  Widget _productWidget() {
    return _productModelList != null
        ? GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: EdgeInsets.all(1.0),
            childAspectRatio: 8 / 12.0,
            children: _searchController.text.isEmpty
                ? List<Widget>.generate(_productModelList!.length, (index) {
                    return GridTile(child: WidgetHelper.animation(index, ProductItem(productModel: _productModelList![index])));
                  })
                : List<Widget>.generate(_searchProductList!.length, (index) {
                    return GridTile(child: WidgetHelper.animation(index, ProductItem(productModel: _searchProductList![index])));
                  }),
          )
        // Container(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: _productModelList!.map((productmodel) {
        //         return WidgetHelper.animation(_productModelList!.indexOf(productmodel), ProductItem(productModel: productmodel));
        //       }).toList(),
        //     ),
        //   )
        : Container();
  }

  Widget _categoryWidget() {
    List<Widget> _departmentItemList = [];

    _categoryModelList?.forEach((categoryModel) {
      _departmentItemList.add(CategoryItem(categoryModel: categoryModel));
    });

    return !_mainStore.categoryStore.isShowAllCategory
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
        onChanged: (String text) {
          _onSearch(text);
        },
        controller: _searchController,
        style: TextStyle(color: ColorsConts.primaryColor),
        cursorColor: ColorsConts.primaryColor,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: _mainStore.searchFilterStore.radioValue == 1 ? 'ស្វែងរកតាមឈ្មោះទំនិញ' : 'ស្វែងរកតាមប្រភេទទំនិញ',
            border: InputBorder.none,
            // suffixIcon: InkWell(
            //   onTap: () {
            //     showSearchFilterDialog(context, _mainStore);
            //   },
            //   child: Icon(
            //     Icons.filter_list_outlined,
            //     size: 26,
            //     color: ColorsConts.primaryColor,
            //   ),
            // ),
            prefixIcon: Icon(
              Icons.search,
              size: 26,
              color: ColorsConts.primaryColor,
            )),
      ),
    );
  }
}
