import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/category/category_model.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/screens/home_screen/components/product_item.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class ListProductbyCategory extends StatefulWidget {
  final CategoryModel categoryModel;
  const ListProductbyCategory({Key? key, required this.categoryModel}) : super(key: key);

  @override
  _ListProductbyCategoryState createState() => _ListProductbyCategoryState();
}

class _ListProductbyCategoryState extends State<ListProductbyCategory> {
  MainStore _mainStore = MainStore();
  List<ProductModel> _productModelList = [];
  bool _isOnRefres = false;
  Future<void> _getData(bool isRefresh) async {
    _isOnRefres = isRefresh;
    await _mainStore.productStore.loadProductByCategory(pageSize: 5, pageIndex: 0, categoryId: widget.categoryModel.id);
  }

  @override
  void initState() {
    _mainStore.homeScreenStore.changeLoading();
    _getData(false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(child: Observer(
        builder: (_) {
          return _buildBody();
        },
      )),
    );
  }

  Widget _buildBody() {
    Widget _content = WidgetHelper.loadingWidget(context);

    if (!_mainStore.homeScreenStore.isLoading) {
      _content = Container(
        child: Column(
          children: [
            WidgetHelper.appBar(context),
            _titleWidget(),
            SizedBox(height: 10),
            Expanded(child: _productWidget()),
          ],
        ),
      );
    }

    return _content;
  }

  Widget _productWidget() {
    Future.delayed(Duration(seconds: _isOnRefres ? 1 : 0)).whenComplete(() {
      setState(() {
        _productModelList = _mainStore.productStore.observableFutureProduct!.value!;
      });
    });

    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.height,
      child: EasyRefresh(
          header: BallPulseHeader(color: ColorsConts.primaryColor),
          onLoad: () async {},
          onRefresh: () => _getData(true),
          child: _productModelList.isNotEmpty
              ? GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(1.0),
                  childAspectRatio: 8 / 12.0,
                  children: List<Widget>.generate(_productModelList!.length, (index) {
                    return GridTile(child: WidgetHelper.animation(index, ProductItem(productModel: _productModelList![index])));
                  }))
              // Container(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: _productModelList!.map((productmodel) {
              //         return WidgetHelper.animation(_productModelList!.indexOf(productmodel), ProductItem(productModel: productmodel));
              //       }).toList(),
              //     ),
              //   )
              : Container()),
    );
  }

  Widget _titleWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.5), blurRadius: 2, spreadRadius: 2, offset: Offset(0, 1))]),
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            child: DisplayImage(
              imageString: widget.categoryModel.images[0],
              imageBorderRadius: 0,
              boxFit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            height: 50,
            alignment: Alignment.center,
            child: Text(
              widget.categoryModel.names,
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
