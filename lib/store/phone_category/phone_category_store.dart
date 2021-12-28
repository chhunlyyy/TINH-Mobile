import 'package:mobx/mobx.dart';
import 'package:tinh/models/phone_category/phone_category_model.dart';
import 'package:tinh/services/phone_category_service/phone_category_service.dart';

part 'phone_category_store.g.dart';

class PhoneCategoryStore = _PhoneCategoryStore with _$PhoneCategoryStore;

abstract class _PhoneCategoryStore with Store {
  @observable
  List<PhoneCategoryModel> phoneCategoryModelList = [PhoneCategoryModel(id: 0, name: 'All Products', imageIdRef: '', images: [])];

  @action
  Future<void> loadData() async {
    await phoneCategoryService.getPhoneCategory().then((value) {
      phoneCategoryModelList.addAll(value);
    });
  }

  @action
  Future<String> insetCategory(Map<String, dynamic> postData) async {
    String status = '';
    await phoneCategoryService.addPhoneCategory(postData).then((value) {
      status = value;
    });

    return status;
  }
}
