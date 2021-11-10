// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductStore on _ProductStore, Store {
  final _$observableFutureProductAtom =
      Atom(name: '_ProductStore.observableFutureProduct');

  @override
  ObservableFuture<List<ProductModel>>? get observableFutureProduct {
    _$observableFutureProductAtom.reportRead();
    return super.observableFutureProduct;
  }

  @override
  set observableFutureProduct(ObservableFuture<List<ProductModel>>? value) {
    _$observableFutureProductAtom
        .reportWrite(value, super.observableFutureProduct, () {
      super.observableFutureProduct = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_ProductStore.loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  @override
  String toString() {
    return '''
observableFutureProduct: ${observableFutureProduct}
    ''';
  }
}
