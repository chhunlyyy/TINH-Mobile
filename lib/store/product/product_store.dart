import 'package:mobx/mobx.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/services/product/product_service.dart';
part 'product_store.g.dart';

class ProductStore = _ProductStore with _$ProductStore;

abstract class _ProductStore with Store {
  @observable
  ObservableFuture<List<ProductModel>>? observableFutureProduct;
  @action
  Future<void> loadData() async {
    observableFutureProduct = ObservableFuture(productServices.getAllProducts());
  }
}
