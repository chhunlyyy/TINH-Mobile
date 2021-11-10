import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/deparment/department_model.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/screens/home_screen/components/department_item.dart';
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
  List<DepartmentModel>? _departmentmodelList = [];
  List<ProductModel>? _productModelList = [];
  int _cartNum = 0;

  MainStore _mainStore = MainStore();

  Future<void> _getData() async {
    _mainStore.departmentStore.loadData();
    _mainStore.productStore.loadData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    return Observer(builder: (_) {
      Widget body = Container();
      final observableDepartmentFuture = _mainStore.departmentStore.observableDepartmentFuture;
      final observableProductFuture = _mainStore.productStore.observableFutureProduct;

      if (observableDepartmentFuture != null && observableProductFuture != null) {
        _departmentmodelList = observableDepartmentFuture.value;
        _productModelList = observableProductFuture.value;
        switch (observableDepartmentFuture.status) {
          case FutureStatus.pending:
            body = WidgetHelper.loadingWidget(context);
            break;
          case FutureStatus.fulfilled:
            {
              body = Container(
                height: _height,
                width: _width,
                child: EasyRefresh(
                  onRefresh: _getData,
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
                      _productLabel(),
                      _productWidget(),
                    ],
                  ),
                ),
              );
            }
            break;

          default:
            body = WidgetHelper.loadingWidget(context);
        }
      } else {
        body = Container();
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
          // GestureDetector(
          //   onTap: () => _departmentStore.changeDepartmentDisplay(),
          //   child: Text(
          //     !_departmentStore.isShowAllDepartment ? 'មើលទាំងអស់' : 'បង្រួម',
          //     style: TextStyle(color: ColorsConts.primaryColor, fontSize: 15),
          //   ),
          // )
        ],
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
            onTap: () => _mainStore.departmentStore.changeDepartmentDisplay(),
            child: Text(
              _mainStore.departmentStore.isShowAllDepartment ? 'មើលទាំងអស់' : 'បង្រួម',
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
            children: List<Widget>.generate(_productModelList!.length, (index) {
              return GridTile(child: WidgetHelper.animation(index, ProductItem(productModel: _productModelList![index])));
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

  Widget _departmentWidget() {
    List<Widget> _departmentItemList = [];

    _departmentmodelList?.forEach((departmentModel) {
      _departmentItemList.add(DepartmentItem(departmentModel: departmentModel));
    });

    return !_mainStore.departmentStore.isShowAllDepartment
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
        style: TextStyle(color: ColorsConts.primaryColor),
        cursorColor: ColorsConts.primaryColor,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: _mainStore.searchFilterStore.radioValue == 1 ? 'ស្វែងរកតាមឈ្មោះទំនិញ' : 'ស្វែងរកតាមប្រភេទទំនិញ',
            border: InputBorder.none,
            suffixIcon: InkWell(
              onTap: () {
                showSearchFilterDialog(context, _mainStore);
              },
              child: Icon(
                Icons.filter_list_outlined,
                size: 26,
                color: ColorsConts.primaryColor,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 26,
              color: ColorsConts.primaryColor,
            )),
      ),
    );
  }
}
