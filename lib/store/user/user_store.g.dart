// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  final _$userModelAtom = Atom(name: '_UserStore.userModel');

  @override
  UserModel get userModel {
    _$userModelAtom.reportRead();
    return super.userModel;
  }

  @override
  set userModel(UserModel value) {
    _$userModelAtom.reportWrite(value, super.userModel, () {
      super.userModel = value;
    });
  }

  final _$_UserStoreActionController = ActionController(name: '_UserStore');

  @override
  void setUserModel(UserModel model) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setUserModel');
    try {
      return super.setUserModel(model);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userModel: ${userModel}
    ''';
  }
}