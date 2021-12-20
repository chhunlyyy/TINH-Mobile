// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DepartmentStore on _DepartmentStore, Store {
  final _$isShowAllCategoryAtom =
      Atom(name: '_DepartmentStore.isShowAllCategory');

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

  final _$departmentListAtom = Atom(name: '_DepartmentStore.departmentList');

  @override
  List<DepartmentModel> get departmentList {
    _$departmentListAtom.reportRead();
    return super.departmentList;
  }

  @override
  set departmentList(List<DepartmentModel> value) {
    _$departmentListAtom.reportWrite(value, super.departmentList, () {
      super.departmentList = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_DepartmentStore.loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  final _$_DepartmentStoreActionController =
      ActionController(name: '_DepartmentStore');

  @override
  void changeCategoryDisplay() {
    final _$actionInfo = _$_DepartmentStoreActionController.startAction(
        name: '_DepartmentStore.changeCategoryDisplay');
    try {
      return super.changeCategoryDisplay();
    } finally {
      _$_DepartmentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isShowAllCategory: ${isShowAllCategory},
departmentList: ${departmentList}
    ''';
  }
}
