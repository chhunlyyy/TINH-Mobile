import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/product/product_model.dart';

class ProductServices {
  Future<List<ProductModel>> getProdcutbyCategory({int pageSize = 10, int pageIndex = 0, required int categoryId}) async {
    try {
      Map<String, dynamic> params = {'pageSize': pageSize, 'pageIndex': pageIndex, 'category_id': categoryId};
      return await httpApiService.get(HttApi.API_PRODUCT_BY_CATEGORY, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ProductModel>> getDiscountProduct({int pageSize = 10, int pageIndex = 0}) async {
    try {
      Map<String, dynamic> params = {'pageSize': pageSize, 'pageIndex': pageIndex};
      return await httpApiService.get(HttApi.API_DISCOUNT_PRODUCT, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ProductModel>> searchProduct({required int pageSize, required int pageIndex, required int categoryId, required String name}) async {
    try {
      Map<String, dynamic> params = {'pageSize': pageSize, 'pageIndex': pageIndex, 'category_id': categoryId, 'name': name};
      return await httpApiService.get(HttApi.API_SEARCH_PRODUCT, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }
}

ProductServices productServices = ProductServices();
