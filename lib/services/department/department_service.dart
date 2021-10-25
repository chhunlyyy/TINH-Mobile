import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/deparment/department_model.dart';
import 'package:dio/dio.dart';

class DepartmentServices {
  Future<List<DepartmentModel>> getDepartmentModel() async {
    try {
      return await httpApiService.get(HttApi.API_DEPARTMENT, null, new Options(headers: HttpConfig.headers)).then((value) {
        return List<DepartmentModel>.from(value.data.map((x) => DepartmentModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }
}

DepartmentServices departmentServices = DepartmentServices();
