import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/phone_brand/phone_brand_model.dart';
import 'package:tinh/models/phone_category/phone_category_model.dart';
import 'package:tinh/screens/home_screen/components/product_item.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/placholder_image_wdiget.dart';
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
  int categoryIndex = 0;

  Future<void> _loadPhone() async {
    if (categoryIndex == 0) {
      await _mainStore.phoneProductStore.loadPhoneByBrand(
        pageSize: pageSize,
        pageIndex: pageIndex,
        brandId: widget.phoneBrandModel.id,
      );
    } else {
      await _mainStore.phoneProductStore.loadPhoneByCategory(
        isNew: 1,
        pageSize: pageSize,
        pageIndex: pageIndex,
        brandId: widget.phoneBrandModel.id,
        categoryId: categoryIndex,
      );
    }
  }

  void _loadPhoneCategory() {
    Future.delayed(Duration.zero, () async {
      await _mainStore.phoneCategoryStore.loadData();
    }).whenComplete(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    _loadPhone();
    _loadPhoneCategory();
    super.initState();
  }

  @override
  void dispose() {
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
          _titleWidget(),
          SizedBox(height: 5),
          Expanded(child: _productWidget()),
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
            pageSize = 6;
            pageIndex = 0;
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

  Widget _productWidget() {
    Widget _content = WidgetHelper.loadingWidget(context, MediaQuery.of(context).size.height);

    if (!_mainStore.phoneProductStore.isLoading) {
      _content = _mainStore.phoneProductStore.phoneProductModelList.isNotEmpty
          ? Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.height,
              child: EasyRefresh(
                  header: BallPulseHeader(color: ColorsConts.primaryColor),
                  onLoad: () async {
                    pageIndex = pageIndex + pageSize;
                    await _loadPhone();
                  },
                  onRefresh: () {
                    pageSize = 6;
                    pageIndex = 0;
                    _mainStore.phoneProductStore.phoneProductModelList.clear();
                    return _loadPhone();
                  },
                  child: _mainStore.phoneProductStore.phoneProductModelList.isNotEmpty
                      ? WidgetHelper.gridView(
                          context: context,
                          children: List<Widget>.generate(_mainStore.phoneProductStore.phoneProductModelList.length, (index) {
                            return GridTile(
                                child: WidgetHelper.animation(
                                    index,
                                    ProductItem(
                                        onDispose: () {
                                          pageSize = 6;
                                          pageIndex = 0;
                                          _mainStore.phoneProductStore.phoneProductModelList.clear();
                                          _loadPhone();
                                        },
                                        mainStore: _mainStore,
                                        productModel: _mainStore.phoneProductStore.phoneProductModelList[index])));
                          }))
                      : Container()),
            )
          : WidgetHelper.noDataFound();
    }

    return _content;
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: widget.phoneBrandModel.images.isNotEmpty
                          ? DisplayImage(
                              imageString: widget.phoneBrandModel.images[0],
                              imageBorderRadius: 0,
                              boxFit: BoxFit.fill,
                            )
                          : PlaceholderImageWidget(),
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
}
