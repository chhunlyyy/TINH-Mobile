import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/custom_cache_manager.dart';
import 'package:tinh/helper/file_picker_widget.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/http/http_get_base_url.dart';
import 'package:tinh/models/categories/categories_model.dart';
import 'package:tinh/models/phone_brand/phone_brand_model.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';
import 'package:tinh/screens/categories/categories_screen.dart';
import 'package:tinh/screens/list_phone_by_category/list_phone_by_category.dart';
import 'package:tinh/services/categories/categories_service.dart';
import 'package:tinh/services/image/image_service.dart';
import 'package:tinh/services/phone_brand/phone_brand_service.dart';
import 'package:tinh/store/main/main_store.dart';

class UpdateCategoryScreen extends StatefulWidget {
  final CategoriesModel categoriesModel;
  final MainStore mainStore;
  const UpdateCategoryScreen({Key? key, required this.mainStore, required this.categoriesModel}) : super(key: key);

  @override
  _UpdateCategoryScreenState createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  List<File> brandAttachmentsList = [];

  TextEditingController _phoneBrandController = TextEditingController();

  List<ImageModel> deletedImage = [];
  //

  void onUpdate() {
    bool imageValidate = true;

    if (deletedImage.isNotEmpty) {
      if (brandAttachmentsList.isEmpty) {
        imageValidate = false;
      }
    }

    if (imageValidate && _phoneBrandController.text.isNotEmpty) {
      imageService.insertImage(brandAttachmentsList, widget.categoriesModel.imageIdRef);

      imageService.deleteImage(deletedImage);

      if (_phoneBrandController.text.isNotEmpty) {
        Map<String, dynamic> postData = {
          'id': widget.categoriesModel.id,
          'name': _phoneBrandController.text,
        };
        categoriesService.updateCategory(postData).then((value) {
          AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: value == '200' ? DialogType.SUCCES : DialogType.ERROR,
            borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
            width: MediaQuery.of(context).size.width,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            desc: value == '200' ? 'កែប្រែបានជោគជ័យ' : 'មានបញ្ហាក្នុងពេលកែប្រែទិន្នន័យ',
            showCloseIcon: false,
          )..show();

          Future.delayed(Duration(seconds: 2)).whenComplete(() {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return CategoriesScreen(
                  title: 'សម្ភារៈផ្សេងៗ',
                );
              }),
            );
          });
        });
      }
    } else {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.INFO,
        borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
        width: MediaQuery.of(context).size.width,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        desc: 'សូមបញ្ចូលទិន្នន័យទាំងអស់',
        showCloseIcon: false,
        btnOkOnPress: () {},
      )..show();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneBrandController.text = widget.categoriesModel.name;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsConts.primaryColor,
          title: Text('កែប្រែម៉ាក់ផលិតផល'),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextInput('ឈ្មោះម៉ាក់ទូរស័ព្ទ', _phoneBrandController),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text('រូបភាព'),
                ),
                deletedImage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: FilePickerWidget(
                          isPickFromFileExplorer: false,
                          count: 10,
                          attachments: brandAttachmentsList,
                          isMultiSelect: false,
                          onChoosingFiles: (files) {},
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 20),
                deletedImage.isEmpty ? _showImageWidget() : SizedBox.shrink(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedButton(
                    pressEvent: onUpdate,
                    text: 'កែប្រែ',
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _showImageWidget() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          width: 120,
          height: 120,
          child: CachedNetworkImage(
            cacheManager: CustomCacheManager(),
            fit: BoxFit.fill,
            imageUrl: baseUrl + widget.categoriesModel.images.image,
            errorWidget: (context, imageUrl, error) => Image.asset('assets/images/placeholder.jpg'),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              deletedImage.add(widget.categoriesModel.images);
            });
          },
          child: Icon(
            FontAwesomeIcons.times,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget _buildTextInput(String label, TextEditingController textEditingController, {TextInputType textInputType = TextInputType.text, bool hasOnChange = false, int index = 0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: textInputType,
            maxLines: null,
            controller: textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(.5),
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffD98C00),
                ),
              ),
              contentPadding: new EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
