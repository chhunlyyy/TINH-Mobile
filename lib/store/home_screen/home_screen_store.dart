import 'package:mobx/mobx.dart';

part 'home_screen_store.g.dart';

class HomeScreenStore = _HomeScreenStore with _$HomeScreenStore;

abstract class _HomeScreenStore with Store {
  @observable
  bool isLoading = true;

  @action
  void changeLoading() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      isLoading = false;
    });
  }
}
