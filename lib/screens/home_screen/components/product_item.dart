import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/screens/product_detail/product_detail.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp _regex = RegExp(r"([.]*0)(?!.*\d)");
    double _discountPercent = double.parse(productModel.discount.toString()) / 100;
    double _discountPrice = double.parse(productModel.price.toString()) * _discountPercent;
    String _priceAfterDiscount = (double.parse(productModel.price.toString()) - _discountPrice).toString().replaceAll(_regex, '');

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(offset: Offset(1, 1), color: Colors.grey.withOpacity(.5), blurRadius: 2),
      ]),
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width / 2 - 50,
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: InkWell(
            onTap: () => NavigationHelper.push(
                context,
                ProductDetail(
                  productModel: productModel,
                )),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        height: 180,
                        child: DisplayImage(
                          boxFit: BoxFit.fill,
                          imageBorderRadius: 20,
                          imageString: productModel.images![0],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    Visibility(
                      visible: productModel.discount.toString() != '0',
                      child: Container(
                        height: 200,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                productModel.discount.toString() + '%',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  productModel.productName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            r'$' + productModel.price!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: productModel.discount != '0' ? TextStyle(decoration: TextDecoration.lineThrough) : TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Visibility(
                            visible: productModel.discount.toString() != '0',
                            child: Text(
                              r'$' + _priceAfterDiscount,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(color: ColorsConts.primaryColor.withOpacity(.2), shape: BoxShape.circle),
                        width: 30,
                        height: 30,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          size: 15,
                          color: ColorsConts.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
