import 'package:mobx/mobx.dart';
import 'package:tinh/store/department/department_store.dart';
import 'package:tinh/store/product/product_store.dart';
part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  late ProductStore productStore;
  late DepartmentStore departmentStore;

  void init() async {
    productStore = ProductStore();
    departmentStore = DepartmentStore();
  }

  _MainStore() {
    init();
  }
}
