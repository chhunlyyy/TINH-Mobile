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
  @observable
  ObservableFuture<List<ProductModel>>? observableFutureProduct;
  @action
  Future<void> loadData({required int pageSize, required pageIndex}) async {
    observableFutureProduct = ObservableFuture(productServices.getAllProducts(pageIndex: pageIndex, pageSize: pageSize));
  }

  @action
  Future<void> loadProductByCategory({required int pageSize, required pageIndex, required categoryId}) async {
    await productServices.getAllProductsByCategory(pageIndex: pageIndex, pageSize: pageSize, categoryId: categoryId).then((value) {
      for (var pro in value) {
        productModelList.add(pro);
      }
      isLoading = false;
    });
  }

  @action
  Future<void> search({required String name, required int pageSize, required pageIndex}) async {
    observableFutureProduct = ObservableFuture(productServices.searchProduct(name: name, pageIndex: pageIndex, pageSize: pageSize));
  }
}
