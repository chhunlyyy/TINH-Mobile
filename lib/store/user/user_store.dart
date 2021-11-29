import 'dart:ffi';

import 'package:mobx/mobx.dart';
import 'package:tinh/models/user/user_model.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  @observable
  late UserModel userModel = UserModel();

  @action
  void setUserModel(UserModel model) {
    userModel = model;
  }
}
