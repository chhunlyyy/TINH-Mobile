import 'package:flutter/material.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/models/phone_brand/phone_brand_model.dart';
import 'package:tinh/screens/list_phone_by_category/list_phone_by_category.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/placholder_image_wdiget.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class PhoneBrandItem extends StatelessWidget {
  final MainStore mainStore;
  final PhoneBrandModel phoneBrandModel;
  const PhoneBrandItem({Key? key, required this.phoneBrandModel, required this.mainStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => NavigationHelper.push(
            context,
            ListPhoneByCategory(
              phoneBrandModel: phoneBrandModel,
            )),
        child: Container(
          width: 80,
          height: 90,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: phoneBrandModel.images.isNotEmpty
                    ? Container(
                        child: DisplayImage(
                          boxFit: BoxFit.fill,
                          imageBorderRadius: 5,
                          imageString: phoneBrandModel.images[0],
                        ),
                        decoration: BoxDecoration(
                          // color: Color.fromRGBO(255, 236, 223, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                    : PlaceholderImageWidget(),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Text(
                  phoneBrandModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
