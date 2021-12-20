import 'package:mobx/mobx.dart';
import 'package:tinh/models/department/department_model.dart';
import 'package:tinh/services/deapartment/department_service.dart';

part 'department_store.g.dart';

class DepartmentStore = _DepartmentStore with _$DepartmentStore;

abstract class _DepartmentStore with Store {
  @observable
  bool isShowAllCategory = false;
  @observable
  List<DepartmentModel> departmentList = [];

  @action
  Future<void> loadData() async {
    await departmentService.getDepartments().then((value) {
      for (var brand in value) {
        departmentList.add(brand);
      }
    });
  }

  @action
  void changeCategoryDisplay() {
    isShowAllCategory = !isShowAllCategory;
  }
}
