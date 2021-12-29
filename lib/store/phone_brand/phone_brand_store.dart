import 'package:mobx/mobx.dart';
import 'package:tinh/models/phone_brand/phone_brand_model.dart';
import 'package:tinh/services/phone_brand/phone_brand_service.dart';

part 'phone_brand_store.g.dart';

class PhoneBrandStore = _PhoneBrandStore with _$PhoneBrandStore;

abstract class _PhoneBrandStore with Store {
  @observable
  bool isShowAllCategory = false;
  @observable
  bool isLoading = true;

  @observable
  List<PhoneBrandModel> phoneBrandList = [];

  @action
  Future<void> loadData() async {
    await phoneBrandService.getAllPhoneBrand().then((value) {
      for (var brand in value) {
        phoneBrandList.add(brand);
      }
      isLoading = false;
    });
  }

  @action
  void changeCategoryDisplay() {
    isShowAllCategory = !isShowAllCategory;
  }

  @action
  Future<String> insetbrand(Map<String, dynamic> postData) async {
    String status = '';
    await phoneBrandService.addPhonebrand(postData).then((value) {
      status = value;
    });

    return status;
  }
}
