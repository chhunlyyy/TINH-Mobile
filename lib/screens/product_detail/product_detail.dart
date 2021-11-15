import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

  @override
  Widget build(BuildContext context) {
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
        ],
      );
    });
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
              items: _model.images!
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
                  _mainStore.productDetailStore.productPageCount.toString() + ' / ' + _model.images!.length.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
