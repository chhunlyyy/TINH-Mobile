import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/show_full_scren_image_widget.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetail({Key? key, required this.productModel}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState(this.productModel);
}

class _ProductDetailState extends State<ProductDetail> {
  _ProductDetailState(this._model);
  final ProductModel _model;
  MainStore _mainStore = MainStore();
  int _colorIndex = -1;
  int _sizeIndex = -1;
  int _quantity = 1;
  late String _priceAfterDiscount;
  RegExp _regex = RegExp(r"([.]*0)(?!.*\d)");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _discountPercent = double.parse(_model.discount.toString()) / 100;
    double _discountPrice = double.parse(_model.price.toString()) * _discountPercent;
    _priceAfterDiscount = (double.parse(_model.price.toString()) - _discountPrice).toString().replaceAll(_regex, '');

    return Material(
      child: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Observer(builder: (_) {
      return Column(
        children: [
          WidgetHelper.appBar(context),
          _imageWidget(),
          _detailWidget(),
          _addToCartWidget(),
        ],
      );
    });
  }

  Widget _addToCartWidget() {
    return Container(
      decoration: BoxDecoration(color: ColorsConts.primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
      width: MediaQuery.of(context).size.width,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _totalPriceWidget(),
          _addToCartButtonWidget(),
        ],
      ),
    );
  }

  Widget _totalPriceWidget() {
    return Container(
      child: Text(
        r'$' + (double.parse(_priceAfterDiscount) * _quantity).toString().replaceAll(_regex, ''),
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }

  Widget _addToCartButtonWidget() {
    return Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
        height: 50,
        width: MediaQuery.of(context).size.width / 3,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {},
                  child: Center(
                      child: Text(
                    'បន្ថែមទៅរទេះ',
                  ))),
            )));
  }

  Widget _priceWidget(String priceAterDiscount) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: _model.discount != '0' ? 20 : 35, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: _model.discount.toString() != '0',
            child: Text(
              r'$' + priceAterDiscount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
            ),
          ),
          SizedBox(width: 10),
          Text(
            r'$' + _model.price,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                _model.discount != '0' ? TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black) : TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
          ),
          SizedBox(width: 10),
          Visibility(visible: _model.discount.toString() != '0', child: Text('បញ្ចុះតម្លៃ ' + _model.discount.toString() + r'%'))
        ],
      ),
    );
  }

  Widget _detailWidget() {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(50)), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, -10),
          ),
        ]),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _priceWidget(_priceAfterDiscount),
              _nameWidget(),
              _productDetailWidget(),
              _colorLabel(),
              _colorWidget(),
              _sizeLabel(),
              _sizeWidget(),
              _quantityLabel(),
              _quantityWidget(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quantityWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _buildQuantityButton(false),
          SizedBox(width: 10),
          Text(_quantity.toString()),
          SizedBox(width: 10),
          _buildQuantityButton(true),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(bool isIncreas) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isIncreas) {
                setState(() {
                  _quantity++;
                });
              } else {
                if (_quantity > 1) {
                  setState(() {
                    _quantity--;
                  });
                }
              }
            },
            child: Icon(
              isIncreas ? FontAwesomeIcons.plus : FontAwesomeIcons.minus,
              size: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _quantityLabel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('ចំនួន', style: TextStyle(color: ColorsConts.primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: .5,
            color: ColorsConts.primaryColor.withOpacity(.5),
          )
        ],
      ),
    );
  }

  Widget _colorLabel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('ពណ៌', style: TextStyle(color: ColorsConts.primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: .5,
            color: ColorsConts.primaryColor.withOpacity(.5),
          )
        ],
      ),
    );
  }

  Widget _sizeLabel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('ទំហំ', style: TextStyle(color: ColorsConts.primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: .5,
            color: ColorsConts.primaryColor.withOpacity(.5),
          )
        ],
      ),
    );
  }

  Widget _sizeWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: GridView.count(
          childAspectRatio: 3.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          crossAxisCount: 3,
          physics: new NeverScrollableScrollPhysics(),
          children: _model.size
              .map((size) => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _sizeIndex = _model.size.indexOf(size);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: _sizeIndex == _model.size.indexOf(size) ? ColorsConts.primaryColor : ColorsConts.primaryColor.withOpacity(.15), borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Radio(
                                fillColor: MaterialStateProperty.resolveWith((colors) {
                                  return _sizeIndex == _model.size.indexOf(size) ? Colors.white : ColorsConts.primaryColor;
                                }),
                                value: _model.size.indexOf(size),
                                groupValue: _sizeIndex,
                                onChanged: (int? value) {
                                  setState(() {
                                    _sizeIndex = value!;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              Text(
                                size,
                                style: TextStyle(color: _sizeIndex == _model.size.indexOf(size) ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _colorWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: GridView.count(
          childAspectRatio: 3.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          crossAxisCount: 3,
          physics: new NeverScrollableScrollPhysics(),
          children: _model.colors
              .map((color) => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _colorIndex = _model.colors.indexOf(color);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: _colorIndex == _model.colors.indexOf(color) ? ColorsConts.primaryColor : ColorsConts.primaryColor.withOpacity(.15), borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Radio(
                                fillColor: MaterialStateProperty.resolveWith((colors) {
                                  return _colorIndex == _model.colors.indexOf(color) ? Colors.white : ColorsConts.primaryColor;
                                }),
                                value: _model.colors.indexOf(color),
                                groupValue: _colorIndex,
                                onChanged: (int? value) {
                                  setState(() {
                                    _colorIndex = value!;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              Text(
                                color,
                                style: TextStyle(color: _colorIndex == _model.colors.indexOf(color) ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _productDetailWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 20, right: 10),
      child: Text(
        _model.desc,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _nameWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 10, right: 10),
      child: Text(
        _model.productName,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _imageWidget() {
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: CarouselSlider(
              options: CarouselOptions(
                onPageChanged: (index, reson) {
                  _mainStore.productDetailStore.changeProductPageCount(index);
                },
                enableInfiniteScroll: false,
              ),
              items: _model.images
                  .map((item) => InkWell(
                        onTap: () => NavigationHelper.push(context, ShowFullScreenImageWidget(image: item)),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: DisplayImage(
                            imageString: item,
                            imageBorderRadius: 0,
                            boxFit: BoxFit.contain,
                          ),
                        ),
                      ))
                  .toList(),
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: ColorsConts.primaryColor, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  _mainStore.productDetailStore.productPageCount.toString() + ' / ' + _model.images.length.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
