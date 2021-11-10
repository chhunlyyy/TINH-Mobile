import 'package:mobx/mobx.dart';
part 'search_filter_store.g.dart';

class SearchFilterStore = _SearchFilterStore with _$SearchFilterStore;

abstract class _SearchFilterStore with Store {
  @observable
  int radioValue = 1; // 1 is search by name 2 is search by category

  @action
  void changeRadioValue(int newVal) {
    radioValue = newVal;

    print(radioValue);
  }
}
