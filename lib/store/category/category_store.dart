import 'package:mobx/mobx.dart';
import 'package:tinh/models/category/category_model.dart';
import 'package:tinh/services/category/category_service.dart';

part 'category_store.g.dart';

class CategoryStore = _CategoryStore with _$CategoryStore;

abstract class _CategoryStore with Store {
  @observable
  bool isShowAllCategory = false;

  @observable
  ObservableFuture<List<CategoryModel>>? observableFutureCategory;
  @action
  Future<void> loadData() async {
    observableFutureCategory = ObservableFuture(categoryService.getAllCategory());
  }

  @action
  void changeCategoryDisplay() {
    isShowAllCategory = !isShowAllCategory;
  }
}
