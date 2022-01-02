import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';
import 'package:tinh/services/image/image_service.dart';
import 'package:tinh/services/phone_product/phone_product_service.dart';
import 'package:tinh/widgets/show_full_scren_image_widget.dart';
import 'package:tinh/widgets/show_image_widget.dart';
import 'package:tinh/const/user_status.dart';

class PhoneDetailScreen extends StatefulWidget {
  final Function onDispose;
  final PhoneProductModel phoneProductModel;
  const PhoneDetailScreen({Key? key, required this.onDispose, required this.phoneProductModel}) : super(key: key);

  @override
  _PhoneDetailScreenState createState() => _PhoneDetailScreenState();
}

class _PhoneDetailScreenState extends State<PhoneDetailScreen> {
  late int _imagePageCount;

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
    imageService.deleteImage(widget.phoneProductModel.images, widget.phoneProductModel.imageIdRef).then((value) {});
    phoneProductServices.deletePhone(id: widget.phoneProductModel.id.toString()).then((value) {
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
  Widget build(BuildContext context) {
    _imagePageCount = widget.phoneProductModel.images.length;
    return Observer(builder: (_) {
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
    });
  }

  Widget _detailWidget() {
    return Column(
      children: [
        _label('ទំហំ និងតម្លៃ', true),
        _priceWidget(),
        _label('ពណ៌', false),
        _colorWidget(),
        _label('ពណ៌មានលម្អិត', false),
        _detail(),
      ],
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

  Widget _detail() {
    return Column(
        children: widget.phoneProductModel.detail.map((e) {
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

  Widget _label(String title, bool isShowSecondhandWidget) {
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
              Visibility(
                visible: widget.phoneProductModel.isNew == 0 && isShowSecondhandWidget,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 70,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.red, border: Border.all(color: Colors.white, width: 2)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'មួយទឹក',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
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

  Widget _colorWidget() {
    List<Widget> colorItemList = [];
    widget.phoneProductModel.colors.forEach((element) {
      colorItemList.add(_colorItem(element));
    });

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      physics: new NeverScrollableScrollPhysics(),
      children: colorItemList.map((child) {
        return WidgetHelper.animation(colorItemList.indexOf(child), child);
      }).toList(),
    );
  }

  Widget _colorItem(String color) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(color),
      ),
    );
  }

  Widget _priceWidget() {
    List<Widget> priceItemList = [];
    widget.phoneProductModel.storage.forEach((element) {
      priceItemList.add(_priceItem(element));
    });

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: new NeverScrollableScrollPhysics(),
      children: priceItemList.map((child) {
        return WidgetHelper.animation(priceItemList.indexOf(child), child);
      }).toList(),
    );
  }

  Widget _priceItem(Storage storage) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                storage.storage,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  r'$' + storage.price.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: storage.discount.toString() != '0'
                      ? TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12)
                      : TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                ),
                Visibility(
                  visible: storage.discount != 0,
                  child: Text(
                    r'$' + storage.priceAfterDiscount.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: storage.discount != 0,
            child: Text(
              'បញ្ចុះតម្លៃ' + '\t' + storage.discount.toString() + '%',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameLabel() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.3), offset: Offset(0, 1), spreadRadius: 2, blurRadius: 2),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.phoneProductModel.name,
                style: TextStyle(color: ColorsConts.primaryColor, fontSize: 18),
              ),
            ),
          ),
          SizedBox(width: 10),
          Visibility(
              visible: widget.phoneProductModel.isWarranty == 1,
              child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.red, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.5), offset: Offset(0, 1), spreadRadius: 1, blurRadius: 2)]),
                  child: Text(
                    'ធានា\t' + widget.phoneProductModel.warrantyPeriod,
                    style: TextStyle(color: Colors.white),
                  ))),
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
            child: widget.phoneProductModel.images.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      onPageChanged: (index, reson) {
                        setState(() {
                          _imagePageCount = index + 1;
                        });
                      },
                      enableInfiniteScroll: false,
                    ),
                    items: widget.phoneProductModel.images
                        .map((item) => InkWell(
                              onTap: () => NavigationHelper.push(context, ShowFullScreenImageWidget(image: item)),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Hero(
                                  tag: widget.phoneProductModel.images[widget.phoneProductModel.images.indexOf(item)],
                                  child: DisplayImage(
                                    imageString: item,
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
                  _imagePageCount.toString() + ' / ' + widget.phoneProductModel.images.length.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
