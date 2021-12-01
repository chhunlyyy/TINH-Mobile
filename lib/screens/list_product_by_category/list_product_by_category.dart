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
  final MainStore mainStore;
  final CategoryModel categoryModel;
  const ListProductbyCategory({Key? key, required this.categoryModel, required this.mainStore}) : super(key: key);

  @override
  _ListProductbyCategoryState createState() => _ListProductbyCategoryState();
}

class _ListProductbyCategoryState extends State<ListProductbyCategory> {
  MainStore _mainStore = MainStore();
  int pageSize = 6;
  int pageIndex = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await widget.mainStore.productStore.loadProductByCategory(
        pageSize: pageSize,
        pageIndex: pageIndex,
        categoryId: widget.categoryModel.id,
      );
    });
    // TODO: implement initState
    super.initState();
    _mainStore = widget.mainStore;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mainStore.productStore.productModelList.clear();
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
    return Container(
      child: Column(
        children: [
          WidgetHelper.appBar(context),
          _titleWidget(),
          SizedBox(height: 5),
          Expanded(child: _productWidget()),
        ],
      ),
    );
  }

  Widget _productWidget() {
    Widget _content = WidgetHelper.loadingWidget(context);

    if (!_mainStore.productStore.isLoading) {
      _content = _mainStore.productStore.productModelList.isNotEmpty
          ? Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.height,
              child: EasyRefresh(
                  header: BallPulseHeader(color: ColorsConts.primaryColor),
                  onLoad: () async {
                    pageIndex = pageIndex + pageSize;
                    await widget.mainStore.productStore.loadProductByCategory(
                      pageSize: pageSize,
                      pageIndex: pageIndex,
                      categoryId: widget.categoryModel.id,
                    );
                  },
                  onRefresh: () {
                    pageSize = 6;
                    pageIndex = 0;
                    _mainStore.productStore.productModelList.clear();
                    return widget.mainStore.productStore.loadProductByCategory(
                      pageSize: pageSize,
                      pageIndex: pageIndex,
                      categoryId: widget.categoryModel.id,
                    );
                  },
                  child: _mainStore.productStore.productModelList.isNotEmpty
                      ? GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(1.0),
                          childAspectRatio: 8 / 12.0,
                          children: List<Widget>.generate(_mainStore.productStore.productModelList.length, (index) {
                            return GridTile(child: WidgetHelper.animation(index, ProductItem(mainStore: _mainStore, productModel: _mainStore.productStore.productModelList[index])));
                          }))
                      : Container()),
            )
          : WidgetHelper.noDataFound();
    }

    return _content;
  }

  Widget _titleWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.4), blurRadius: 2, spreadRadius: 2, offset: Offset(0, 1))]),
      margin: EdgeInsets.only(top: 10),
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
