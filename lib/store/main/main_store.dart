import 'package:mobx/mobx.dart';
import 'package:tinh/store/department/department_store.dart';
import 'package:tinh/store/home_screen/home_screen_store.dart';
import 'package:tinh/store/product/product_store.dart';
import 'package:tinh/store/search_filter/search_filter_store.dart';
part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  late ProductStore productStore;
  late DepartmentStore departmentStore;
  late SearchFilterStore searchFilterStore;
  late HomeScreenStore homeScreenStore;
  void init() async {
    productStore = ProductStore();
    departmentStore = DepartmentStore();
    searchFilterStore = SearchFilterStore();
    homeScreenStore = HomeScreenStore();
  }

  _MainStore() {
    init();
  }
}
