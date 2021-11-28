import 'package:mobx/mobx.dart';

part 'user_service_store.g.dart';

class UserServiceStore = _UserServiceStore with _$UserServiceStore;

abstract class _UserServiceStore with Store {
  @observable
  bool isMessage = false;

  @action
  void changeMessageToUser(bool isMessageCondition) {
    isMessage = isMessageCondition;
  }
}
