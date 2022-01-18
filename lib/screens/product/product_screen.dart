import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/const/user_status.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/categories/categories_model.dart';
import 'package:tinh/screens/categories/categories_screen.dart';
import 'package:tinh/screens/product/components/product_item.dart';
import 'package:tinh/screens/update_category/update_category.dart';
import 'package:tinh/services/categories/categories_service.dart';
import 'package:tinh/services/image/image_service.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class ProductScreen extends StatefulWidget {
  final CategoriesModel categoriesModel;
  const ProductScreen({Key? key, required this.categoriesModel}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  MainStore _mainStore = MainStore();
  int _pageSize = 6;
  int _pageIndex = 0;

  TextEditingController _searchController = TextEditingController();

  void _onDelete() {
    Future.delayed(Duration.zero).whenComplete(() {
      _mainStore.productStore.productModelList.clear();
      _mainStore.productStore
          .loadData(
        pageSize: 10,
        pageIndex: 0,
        categoryId: widget.categoriesModel.id,
      )
          .whenComplete(() {
        if (_mainStore.productStore.productModelList.isNotEmpty) {
          AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.INFO,
            borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
            width: MediaQuery.of(context).size.width,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            desc: 'មិនអនុញ្ញាតអោយលុបប្រភេទផលិតផលនេះទេ',
            showCloseIcon: false,
            btnOkOnPress: () {},
          )..show();
        } else {
          AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.QUESTION,
            borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
            width: MediaQuery.of(context).size.width,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            desc: 'តើអ្នកពិតជាចង់លុបប្រភេទផលិតផលនេះមែនទេ ?',
            showCloseIcon: false,
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Future.delayed(Duration.zero, () async {
                await categoriesService.deleteCategory(widget.categoriesModel.id.toString());
                await imageService.deleteImage([widget.categoriesModel.images]);

                _mainStore.categoriesStore.categoriesList.clear();
                _mainStore.categoriesStore.loadData().whenComplete(() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  NavigationHelper.push(context, CategoriesScreen(title: 'សម្ភារៈផ្សេងៗ'));
                });
              });
            },
          )..show();
        }
      });
    });
  }

  void _onSearch(String text) {
    _pageSize = 6;
    _pageIndex = 0;
    _mainStore.productStore.productModelList.clear();
    _mainStore.productStore.searchProduct(categoryId: widget.categoriesModel.id, pageIndex: _pageIndex, pageSize: _pageSize, name: text);
  }

  @override
  void initState() {
    super.initState();
    _mainStore.productStore.loadData(categoryId: widget.categoriesModel.id, pageIndex: _pageIndex, pageSize: _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Material(
          child: SafeArea(child: GestureDetector(onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), child: _buildBody())),
        );
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        isShopOwner ? _titleWidget() : WidgetHelper.appBar(context, widget.categoriesModel.name),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _searchWidget()),
            _searchButton(true),
            _searchButton(false),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: EasyRefresh(
            onLoad: () async {
              _pageIndex = _pageIndex + _pageSize;
              if (_searchController.text.isNotEmpty) {
                _mainStore.productStore.searchProduct(categoryId: widget.categoriesModel.id, pageIndex: _pageIndex, pageSize: _pageSize, name: _searchController.text);
              } else {
                _mainStore.productStore.loadData(categoryId: widget.categoriesModel.id, pageIndex: _pageIndex, pageSize: _pageSize);
              }
            },
            onRefresh: () {
              _pageIndex = 0;
              _pageSize = 6;
              _searchController.text = '';
              _mainStore.productStore.productModelList.clear();
              return _mainStore.productStore.loadData(categoryId: widget.categoriesModel.id, pageIndex: _pageIndex, pageSize: _pageSize);
            },
            header: BallPulseHeader(color: ColorsConts.primaryColor),
            child: _productWidget(),
          ),
        )
      ],
    );
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
              FocusScope.of(context).requestFocus(new FocusNode());
              _onSearch(_searchController.text);
            }
          } else {
            if (_searchController.text != '') {
              FocusScope.of(context).requestFocus(new FocusNode());
              _searchController.text = '';
              _mainStore.productStore.productModelList.clear();
              _mainStore.productStore.loadData(pageSize: 6, pageIndex: 0, categoryId: widget.categoriesModel.id);
            }
          }
        },
        borderRadius: BorderRadius.circular(5),
        text: isSearch ? 'ស្វែងរក' : 'បោះបង់',
      ),
    );
  }

  Widget _searchWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
      width: MediaQuery.of(context).size.width,
      height: 40,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        onChanged: (text) {
          if (text == '') {
            _mainStore.productStore.productModelList.clear();
            _mainStore.productStore.loadData(categoryId: widget.categoriesModel.id, pageIndex: 0, pageSize: 6);
          }
        },
        controller: _searchController,
        style: TextStyle(color: ColorsConts.primaryColor),
        cursorColor: ColorsConts.primaryColor,
        decoration: InputDecoration(
            contentPadding: new EdgeInsets.only(top: 0),
            hintText: 'ស្វែងរក\t' + widget.categoriesModel.name,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              size: 26,
              color: ColorsConts.primaryColor,
            )),
      ),
    );
  }

  Widget _productWidget() {
    Widget content = WidgetHelper.loadingWidget(context, MediaQuery.of(context).size.height);
    if (!_mainStore.productStore.isLoading) {
      content = _mainStore.productStore.productModelList.isEmpty
          ? WidgetHelper.noDataFound()
          : WidgetHelper.gridView(
              context: context,
              children: List<Widget>.generate(_mainStore.productStore.productModelList.length, (index) {
                return GridTile(
                    child: WidgetHelper.animation(
                        index,
                        ProductItem(
                          onDispose: () {
                            _mainStore.productStore.productModelList.clear();
                            _mainStore.productStore.loadData(categoryId: widget.categoriesModel.id, pageIndex: 0, pageSize: 6);
                          },
                          mainStore: _mainStore,
                          productModel: _mainStore.productStore.productModelList[index],
                        )));
              }));
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
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isShopOwner ? SizedBox(width: 20) : SizedBox.shrink(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        widget.categoriesModel.name,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  isShopOwner ? Expanded(child: SizedBox()) : SizedBox.shrink(),
                  isShopOwner
                      ? AnimatedButton(
                          width: 80,
                          pressEvent: () {
                            NavigationHelper.push(context, UpdateCategoryScreen(mainStore: _mainStore, categoriesModel: widget.categoriesModel));
                          },
                          text: 'កែប្រែ',
                        )
                      : SizedBox.shrink(),
                  isShopOwner ? SizedBox(width: 10) : SizedBox.shrink(),
                  isShopOwner
                      ? AnimatedButton(
                          width: 80,
                          pressEvent: _onDelete,
                          text: 'លុប',
                          color: Colors.red,
                        )
                      : SizedBox.shrink(),
                  SizedBox(width: isShopOwner ? 10 : MediaQuery.of(context).size.width / 8),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
