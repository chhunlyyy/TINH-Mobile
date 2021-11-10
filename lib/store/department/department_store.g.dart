// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DepartmentStore on _DepartmetStore, Store {
  final _$observableDepartmentFutureAtom =
      Atom(name: '_DepartmetStore.observableDepartmentFuture');

  @override
  ObservableFuture<List<DepartmentModel>>? get observableDepartmentFuture {
    _$observableDepartmentFutureAtom.reportRead();
    return super.observableDepartmentFuture;
  }

  @override
  set observableDepartmentFuture(
      ObservableFuture<List<DepartmentModel>>? value) {
    _$observableDepartmentFutureAtom
        .reportWrite(value, super.observableDepartmentFuture, () {
      super.observableDepartmentFuture = value;
    });
  }

  final _$isShowAllDepartmentAtom =
      Atom(name: '_DepartmetStore.isShowAllDepartment');

  @override
  bool get isShowAllDepartment {
    _$isShowAllDepartmentAtom.reportRead();
    return super.isShowAllDepartment;
  }

  @override
  set isShowAllDepartment(bool value) {
    _$isShowAllDepartmentAtom.reportWrite(value, super.isShowAllDepartment, () {
      super.isShowAllDepartment = value;
    });
  }

  final _$loadDataAsyncAction = AsyncAction('_DepartmetStore.loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  final _$_DepartmetStoreActionController =
      ActionController(name: '_DepartmetStore');

  @override
  void changeDepartmentDisplay() {
    final _$actionInfo = _$_DepartmetStoreActionController.startAction(
        name: '_DepartmetStore.changeDepartmentDisplay');
    try {
      return super.changeDepartmentDisplay();
    } finally {
      _$_DepartmetStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
observableDepartmentFuture: ${observableDepartmentFuture},
isShowAllDepartment: ${isShowAllDepartment}
    ''';
  }
}
