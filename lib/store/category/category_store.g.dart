// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CategoryStore on _CategoryStore, Store {
  final _$isShowAllCategoryAtom =
      Atom(name: '_CategoryStore.isShowAllCategory');

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

  final _$observableFutureCategoryAtom =
      Atom(name: '_CategoryStore.observableFutureCategory');

  @override
  ObservableFuture<List<CategoryModel>>? get observableFutureCategory {
    _$observableFutureCategoryAtom.reportRead();
    return super.observableFutureCategory;
  }

  @override
  set observableFutureCategory(ObservableFuture<List<CategoryModel>>? value) {
    _$observableFutureCategoryAtom
        .reportWrite(value, super.observableFutureCategory, () {
      super.observableFutureCategory = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_CategoryStore.loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  @override
  String toString() {
    return '''
isShowAllCategory: ${isShowAllCategory},
observableFutureCategory: ${observableFutureCategory}
    ''';
  }
}
