// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_category_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PhoneCategoryStore on _PhoneCategoryStore, Store {
  final _$phoneCategoryModelListAtom =
      Atom(name: '_PhoneCategoryStore.phoneCategoryModelList');

  @override
  List<PhoneCategoryModel> get phoneCategoryModelList {
    _$phoneCategoryModelListAtom.reportRead();
    return super.phoneCategoryModelList;
  }

  @override
  set phoneCategoryModelList(List<PhoneCategoryModel> value) {
    _$phoneCategoryModelListAtom
        .reportWrite(value, super.phoneCategoryModelList, () {
      super.phoneCategoryModelList = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_PhoneCategoryStore.loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  @override
  String toString() {
    return '''
phoneCategoryModelList: ${phoneCategoryModelList}
    ''';
  }
}
