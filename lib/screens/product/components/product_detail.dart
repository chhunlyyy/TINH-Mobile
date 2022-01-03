import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/services/image/image_service.dart';
import 'package:tinh/services/product/product_service.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/show_full_scren_image_widget.dart';
import 'package:tinh/widgets/show_image_widget.dart';
import 'package:tinh/const/user_status.dart';

class ProductDetail extends StatefulWidget {
  final Function onDispose;
  final MainStore mainStore;
  final ProductModel productModel;
  const ProductDetail({Key? key, required this.productModel, required this.mainStore, required this.onDispose}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late int _imagePageCount = widget.productModel.images.length != 0 ? 1 : 0;
  void _errorDialog() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.ERROR,
      borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
      width: MediaQuery.of(context).size.width,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      desc: 'មានបញ្ហាក្នុងពេលបញ្ចូលទិន្នន័យ',
      showCloseIcon: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

  void _sucessDialog() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.SUCCES,
      borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
      width: MediaQuery.of(context).size.width,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      desc: 'ទិន្នន័យត្រូវបានលុប',
      showCloseIcon: false,
    )..show();
  }

  void _onDelete() {
    List<String> imagePath = [];
    for (var image in widget.productModel.images) {
      imagePath.add(image.image);
    }

    imageService.deleteImage(widget.productModel.images).then((value) {});
    productServices.deleteProduct(id: widget.productModel.id.toString()).then((value) {
      if (value.status == '200') {
        _sucessDialog();
        widget.onDispose();
        Future.delayed(Duration(seconds: 2)).whenComplete(() {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        _errorDialog();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Material(
            child: SafeArea(
          child: Column(
            children: [
              _appBar(),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _imageWidget(),
                        _nameLabel(),
                        SizedBox(height: 10),
                        _detailWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget _appBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      height: 60,
      child: Row(
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
              child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Text('', style: TextStyle(color: ColorsConts.primaryColor, fontSize: 22)),
            ),
          )),
          isShopOwner
              ? AnimatedButton(
                  borderRadius: BorderRadius.circular(5),
                  width: 100,
                  height: 50,
                  pressEvent: () {},
                  text: 'កែប្រែ',
                )
              : SizedBox.shrink(),
          SizedBox(width: 10),
          isShopOwner
              ? AnimatedButton(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                  width: 100,
                  height: 50,
                  pressEvent: () {
                    AwesomeDialog(
                      dismissOnTouchOutside: false,
                      context: context,
                      dialogType: DialogType.QUESTION,
                      borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
                      width: MediaQuery.of(context).size.width,
                      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      desc: 'តើអ្នកពិតជាចង់លុបទិន្នន័យនេះមែនទេ ?',
                      showCloseIcon: false,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        _onDelete();
                      },
                    )..show();
                  },
                  text: 'លុប',
                )
              : SizedBox.shrink(),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _detailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _label('តម្លៃ'),
        _priceWidget(),
        widget.productModel.colors.isNotEmpty ? _label('ពណ៌') : SizedBox.shrink(),
        widget.productModel.colors.isNotEmpty ? _colorWidget() : SizedBox.shrink(),
        widget.productModel.colors.isNotEmpty ? _label('ពណ៌មានលម្អិត') : SizedBox.shrink(),
        widget.productModel.colors.isNotEmpty ? _detail() : SizedBox.shrink(),
      ],
    );
  }

  Widget _colorWidget() {
    List<Widget> colorItemList = [];
    widget.productModel.colors.forEach((element) {
      colorItemList.add(_colorItem(element.color));
    });

    final double runSpacing = 4;
    final double spacing = 4;

    return SingleChildScrollView(
      child: Wrap(
        runSpacing: runSpacing,
        spacing: spacing,
        alignment: WrapAlignment.center,
        children: List.generate(colorItemList.length, (index) {
          return colorItemList[index];
        }),
      ),
    );
  }

  Widget _detail() {
    return Column(
        children: widget.productModel.detail.map((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.name + '\t:\t', style: TextStyle(color: ColorsConts.primaryColor)),
            Expanded(child: Text(e.descs)),
          ],
        ),
      );
    }).toList());
  }

  Widget _colorItem(String color) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(color),
      ),
    );
  }

  Widget _priceWidget() {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  r'$' + widget.productModel.price.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.productModel.discount.toString() != '0'
                      ? TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12)
                      : TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                ),
                Visibility(
                  visible: widget.productModel.discount != 0,
                  child: Text(
                    r'$' + widget.productModel.priceAfterDiscount.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.productModel.discount != 0,
            child: Text(
              'បញ្ចុះតម្លៃ' + '\t' + widget.productModel.discount.toString() + '%',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 20),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  Widget _nameLabel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.3), offset: Offset(0, 1), spreadRadius: 2, blurRadius: 2),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.productModel.name,
                style: TextStyle(color: ColorsConts.primaryColor, fontSize: 18),
              ),
            ),
          ),
          SizedBox(width: 10),
          Visibility(
            visible: widget.productModel.isWarranty == 1,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.5), offset: Offset(0, 1), spreadRadius: 1, blurRadius: 2)]),
              child: Text(
                'ធានា\t' + widget.productModel.warrantyPeriod,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: widget.productModel.images.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      onPageChanged: (index, reson) {
                        setState(() {
                          _imagePageCount = index + 1;
                        });
                      },
                      enableInfiniteScroll: false,
                    ),
                    items: widget.productModel.images
                        .map((item) => InkWell(
                              onTap: () => NavigationHelper.push(context, ShowFullScreenImageWidget(image: item.image)),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Hero(
                                  tag: widget.productModel.images[widget.productModel.images.indexOf(item)],
                                  child: DisplayImage(
                                    imageString: item.image,
                                    imageBorderRadius: 0,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  )
                : Container()),
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
                  _imagePageCount.toString() + ' / ' + widget.productModel.images.length.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
