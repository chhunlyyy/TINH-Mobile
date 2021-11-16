import 'package:mobx/mobx.dart';

part 'product_detail_store.g.dart';

class ProductDetailStore = _ProductDetailStore with _$ProductDetailStore;

abstract class _ProductDetailStore with Store {
  @observable
  int productPageCount = 1;
  @observable
  int colorIndex = -1;

  @action
  void changeProductPageCount(int pageIndex) {
    productPageCount = pageIndex + 1;
  }

  @action
  void checkColor(int colorIndex) {
    colorIndex = colorIndex;
  }
}
