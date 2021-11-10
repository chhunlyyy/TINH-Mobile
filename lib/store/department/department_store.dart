import 'package:mobx/mobx.dart';
import 'package:tinh/models/deparment/department_model.dart';
import 'package:tinh/services/department/department_service.dart';
part 'department_store.g.dart';

class DepartmentStore = _DepartmetStore with _$DepartmentStore;

abstract class _DepartmetStore with Store {
  @observable
  ObservableFuture<List<DepartmentModel>>? observableDepartmentFuture;

  @observable
  bool isShowAllDepartment = false;

  @action
  Future<void> loadData() async {
    observableDepartmentFuture = ObservableFuture(departmentServices.getDepartmentModel());
  }

  @action
  void changeDepartmentDisplay() {
    isShowAllDepartment = !isShowAllDepartment;
  }
}
