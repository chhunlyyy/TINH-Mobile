import 'package:mobx/mobx.dart';
import 'package:tinh/screens/product_detail/product_detail.dart';
import 'package:tinh/store/category/category_store.dart';
import 'package:tinh/store/home_screen/home_screen_store.dart';
import 'package:tinh/store/product/product_store.dart';
import 'package:tinh/store/product_detail_store/product_detail_store.dart';
import 'package:tinh/store/search_filter/search_filter_store.dart';
import 'package:tinh/store/user_service/user_service_store.dart';
part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  late ProductStore productStore;
  late SearchFilterStore searchFilterStore;
  late HomeScreenStore homeScreenStore;
  late ProductDetailStore productDetailStore;
  late CategoryStore categoryStore;
  late UserServiceStore userServiceStore;
  void init() async {
    productStore = ProductStore();
    searchFilterStore = SearchFilterStore();
    homeScreenStore = HomeScreenStore();
    productDetailStore = ProductDetailStore();
    categoryStore = CategoryStore();
    userServiceStore = UserServiceStore();
  }

  _MainStore() {
    init();
  }
}
