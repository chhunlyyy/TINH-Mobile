import 'package:flutter/material.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';
import 'package:tinh/screens/phone_detail/phone_detail_screen.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/placholder_image_wdiget.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class ProductItem extends StatelessWidget {
  final Function onDispose;
  final MainStore mainStore;
  final PhoneProductModel productModel;
  const ProductItem({Key? key, required this.onDispose, required this.productModel, required this.mainStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(offset: Offset(1, 1), color: Colors.grey.withOpacity(.5), blurRadius: 2),
      ]),
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width / 2 - 50,
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: InkWell(
            onTap: () => NavigationHelper.push(
                context,
                PhoneDetailScreen(
                  onDispose: onDispose,
                  phoneProductModel: productModel,
                )),
            child: Column(
              children: [
                Stack(
                  children: [
                    productModel.images.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 200,
                            child: Hero(
                              tag: productModel.images[0],
                              child: DisplayImage(
                                boxFit: BoxFit.fitHeight,
                                imageBorderRadius: 20,
                                imageString: productModel.images[0],
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ))
                        : Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 200,
                            child: PlaceholderImageWidget(),
                          ),
                    Visibility(
                      visible: productModel.storage[0].discount != 0,
                      child: Container(
                        height: 200,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                productModel.storage[0].discount.toString() + '%',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: productModel.isNew == 0,
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
                SizedBox(height: 10),
                Text(
                  productModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        r'$' + productModel.storage[0].price.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: productModel.storage[0].discount.toString() != '0'
                            ? TextStyle(decoration: TextDecoration.lineThrough)
                            : TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                      ),
                      Visibility(
                        visible: productModel.storage[0].discount != 0,
                        child: Text(
                          r'$' + productModel.storage[0].priceAfterDiscount.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                        ),
                      )
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
