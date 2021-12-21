import 'package:mobx/mobx.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/services/product/product_service.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStore with _$ProductStore;

abstract class _ProductStore with Store {
  @observable
  bool isLoading = true;
  @observable
  List<ProductModel> productModelList = [];

  @action
  Future<void> loadData({required int categoryId, required int pageSize, required pageIndex}) async {
    if (productModelList.isEmpty) {
      isLoading = true;
    }
    await productServices.getProdcutbyCategory(categoryId: categoryId, pageIndex: pageIndex, pageSize: pageSize).then((value) {
      for (var product in value) {
        productModelList.add(product);
      }
    }).whenComplete(() {
      isLoading = false;
    });
  }

  @action
  Future<void> searchProduct({required int categoryId, required int pageSize, required pageIndex, required String name}) async {
    if (productModelList.isEmpty) {
      isLoading = true;
    }
    await productServices.searchProduct(categoryId: categoryId, pageIndex: pageIndex, pageSize: pageSize, name: name).then((value) {
      for (var product in value) {
        productModelList.add(product);
      }
    }).whenComplete(() {
      isLoading = false;
    });
  }
}
