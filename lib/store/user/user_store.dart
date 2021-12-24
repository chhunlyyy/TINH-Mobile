import 'package:mobx/mobx.dart';
import 'package:tinh/models/user/user_model.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  @observable
  late UserModel userModel = UserModel();

  @observable
  bool isShopOwner = false;

  @action
  void changeUserStatus(bool shopOwner) {
    isShopOwner = shopOwner;
  }

  @action
  void setUserModel(UserModel model) {
    userModel = model;
  }
}
