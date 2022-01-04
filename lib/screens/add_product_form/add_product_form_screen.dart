import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/custom_cache_manager.dart';
import 'package:tinh/helper/file_picker_widget.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/http/http_get_base_url.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';
import 'package:tinh/models/product/product_model.dart' as prefix;
import 'package:tinh/screens/home_screen/home_screen.dart';
import 'package:tinh/screens/product/components/product_detail.dart';
import 'package:tinh/services/image/image_service.dart';
import 'package:tinh/services/product/insert_product_serivce.dart';
import 'package:tinh/services/product/product_service.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:uuid/uuid.dart';

class AddProductFormScreen extends StatefulWidget {
  final Function onDispose;
  final MainStore mainStore;
  final prefix.ProductModel? productModel;
  const AddProductFormScreen({Key? key, required this.onDispose, required this.productModel, required this.mainStore}) : super(key: key);

  @override
  _AddProductFormScreenState createState() => _AddProductFormScreenState();
}

class _AddProductFormScreenState extends State<AddProductFormScreen> {
  /* product post data */
  TextEditingController _nameController = TextEditingController();
  TextEditingController _warrantyPeriodController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _priceAfterDiscoutnController = TextEditingController();
  bool _isWrranty = false;
  int? _categoryId;
  final String _productImageIdRef = Uuid().v1();
  /* */

  /* category post data*/
  TextEditingController categoryController = TextEditingController();
  List<File> categoryAttachmentsList = [];
  final String _cagtegoryImageIdRef = Uuid().v1();
  /* */
  /*Color post data */
  int _colorLength = 1;
  List<TextEditingController> _colorControllerList = List.generate(1, (index) => TextEditingController());
  /* */
  /* phone detail post data */
  int _detailLength = 1;
  List<TextEditingController> _detailNameControllerList = List.generate(1, (index) => TextEditingController());
  List<TextEditingController> _detailDescControllerList = List.generate(1, (index) => TextEditingController());
  /* */
  /* phone image */
  List<File> productImages = [];
  /* */
  String _categoryName = '';
  MainStore _mainStore = MainStore();
  /*  */

  List<ImageModel> deletedImage = [];

  bool _checkValidation(bool isEdit) {
    bool result = false;
    late bool imagevalidate;
    bool warrantyValidate = true;

    if (!isEdit) {
      imagevalidate = productImages.isNotEmpty;
    } else {
      imagevalidate = productImages.isNotEmpty || widget.productModel!.images.isNotEmpty;
    }
    if (_isWrranty && _warrantyPeriodController.text.isEmpty) {
      warrantyValidate = false;
    }

    if (_nameController.text.isNotEmpty && warrantyValidate && _categoryId != null && _priceController.text.isNotEmpty && _priceAfterDiscoutnController.text.isNotEmpty && imagevalidate) {
      result = true;
    }
    return result;
  }

  void _onInsertCategory() {
    if (categoryController.text.isNotEmpty && categoryAttachmentsList.isNotEmpty) {
      imageService.insertImage(categoryAttachmentsList, _cagtegoryImageIdRef).whenComplete(() {
        Map<String, dynamic> postData = {'name': categoryController.text, 'image_id_ref': _cagtegoryImageIdRef};
        _mainStore.categoriesStore.insetCategory(postData).then((value) {
          if (value == '200') {
            _mainStore.categoriesStore.categoriesList.clear();
            _mainStore.categoriesStore.loadData().whenComplete(() {
              categoryController.text = '';
              categoryAttachmentsList = [];
              _successDialog(false);
              Future.delayed(Duration(seconds: 2)).whenComplete(() {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            });
          } else {
            _errorDialog();
          }
        });
      });
    } else {
      _successDialog(true);
    }
  }

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

  void _successDialog(bool isAlertDialog) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: isAlertDialog ? DialogType.INFO : DialogType.SUCCES,
      borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
      width: MediaQuery.of(context).size.width,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      desc: isAlertDialog ? 'សូមបញ្ចូលរាល់ទិន្នន័យទាំងអស់' : 'បញ្ចូលទិន្នន័យបានជោគជ័យ',
      showCloseIcon: false,
      btnOkOnPress: isAlertDialog ? () {} : null,
    )..show();
  }

  void _getPriceAfterDiscount() {
    String result = '';
    if (_priceController.text != '' && _discountController.text != '') {
      double discountPrice = int.parse(_priceController.text) * (int.parse(_discountController.text) / 100);

      result = (int.parse(_priceController.text) - discountPrice).toString();
    }
    _priceAfterDiscoutnController.text = result;
  }

