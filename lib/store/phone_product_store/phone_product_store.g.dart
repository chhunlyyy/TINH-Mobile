// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_product_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PhoneProductStore on _PhoneProductStore, Store {
  final _$isLoadingAtom = Atom(name: '_PhoneProductStore.isLoading');

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

  final _$phoneProductModelListAtom =
      Atom(name: '_PhoneProductStore.phoneProductModelList');

  @override
  List<PhoneProductModel> get phoneProductModelList {
    _$phoneProductModelListAtom.reportRead();
    return super.phoneProductModelList;
  }

  @override
  set phoneProductModelList(List<PhoneProductModel> value) {
    _$phoneProductModelListAtom.reportWrite(value, super.phoneProductModelList,
        () {
      super.phoneProductModelList = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_PhoneProductStore.loadData');

  @override
  Future<void> loadData({required int pageSize, required dynamic pageIndex}) {
    return _$loadDataAsyncAction
        .run(() => super.loadData(pageSize: pageSize, pageIndex: pageIndex));
  }

  final _$loadPhoneByBrandAsyncAction =
      AsyncAction('_PhoneProductStore.loadPhoneByBrand');

  @override
  Future<void> loadPhoneByBrand(
      {required int pageSize,
      required dynamic pageIndex,
      required dynamic brandId}) {
    return _$loadPhoneByBrandAsyncAction.run(() => super.loadPhoneByBrand(
        pageSize: pageSize, pageIndex: pageIndex, brandId: brandId));
  }

  final _$searchAsyncAction = AsyncAction('_PhoneProductStore.search');

  @override
  Future<void> search({required String phoneName}) {
    return _$searchAsyncAction.run(() => super.search(phoneName: phoneName));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
phoneProductModelList: ${phoneProductModelList}
    ''';
  }
}