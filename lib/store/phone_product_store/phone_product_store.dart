import 'package:mobx/mobx.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';
import 'package:tinh/services/phone_product/phone_product_service.dart';
part 'phone_product_store.g.dart';

class PhoneProductStore = _PhoneProductStore with _$PhoneProductStore;

abstract class _PhoneProductStore with Store {
  @observable
  bool isLoading = true;
  @observable
  List<PhoneProductModel> phoneProductModelList = [];

  @action
  Future<void> loadData({required int pageSize, required pageIndex}) async {
    await phoneProductServices.getAllPhone(pageIndex: pageIndex, pageSize: pageSize).then((value) {
      for (var pro in value) {
        phoneProductModelList.add(pro);
      }
      isLoading = false;
    });
  }

  @action
  Future<void> loadPhoneByBrand({required int pageSize, required pageIndex, required brandId}) async {
    if (phoneProductModelList.isEmpty) {
      isLoading = true;
    }
    await phoneProductServices.getAllPhoneByBrand(pageIndex: pageIndex, pageSize: pageSize, brandId: brandId).then((value) {
      for (var pro in value) {
        phoneProductModelList.add(pro);
      }
      isLoading = false;
    });
  }

  @action
  Future<void> search({required String phoneName}) async {
    if (phoneProductModelList.isEmpty) {
      isLoading = true;
    }
    await phoneProductServices.searchPhone(phoneName).then((value) {
      for (var pro in value) {
        phoneProductModelList.add(pro);
      }
      isLoading = false;
    });
  }
}