import 'package:mobx/mobx.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';
import 'package:tinh/store/home_screen/home_screen_store.dart';
import 'package:tinh/store/phone_brand/phone_brand_store.dart';
import 'package:tinh/store/phone_category/phone_category_store.dart';
import 'package:tinh/store/phone_product_store/phone_product_store.dart';
import 'package:tinh/store/product_detail_store/product_detail_store.dart';
import 'package:tinh/store/search_filter/search_filter_store.dart';
import 'package:tinh/store/user/user_store.dart';
import 'package:tinh/store/user_service/user_service_store.dart';
part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  late PhoneProductStore phoneProductStore;
  late SearchFilterStore searchFilterStore;
  late HomeScreenStore homeScreenStore;
  late ProductDetailStore productDetailStore;
  late PhoneBrandStore phoneBrandStore;
  late UserServiceStore userServiceStore;
  late UserStore userStore;
  late PhoneCategoryStore phoneCategoryStore;
  void init() async {
    phoneProductStore = PhoneProductStore();
    searchFilterStore = SearchFilterStore();
    homeScreenStore = HomeScreenStore();
    productDetailStore = ProductDetailStore();
    phoneBrandStore = PhoneBrandStore();
    userServiceStore = UserServiceStore();
    userStore = UserStore();
    phoneCategoryStore = PhoneCategoryStore();
  }

  _MainStore() {
    init();
  }
}
