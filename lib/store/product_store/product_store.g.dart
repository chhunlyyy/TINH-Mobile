// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductStore on _ProductStore, Store {
  final _$isLoadingAtom = Atom(name: '_ProductStore.isLoading');

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

  final _$productModelListAtom = Atom(name: '_ProductStore.productModelList');

  @override
  List<ProductModel> get productModelList {
    _$productModelListAtom.reportRead();
    return super.productModelList;
  }

  @override
  set productModelList(List<ProductModel> value) {
    _$productModelListAtom.reportWrite(value, super.productModelList, () {
      super.productModelList = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_ProductStore.loadData');

  @override
  Future<void> loadData(
      {required int categoryId,
      required int pageSize,
      required dynamic pageIndex}) {
    return _$loadDataAsyncAction.run(() => super.loadData(
        categoryId: categoryId, pageSize: pageSize, pageIndex: pageIndex));
  }

  final _$searchProductAsyncAction = AsyncAction('_ProductStore.searchProduct');

  @override
  Future<void> searchProduct(
      {required int categoryId,
      required int pageSize,
      required dynamic pageIndex,
      required String name}) {
    return _$searchProductAsyncAction.run(() => super.searchProduct(
        categoryId: categoryId,
        pageSize: pageSize,
        pageIndex: pageIndex,
        name: name));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
productModelList: ${productModelList}
    ''';
  }
}
