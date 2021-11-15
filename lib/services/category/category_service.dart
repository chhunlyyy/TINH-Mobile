import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/category/category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> getAllCategory() async {
    try {
      return await httpApiService.get(HttApi.API_CATEGORY, null, new Options(headers: HttpConfig.headers)).then((value) {
        return List<CategoryModel>.from(value.data.map((x) => CategoryModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }
}

CategoryService categoryService = CategoryService();
