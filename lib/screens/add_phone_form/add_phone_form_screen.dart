import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/file_picker_widget.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/screens/home_screen/home_screen.dart';
import 'package:tinh/services/image/image_service.dart';
import 'package:tinh/services/phone_product/insert_phone_service.dart';
import 'package:tinh/store/main/main_store.dart';
import 'package:uuid/uuid.dart';

class AddPhoneFormScreen extends StatefulWidget {
  final MainStore mainStore;
  const AddPhoneFormScreen({Key? key, required this.mainStore}) : super(key: key);

  @override
  _AddPhoneFormScreenState createState() => _AddPhoneFormScreenState();
}

class _AddPhoneFormScreenState extends State<AddPhoneFormScreen> {
  /* Phone Product Post Data */
  TextEditingController _nameController = TextEditingController();
  bool _isWrranty = false;
  bool _isNew = false;
  final String _phoneImageIdRef = Uuid().v1();
  TextEditingController _warrantyPeriodController = TextEditingController();
  int? _categoryId;
  int? _brandId;
  String? _phoneImage;
  /* */
  /* Phone  Category Post Data */
  TextEditingController _phoneCategoryController = TextEditingController();
  final String _cagtegoryImageIdRef = Uuid().v1();
  String? _categoryImage;
  /* */
  /* Phone  brand Post Data */
  TextEditingController _phoneBrandController = TextEditingController();
  final String _brandImageIdRef = Uuid().v1();
  String? _brandImage;
  /* */
  /* phone color post data */
  int _colorLength = 1;
  List<TextEditingController> _colorControllerList = List.generate(1, (index) => TextEditingController());
  /* */
  /* phone storage post data */
  int _storageLength = 1;
  List<TextEditingController> _storageControllerList = List.generate(1, (index) => TextEditingController());
  List<TextEditingController> _priceControllerList = List.generate(1, (index) => TextEditingController());
  List<TextEditingController> _discountControllerList = List.generate(1, (index) => TextEditingController());
  List<TextEditingController> _priceAfterDiscountControllerList = List.generate(1, (index) => TextEditingController());
  /* */
  /* phone detail post data */
  int _detailLength = 1;
  List<TextEditingController> _detailNameControllerList = List.generate(1, (index) => TextEditingController());
  List<TextEditingController> _detailDescControllerList = List.generate(1, (index) => TextEditingController());
  /* */
  /* phone image */
  List<File> phoneImage = [];
  /* */

  String _categoryName = '';
  String _brandName = '';
  MainStore _mainStore = MainStore();
  List<File> categoryAttachmentsList = [];
  List<File> brandAttachmentsList = [];

  bool _checkValidation() {
    bool result = false;

    bool warrantyValidate = true;
    if (_isWrranty && _warrantyPeriodController.text.isEmpty) {
      warrantyValidate = false;
    }

    if (_nameController.text.isNotEmpty &&
        warrantyValidate &&
        _categoryId != null &&
        _brandId != null &&
        _colorControllerList[0].text.isNotEmpty &&
        _storageControllerList[0].text.isNotEmpty &&
        _priceControllerList[0].text.isNotEmpty &&
        _priceAfterDiscountControllerList[0].text.isNotEmpty &&
        _detailNameControllerList[0].text.isNotEmpty &&
        _detailDescControllerList[0].text.isNotEmpty &&
        phoneImage.isNotEmpty) {
      result = true;
    }
    return result;
  }

