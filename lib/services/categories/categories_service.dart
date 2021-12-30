import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/categories/categories_model.dart';

class CategoriesService {
  Future<List<CategoriesModel>> getCategories() async {
    try {
      return await httpApiService.get(HttApi.API_CATEGORIES, null, new Options(headers: HttpConfig.headers)).then((value) {
        return List<CategoriesModel>.from(value.data.map((x) => CategoriesModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> addCategory(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_CATEGORY, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      print(e);
      return '402';
    }
  }
}

CategoriesService categoriesService = CategoriesService();