  void _categoryBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: _categoryBottomSheetBody(),
          );
        });
  }

  void _addCategoryBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: _addCategoryBottomSheetBody(),
          );
        }).whenComplete(() {
      _categoryBottomSheet();
    });
  }

  void _onInsertProduct() {
    if (_checkValidation(false)) {
      Map<String, dynamic> postData = {
        'name': _nameController.text,
        'price': _priceController.text,
        'discount': _discountController.text,
        'price_after_discount': _priceAfterDiscoutnController.text,
        'is_warranty': _isWrranty ? 1 : 0, // 1 is warranty 0 is not warranty
        'warranty_period': _isWrranty ? _warrantyPeriodController.text : 'No Warranty',
        'image_id_ref': _productImageIdRef,
        'category_id': _categoryId,
      };

      Future.delayed(Duration.zero, () async {
        await insertProductService.insertProduct(postData).then((value) {
          Future.delayed(Duration.zero, () async {
            await _onAddColor(value);
            await _onAddDetail(value);
            await _onAddImage(value);
          });
        });
      }).whenComplete(() {
        _successDialog(false);
        AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.SUCCES,
            borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
            width: MediaQuery.of(context).size.width,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            desc: 'ទិន្នន័យបញ្ចូលបានជោគជោយ\n តើអ្នកចង់បញ្ចូលបន្តរ ?',
            showCloseIcon: false,
            btnCancelOnPress: () {
              NavigationHelper.pushReplacement(context, HomeScreen(widget.mainStore));
            },
            btnOkOnPress: () {
              NavigationHelper.pushReplacement(
                  context,
                  AddProductFormScreen(
                    onDispose: () {},
                    mainStore: widget.mainStore,
                    productModel: widget.productModel,
                  ));
            },
            btnCancelText: 'បោះបង់',
            btnOkText: 'បញ្ចូលបន្តរ')
          ..show();
      });
    } else {
      _successDialog(true);
    }
  }

  Future<void> _onAddImage(String phoneId) async {
    await imageService.insertImage(productImages, _productImageIdRef);
  }

  Future<void> _onAddColor(String productId) async {
    for (int i = 0; i < _colorLength; i++) {
      if (_colorControllerList[i].text.isNotEmpty) {
        Map<String, dynamic> postData = {
          'product_id': productId,
          'color': _colorControllerList[i].text,
        };
        await insertProductService.insertProductColor(postData);
      }
    }
  }

  Future<void> _onAddDetail(String productId) async {
    for (int i = 0; i < _detailLength; i++) {
      if (_detailNameControllerList[i].text.isNotEmpty && _detailNameControllerList[i].text.isNotEmpty) {
        Map<String, dynamic> postData = {
          'name': _detailNameControllerList[i].text,
          'descs': _detailNameControllerList[i].text,
          'product_id': productId,
        };
        await insertProductService.insertProductDetail(postData);
      }
    }
  }

  void _onEditInit() {
    if (widget.productModel != null) {
      prefix.ProductModel pModel = widget.productModel!;
      //
      _nameController.text = pModel.name;
      _isWrranty = pModel.isWarranty == 1;
      _warrantyPeriodController.text = _isWrranty ? pModel.warrantyPeriod : '';
      _categoryId = pModel.categoryId;
      _priceController.text = pModel.price.toString();
      _discountController.text = pModel.price.toString();
      _priceAfterDiscoutnController.text = pModel.priceAfterDiscount.toString();
      _categoryId = pModel.categoryId;

      for (var category in _mainStore.categoriesStore.categoriesList) {
        if (category.id == _categoryId) {
          _categoryName = category.name;
          break;
        }
      }

      for (var category in _mainStore.phoneCategoryStore.phoneCategoryModelList) {
        if (category.id == _categoryId) {
          _categoryName = category.name;
          break;
        }
      }
      //
      if (pModel.colors.isNotEmpty) {
        _colorControllerList = List.generate(pModel.colors.length, (index) => TextEditingController());
        _colorLength = pModel.colors.length;
        for (var color in pModel.colors) {
          _colorControllerList[pModel.colors.indexOf(color)].text = color.color;
        }
      }

      if (pModel.detail.isNotEmpty) {
        _detailNameControllerList = List.generate(pModel.detail.length, (index) => TextEditingController());
        _detailDescControllerList = List.generate(pModel.detail.length, (index) => TextEditingController());
        _detailLength = pModel.detail.length;
        for (var detail in pModel.detail) {
          _detailNameControllerList[pModel.detail.indexOf(detail)].text = detail.name;
          _detailDescControllerList[pModel.detail.indexOf(detail)].text = detail.descs;
        }
      }
      //

    }

    setState(() {});
  }

  void _onUpdate() {
    if (deletedImage.isNotEmpty) {
      imageService.deleteImage(deletedImage).whenComplete(() {
        deletedImage.clear();
      });
    }
    if (productImages.isNotEmpty) {
      imageService.insertImage(productImages, widget.productModel!.imageIdRef);
    }
    //

    if (_checkValidation(true)) {
      Map<String, dynamic> postData = {
        'id': widget.productModel!.id,
        'name': _nameController.text,
        'is_warranty': _isWrranty ? 1 : 0, // 1 is warranty 0 is not warranty
        'warranty_period': _isWrranty ? _warrantyPeriodController.text : 'No Warranty',
        'category_id': _categoryId,
        'price': _priceController.text,
        'discount': _discountController.text,
        'price_after_discount': _priceAfterDiscoutnController.text,
      };
      Future.delayed(Duration.zero, () async {
        await insertProductService.updateProduct(postData).then((value) {
          Future.delayed(Duration.zero, () async {
            await _onUpdateColor(widget.productModel!.id.toString());
            await _onUpdateDetail(widget.productModel!.id.toString());
          });
        });
      }).whenComplete(() {
        _successDialog(false);
        Future.delayed(Duration(seconds: 2)).whenComplete(() {
          Future.delayed(Duration.zero, () async {
            await productServices.getProductById(id: widget.productModel!.id.toString()).then((value) {
              if (value != null) {
                widget.onDispose();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return ProductDetail(mainStore: _mainStore, onDispose: () {}, productModel: value);
                }));
              }
            });
          });
        });
      });
    } else {
      _successDialog(true);
    }
  }

  Future<void> _onUpdateColor(String phoneId) async {
    for (int i = 0; i < _colorLength; i++) {
      Map<String, dynamic> postData = {'id': phoneId, 'color': _colorControllerList[i].text};
      await insertProductService.updateProductColor(postData);
    }
  }

  Future<void> _onUpdateDetail(String phoneId) async {
    for (int i = 0; i < _detailLength; i++) {
      Map<String, dynamic> postData = {
        'name': _detailNameControllerList[i].text,
        'descs': _detailDescControllerList[i].text,
        'id': phoneId,
      };
      await insertProductService.updatePorductDetail(postData);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainStore = widget.mainStore;
    _mainStore.categoriesStore.categoriesList.clear();
    _mainStore.categoriesStore.loadData().whenComplete(() {
      _onEditInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Observer(
        builder: (_) {
          return Scaffold(
            body: Material(
              child: SafeArea(
                child: _buildBody(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _appBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _mainInfoWidget(),
                _colorWidget(),
                _detailWidget(),
                _imageWidget(),
                _saveButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _mainInfoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildTextInput('ឈ្មោះផលិតផល', _nameController),
          _buildTextInput('តម្លៃ', _priceController, hasOnChange: true, textInputType: TextInputType.number),
          _buildTextInput('បញ្ចុះតម្លៃ %', _discountController, hasOnChange: true, textInputType: TextInputType.number),
          _buildTextInput('តម្លៃក្រោយបញ្ចុះ', _priceAfterDiscoutnController, hasOnChange: true, textInputType: TextInputType.number),
          _warrantyCheckBox(),
          _isWrranty ? _buildTextInput('រយៈពេលក្នុងការធានា', _warrantyPeriodController) : SizedBox.shrink(),
          _chooseCategoryWidget(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: AnimatedButton(
        pressEvent: widget.productModel == null ? _onInsertProduct : _onUpdate,
        text: 'រក្សាទុក',
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('រូបភាព'),
            FilePickerWidget(
              isPickFromFileExplorer: false,
              count: 10,
              attachments: productImages,
              isMultiSelect: false,
              onChoosingFiles: (files) {
                productImages = files;
              },
            ),
            SizedBox(height: 20),
            widget.productModel != null ? _showImageWidget() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _showImageWidget() {
    List<Widget> colorItemList = [];
    widget.productModel!.images.forEach((element) {
      colorItemList.add(_showImageItem(element.image, widget.productModel!.images.indexOf(element)));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('មាន\t' + widget.productModel!.images.length.toString() + "\tរូបភាព"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(colorItemList.length, (index) {
              return colorItemList[index];
            }),
          ),
        ),
      ],
    );
  }

  Widget _showImageItem(String path, int index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          width: 120,
          height: 120,
          child: CachedNetworkImage(
            cacheManager: CustomCacheManager(),
            fit: BoxFit.fill,
            imageUrl: baseUrl + path,
            errorWidget: (context, imageUrl, error) => Image.asset('assets/images/placeholder.jpg'),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              deletedImage.add(widget.productModel!.images[index]);
              widget.productModel!.images.removeAt(index);
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

  Widget _detailWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Column(
        children: [
          Column(
            children: List.generate(_detailLength, (index) => _detialItem(_detailNameControllerList[index], _detailDescControllerList[index], index)),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _detailLength++;
                  _detailNameControllerList.add(TextEditingController());
                  _detailDescControllerList.add(TextEditingController());
                });
              },
              child: Text('បន្ថែមពត៌មានលម្អិត'))
        ],
      ),
    );
  }

  Widget _detialItem(TextEditingController nameController, TextEditingController descController, int index) {
    return Column(
      children: [
        _devicederLine(index),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextInput('លម្អិតពី', nameController),
                  ),
                  Expanded(
                    child: _buildTextInput('ពិពណ៌នា', descController),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                  onPressed: () {
                    if (_detailLength > 1) {
                      setState(() {
                        _detailLength--;
                        _detailNameControllerList.removeAt(index);
                        _detailDescControllerList.removeAt(index);
                      });
                    }
                  },
                  child: Text('-')),
            )
          ],
        ),
      ],
    );
  }

  Widget _colorWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Column(
        children: [
          Column(
            children: List.generate(_colorLength, (index) => colorItem(_colorControllerList[index], index)),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _colorLength++;
                  _colorControllerList.add(TextEditingController());
                });
              },
              child: Text('បន្ថែមពណ៍'))
        ],
      ),
    );
  }

  Widget colorItem(TextEditingController controller, int index) {
    return Column(
      children: [
        _devicederLine(index),
        Row(
          children: [
            Expanded(
              child: _buildTextInput(
                'ពណ៌ផលិតផល',
                controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                  onPressed: () {
                    if (_colorLength > 1) {
                      setState(() {
                        _colorLength--;
                        _colorControllerList.removeAt(index);
                      });
                    }
                  },
                  child: Text('-')),
            )
          ],
        ),
      ],
    );
  }

  Widget _devicederLine(int index) {
    return index > 0
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: ColorsConts.primaryColor,
          )
        : SizedBox.shrink();
  }

  Widget _chooseCategoryWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.8,
            child: Text(
              'ប្រភេទផលិតផល',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ColorsConts.primaryColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _categoryBottomSheet();
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Text(
                          _categoryName,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(width: _categoryName.isEmpty ? 0 : 10),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _warrantyCheckBox() {
    return Container(
      width: 205,
      child: CheckboxListTile(
        activeColor: ColorsConts.primaryColor,
        checkColor: Colors.white,
        value: _isWrranty,
        onChanged: (val) {
          setState(() {
            _isWrranty = val!;
            if (!_isWrranty) {
              _warrantyPeriodController.text = '';
            }
          });
        },
        title: Text('មានធានា'),
      ),
    );
  }

  Widget _addCategoryBottomSheetBody() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'បន្ថែមប្រភេទផលិតផល',
            style: TextStyle(fontSize: 18, color: ColorsConts.primaryColor),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextInput('ឈ្មោះប្រភេទផលិតផល', categoryController),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text('រូបភាព'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: FilePickerWidget(
                    isPickFromFileExplorer: false,
                    count: 10,
                    attachments: categoryAttachmentsList,
                    isMultiSelect: false,
                    onChoosingFiles: (files) {
                      categoryAttachmentsList = files;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedButton(
                    pressEvent: () {
                      _onInsertCategory();
                    },
                    text: 'បន្ថែម',
                  ),
                )
              ],
            ),
          ))
        ],
      ),
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
            onChanged: (e) {
              if (hasOnChange) {
                _getPriceAfterDiscount();
              }
            },
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
                    onTap: () {
                      Navigator.pop(context);
                      widget.productModel!.images.addAll(deletedImage);
                    },
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
              child: Text('បញ្ជូលផលិតផល', style: TextStyle(color: ColorsConts.primaryColor, fontSize: 22)),
            ),
          ))
        ],
      ),
    );
  }

  Widget _categoryBottomSheetBody() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 6),
            Text(
              'ប្រភេទផលិតផល',
              style: TextStyle(
                fontSize: 18,
                color: ColorsConts.primaryColor,
              ),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addCategoryBottomSheet();
              },
              child: Icon(Icons.add),
              style: TextButton.styleFrom(backgroundColor: Colors.blue.withOpacity(.2)),
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _mainStore.categoriesStore.categoriesList.isNotEmpty
                ? Center(
                    child: Column(
                        children: _mainStore.categoriesStore.categoriesList.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _categoryId = e.id;
                              _categoryName = e.name;
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.2),
                              ),
                              child: Center(
                                child: Text(
                                  e.name,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                        ),
                      );
                    }).toList()),
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
