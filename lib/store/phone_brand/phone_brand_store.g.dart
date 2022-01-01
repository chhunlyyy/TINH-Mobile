// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_brand_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PhoneBrandStore on _PhoneBrandStore, Store {
  final _$isShowAllCategoryAtom =
      Atom(name: '_PhoneBrandStore.isShowAllCategory');

  @override
  bool get isShowAllCategory {
    _$isShowAllCategoryAtom.reportRead();
    return super.isShowAllCategory;
  }

  @override
  set isShowAllCategory(bool value) {
    _$isShowAllCategoryAtom.reportWrite(value, super.isShowAllCategory, () {
      super.isShowAllCategory = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_PhoneBrandStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$phoneBrandListAtom = Atom(name: '_PhoneBrandStore.phoneBrandList');

  @override
  List<PhoneBrandModel> get phoneBrandList {
    _$phoneBrandListAtom.reportRead();
    return super.phoneBrandList;
  }

  @override
  set phoneBrandList(List<PhoneBrandModel> value) {
    _$phoneBrandListAtom.reportWrite(value, super.phoneBrandList, () {
      super.phoneBrandList = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_PhoneBrandStore.loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  final _$insetbrandAsyncAction = AsyncAction('_PhoneBrandStore.insetbrand');

  @override
  Future<String> insetbrand(Map<String, dynamic> postData) {
    return _$insetbrandAsyncAction.run(() => super.insetbrand(postData));
  }

  final _$_PhoneBrandStoreActionController =
      ActionController(name: '_PhoneBrandStore');

  @override
  void changeCategoryDisplay() {
    final _$actionInfo = _$_PhoneBrandStoreActionController.startAction(
        name: '_PhoneBrandStore.changeCategoryDisplay');
    try {
      return super.changeCategoryDisplay();
    } finally {
      _$_PhoneBrandStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isShowAllCategory: ${isShowAllCategory},
isLoading: ${isLoading},
phoneBrandList: ${phoneBrandList}
    ''';
  }
}
