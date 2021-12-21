// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CategoriesStore on _CategoriesStore, Store {
  final _$categoriesListAtom = Atom(name: '_CategoriesStore.categoriesList');

  @override
  List<CategoriesModel> get categoriesList {
    _$categoriesListAtom.reportRead();
    return super.categoriesList;
  }

  @override
  set categoriesList(List<CategoriesModel> value) {
    _$categoriesListAtom.reportWrite(value, super.categoriesList, () {
      super.categoriesList = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_CategoriesStore.loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  @override
  String toString() {
    return '''
categoriesList: ${categoriesList}
    ''';
  }
}
