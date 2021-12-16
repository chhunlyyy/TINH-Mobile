import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/phone_brand/phone_brand_model.dart';
import 'package:tinh/screens/home_screen/components/product_item.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class ListPhoneByCategory extends StatefulWidget {
  final PhoneBrandModel phoneBrandModel;
  const ListPhoneByCategory({Key? key, required this.phoneBrandModel}) : super(key: key);

  @override
  _ListPhoneByCategoryState createState() => _ListPhoneByCategoryState();
}

class _ListPhoneByCategoryState extends State<ListPhoneByCategory> {
  MainStore _mainStore = MainStore();
  int pageSize = 6;
  int pageIndex = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await _mainStore.phoneProductStore.loadPhoneByBrand(
        pageSize: pageSize,
        pageIndex: pageIndex,
        brandId: widget.phoneBrandModel.id,
      );
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mainStore.phoneProductStore.phoneProductModelList.clear();
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

    if (!_mainStore.phoneProductStore.isLoading) {
      _content = _mainStore.phoneProductStore.phoneProductModelList.isNotEmpty
          ? Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.height,
              child: EasyRefresh(
                  header: BallPulseHeader(color: ColorsConts.primaryColor),
                  onLoad: () async {
                    pageIndex = pageIndex + pageSize;
                    await _mainStore.phoneProductStore.loadPhoneByBrand(
                      pageSize: pageSize,
                      pageIndex: pageIndex,
                      brandId: widget.phoneBrandModel.id,
                    );
                  },
                  onRefresh: () {
                    pageSize = 6;
                    pageIndex = 0;
                    _mainStore.phoneProductStore.phoneProductModelList.clear();
                    return _mainStore.phoneProductStore.loadPhoneByBrand(
                      pageSize: pageSize,
                      pageIndex: pageIndex,
                      brandId: widget.phoneBrandModel.id,
                    );
                  },
                  child: _mainStore.phoneProductStore.phoneProductModelList.isNotEmpty
                      ? GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(1.0),
                          childAspectRatio: 8 / 12.0,
                          children: List<Widget>.generate(_mainStore.phoneProductStore.phoneProductModelList.length, (index) {
                            return GridTile(child: WidgetHelper.animation(index, ProductItem(mainStore: _mainStore, productModel: _mainStore.phoneProductStore.phoneProductModelList[index])));
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
              imageString: widget.phoneBrandModel.images[0],
              imageBorderRadius: 0,
              boxFit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            height: 50,
            alignment: Alignment.center,
            child: Text(
              widget.phoneBrandModel.name,
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