  void _getPriceAfterDiscount(int index) {
    String result = '';
    if (_priceControllerList[index].text != '' && _discountControllerList[index].text != '') {
      double discountPrice = int.parse(_priceControllerList[index].text) * (int.parse(_discountControllerList[index].text) / 100);

      result = (int.parse(_priceControllerList[index].text) - discountPrice).toString();
    }
    _priceAfterDiscountControllerList[index].text = result;
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

  void _onInsertbrand() {
    if (_phoneBrandController.text.isNotEmpty) {
      imageService.insertImage(brandAttachmentsList, _brandImageIdRef).whenComplete(() {
        Map<String, dynamic> postData = {'name': _phoneBrandController.text, 'image_id_ref': _brandImageIdRef};
        _mainStore.phoneBrandStore.insetbrand(postData).then((value) {
          if (value == '200') {
            _mainStore.phoneBrandStore.phoneBrandList.clear();
            _mainStore.phoneBrandStore.loadData().whenComplete(() {
              _phoneBrandController.text = '';
              brandAttachmentsList = [];
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

  void _onInsertCategory() {
    if (_phoneCategoryController.text.isNotEmpty && categoryAttachmentsList.isNotEmpty) {
      imageService.insertImage(categoryAttachmentsList, _cagtegoryImageIdRef).whenComplete(() {
        Map<String, dynamic> postData = {'name': _phoneCategoryController.text, 'image_id_ref': _cagtegoryImageIdRef};
        _mainStore.phoneCategoryStore.insetCategory(postData).then((value) {
          if (value == '200') {
            _mainStore.phoneCategoryStore.phoneCategoryModelList.clear();
            _mainStore.phoneCategoryStore.loadData().whenComplete(() {
              _phoneCategoryController.text = '';
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

  void _addBottomSheet(bool isCategory) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: _addBottomSheetBody(isCategory),
          );
        }).whenComplete(() {
      _bottomSheet(isCategory);
    });
  }

  void _bottomSheet(bool isCategory) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: isCategory ? _categoryBottomSheetBody() : _brandBottomSheetBody(),
          );
        });
  }

  Future<void> _onAddColor(String phoneId) async {
    for (int i = 0; i < _colorLength; i++) {
      Map<String, dynamic> postData = {'phone_id': phoneId, 'color': _colorControllerList[i].text};
      await insertPhoneService.insertColor(postData);
    }
  }

  Future<void> _onAddDetail(String phoneId) async {
    for (int i = 0; i < _detailLength; i++) {
      Map<String, dynamic> postData = {
        'name': _detailNameControllerList[i].text,
        'descs': _detailDescControllerList[i].text,
        'phone_id': phoneId,
      };
      await insertPhoneService.insertPhoneDetail(postData);
    }
  }

  Future<void> _onAddStorage(String phoneId) async {
    for (int i = 0; i < _storageLength; i++) {
      Map<String, dynamic> postData = {
        'phone_id': phoneId,
        'storage': _storageControllerList[i].text,
        'price': _priceControllerList[i].text,
        'discount': _discountControllerList[i].text,
        'price_after_discount': _priceAfterDiscountControllerList[i].text,
      };
      await insertPhoneService.insertPhoneStorage(postData);
    }
  }

  Future<void> _onAddImage(String phoneId) async {
    await imageService.insertImage(phoneImage, _phoneImageIdRef);
  }

  void _onInsertPhone() {
    if (_checkValidation()) {
      Map<String, dynamic> postData = {
        'name': _nameController.text,
        'is_warranty': _isWrranty ? 1 : 0, // 1 is warranty 0 is not warranty
        'warranty_period': _isWrranty ? _warrantyPeriodController.text : 'No Warranty',
        'image_id_ref': _phoneImageIdRef,
        'category_id': _categoryId,
        'brand_id': _brandId,
        'is_new': _isNew ? 1 : 0,
      };
      Future.delayed(Duration.zero, () async {
        await insertPhoneService.insertPhoneProduct(postData).then((value) {
          Future.delayed(Duration.zero, () async {
            await _onAddColor(value);
            await _onAddDetail(value);
            await _onAddStorage(value);
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
              NavigationHelper.pushReplacement(context, AddPhoneFormScreen(mainStore: widget.mainStore));
            },
            btnCancelText: 'បោះបង់',
            btnOkText: 'បញ្ចូលបន្តរ')
          ..show();
      });
    } else {
      _successDialog(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainStore = widget.mainStore;
    _mainStore.phoneCategoryStore.phoneCategoryModelList.clear();
    _mainStore.phoneCategoryStore.loadData();
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
                _storageWidget(),
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
                    onTap: () => NavigationHelper.pushReplacement(context, HomeScreen(widget.mainStore)),
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
              child: Text('បញ្ជូលទូរស័ព្ទ', style: TextStyle(color: ColorsConts.primaryColor, fontSize: 22)),
            ),
          ))
        ],
      ),
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: AnimatedButton(
        pressEvent: () {
          _onInsertPhone();
        },
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
              attachments: phoneImage,
              isMultiSelect: false,
              onChoosingFiles: (files) {
                phoneImage = files;
              },
            ),
          ],
        ),
      ),
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

  Widget _storageWidget() {
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
            children: List.generate(
                _storageLength, (index) => storageItem(_storageControllerList[index], _priceControllerList[index], _discountControllerList[index], _priceAfterDiscountControllerList[index], index)),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _storageLength++;
                  _storageControllerList.add(TextEditingController());
                  _priceControllerList.add(TextEditingController());
                  _discountControllerList.add(TextEditingController());
                  _priceAfterDiscountControllerList.add(TextEditingController());
                });
              },
              child: Text('បន្ថែមទំហំនិងតម្លៃ'))
        ],
      ),
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

  Widget storageItem(
      TextEditingController storageController, TextEditingController priceController, TextEditingController discountController, TextEditingController priceAfterDiscountController, int index) {
    return Column(
      children: [
        _devicederLine(index),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTextInput('ទំហំទូរស័ព្ទ', storageController)),
                      Expanded(child: _buildTextInput('តម្លៃទូរស័ព្ទ', priceController, hasOnChange: true, index: index, textInputType: TextInputType.number)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildTextInput('បញ្ចុះតម្លៃ %', discountController, hasOnChange: true, index: index, textInputType: TextInputType.number)),
                      Expanded(child: _buildTextInput('តម្លៃក្រោយបញ្ចុះ', priceAfterDiscountController, textInputType: TextInputType.number)),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                  onPressed: () {
                    if (_storageLength > 1) {
                      setState(() {
                        _storageLength--;
                        _priceAfterDiscountControllerList.removeAt(index);
                        _discountControllerList.removeAt(index);
                        _storageControllerList.removeAt(index);
                        _priceControllerList.removeAt(index);
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

  Widget colorItem(TextEditingController controller, int index) {
    return Column(
      children: [
        _devicederLine(index),
        Row(
          children: [
            Expanded(
              child: _buildTextInput(
                'ពណ៌ទូរស័ព្ទ',
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

  Widget _addBottomSheetBody(bool isCategory) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            isCategory ? 'បន្ថែមប្រភេទទូរស័ព្ទ' : 'បន្ថែមម៉ាក់ទូរស័ព្ទ',
            style: TextStyle(fontSize: 18, color: ColorsConts.primaryColor),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isCategory ? _buildTextInput('ឈ្មោះប្រភេទទូរស័ព្ទ', _phoneCategoryController) : _buildTextInput('ឈ្មោះម៉ាក់ទូរស័ព្ទ', _phoneBrandController),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text('រូបភាព'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: FilePickerWidget(
                    isPickFromFileExplorer: false,
                    count: 10,
                    attachments: isCategory ? categoryAttachmentsList : brandAttachmentsList,
                    isMultiSelect: false,
                    onChoosingFiles: (files) {
                      if (isCategory) {
                        categoryAttachmentsList = files;
                      } else {
                        brandAttachmentsList = files;
                      }
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
                      if (isCategory) {
                        _onInsertCategory();
                      } else {
                        _onInsertbrand();
                      }
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
          _buildTextInput('ឈ្មោះទូរស័ព្ទ', _nameController),
          _warrantyCheckBox(),
          _isWrranty ? _buildTextInput('រយៈពេលក្នុងការធានា', _warrantyPeriodController) : SizedBox.shrink(),
          _buildMainInforChooseWidget(true),
          SizedBox(height: 10),
          _buildMainInforChooseWidget(false),
          _isNewCheckBox(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _brandBottomSheetBody() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 6),
            Text(
              'ម៉ាក់ទូរស័ព្ទ',
              style: TextStyle(
                fontSize: 18,
                color: ColorsConts.primaryColor,
              ),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addBottomSheet(false);
              },
              child: Icon(Icons.add),
              style: TextButton.styleFrom(backgroundColor: Colors.blue.withOpacity(.2)),
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _mainStore.phoneBrandStore.phoneBrandList.isNotEmpty
                ? Center(
                    child: Column(
                        children: _mainStore.phoneBrandStore.phoneBrandList.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _brandId = e.id;
                              _brandName = e.name;
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.2),
                                borderRadius: BorderRadius.circular(5),
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

  Widget _categoryBottomSheetBody() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 6),
            Text(
              'ប្រភេទទូរស័ព្ទ',
              style: TextStyle(
                fontSize: 18,
                color: ColorsConts.primaryColor,
              ),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addBottomSheet(true);
              },
              child: Icon(Icons.add),
              style: TextButton.styleFrom(backgroundColor: Colors.blue.withOpacity(.2)),
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _mainStore.phoneCategoryStore.phoneCategoryModelList.isNotEmpty
                ? Center(
                    child: Column(
                        children: _mainStore.phoneCategoryStore.phoneCategoryModelList.map((e) {
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

  Widget _isNewCheckBox() {
    return Container(
      width: 205,
      child: CheckboxListTile(
        activeColor: ColorsConts.primaryColor,
        checkColor: Colors.white,
        value: _isNew,
        onChanged: (val) {
          setState(() {
            _isNew = val!;
          });
        },
        title: Text('ជាទូរស័ព្ទថ្មី'),
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

  Widget _buildMainInforChooseWidget(bool isCategory) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.8,
            child: Text(
              isCategory ? 'ប្រភេទទូរស័ព្ទ' : 'ម៉ាក់ទូរស័ព្ទ',
              style: TextStyle(fontSize: 15),
            ),
          ),
          // SizedBox(
          //   width: isCategory ? 60 : 77,
          // ),
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
                    _bottomSheet(isCategory);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Text(
                          isCategory ? _categoryName : _brandName,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        isCategory ? SizedBox(width: _categoryName.isEmpty ? 0 : 10) : SizedBox(width: _brandName.isEmpty ? 0 : 10),
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
                _getPriceAfterDiscount(index);
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
}
