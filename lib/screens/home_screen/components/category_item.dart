import 'package:flutter/material.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/category/category_model.dart';
import 'package:tinh/screens/list_product_by_category/list_product_by_category.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryItem({Key? key, required this.categoryModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => NavigationHelper.push(
            context,
            ListProductbyCategory(
              categoryModel: categoryModel,
            )),
        child: Container(
          width: 80,
          height: 90,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: DisplayImage(
                    boxFit: BoxFit.fill,
                    imageBorderRadius: 0,
                    imageString: categoryModel.images[0],
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 236, 223, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Text(
                  categoryModel.names,
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
