// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserServiceStore on _UserServiceStore, Store {
  final _$isMessageAtom = Atom(name: '_UserServiceStore.isMessage');

  @override
  bool get isMessage {
    _$isMessageAtom.reportRead();
    return super.isMessage;
  }

  @override
  set isMessage(bool value) {
    _$isMessageAtom.reportWrite(value, super.isMessage, () {
      super.isMessage = value;
    });
  }

  final _$_UserServiceStoreActionController =
      ActionController(name: '_UserServiceStore');

  @override
  void changeMessageToUser(bool isMessageCondition) {
    final _$actionInfo = _$_UserServiceStoreActionController.startAction(
        name: '_UserServiceStore.changeMessageToUser');
    try {
      return super.changeMessageToUser(isMessageCondition);
    } finally {
      _$_UserServiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isMessage: ${isMessage}
    ''';
  }
}
