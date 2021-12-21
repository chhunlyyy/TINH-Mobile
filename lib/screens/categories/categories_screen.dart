import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/categories/categories_model.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:tinh/widgets/show_image_widget.dart';

class CategoriesScreen extends StatefulWidget {
  final String title;
  const CategoriesScreen({Key? key, required this.title}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  MainStore _mainStore = MainStore();
  @override
  void initState() {
    super.initState();

    _mainStore.categoriesStore.loadData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Material(
        child: SafeArea(
          child: _buildBody(),
        ),
      );
    });
  }

  Widget _buildBody() {
    return Column(
      children: [
        WidgetHelper.appBar(context, widget.title),
        Expanded(
          child: Container(
              child: SingleChildScrollView(
            child: _categoriesWidget(),
          )),
        ),
      ],
    );
  }

  Widget _categoriesWidget() {
    Widget content = Container();

    if (_mainStore.categoriesStore.categoriesList.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: EdgeInsets.all(1.0),
            childAspectRatio: 8 / 9,
            children: List<Widget>.generate(_mainStore.categoriesStore.categoriesList.length, (index) {
              return GridTile(child: WidgetHelper.animation(index, _categoriesItem(_mainStore.categoriesStore.categoriesList[index])));
            })),
      );
    }

    return content;
  }

  Widget _categoriesItem(CategoriesModel categoriesModel) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(offset: Offset(1, 1), color: Colors.grey.withOpacity(.5), blurRadius: 2),
      ]),
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width / 2 - 50,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 150,
                        child: DisplayImage(
                          boxFit: BoxFit.fitHeight,
                          imageBorderRadius: 20,
                          imageString: categoriesModel.images[0],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  categoriesModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, color: ColorsConts.primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
