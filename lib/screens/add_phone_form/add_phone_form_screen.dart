import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/file_picker_widget.dart';
import 'package:tinh/helper/widget_helper.dart';
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
  /* Phone  Category Post Data */
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
  /* phone storage post data */
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
          return Material(
            child: SafeArea(
              child: _buildBody(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        WidgetHelper.appBar(context, 'បញ្ជូលទូរស័ព្ទ'),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: AnimatedButton(
        pressEvent: () {},
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
                      Expanded(child: _buildTextInput('តម្លៃទូរស័ព្ទ', priceController)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildTextInput('បញ្ចុះតម្លៃ %', discountController)),
                      Expanded(child: _buildTextInput('តម្លៃក្រោយបញ្ចុះ', priceAfterDiscountController)),
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
                    pressEvent: () {},
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
        SingleChildScrollView(
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
          Text(
            isCategory ? 'ប្រភេទទូរស័ព្ទ' : 'ម៉ាក់ទូរស័ព្ទ',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            width: isCategory ? 60 : 77,
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

  Widget _buildTextInput(String label, TextEditingController textEditingController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(10),
          child: TextFormField(
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
