import 'package:mobx/mobx.dart';
import 'package:tinh/models/categories/categories_model.dart';
import 'package:tinh/services/categories/categories_service.dart';

part 'categories_store.g.dart';

class CategoriesStore = _CategoriesStore with _$CategoriesStore;

abstract class _CategoriesStore with Store {
  @observable
  List<CategoriesModel> categoriesList = [];

  @action
  Future<void> loadData() async {
    await categoriesService.getCategories().then((value) {
      categoriesList.addAll(value);
    });
  }

  @action
  Future<String> insetCategory(Map<String, dynamic> postData) async {
    String status = '';
    await categoriesService.addCategory(postData).then((value) {
      status = value;
    });

    return status;
  }
}
