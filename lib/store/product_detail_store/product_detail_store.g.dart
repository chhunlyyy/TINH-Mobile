// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductDetailStore on _ProductDetailStore, Store {
  final _$productPageCountAtom =
      Atom(name: '_ProductDetailStore.productPageCount');

  @override
  int get productPageCount {
    _$productPageCountAtom.reportRead();
    return super.productPageCount;
  }

  @override
  set productPageCount(int value) {
    _$productPageCountAtom.reportWrite(value, super.productPageCount, () {
      super.productPageCount = value;
    });
  }

  final _$_ProductDetailStoreActionController =
      ActionController(name: '_ProductDetailStore');

  @override
  void changeProductPageCount(int pageIndex) {
    final _$actionInfo = _$_ProductDetailStoreActionController.startAction(
        name: '_ProductDetailStore.changeProductPageCount');
    try {
      return super.changeProductPageCount(pageIndex);
    } finally {
      _$_ProductDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
productPageCount: ${productPageCount}
    ''';
  }
}
