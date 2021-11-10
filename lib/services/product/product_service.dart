import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/product/product_model.dart';

class ProductServices {
  Future<List<ProductModel>> getAllProducts() async {
    try {
      return await httpApiService.get(HttApi.API_PRODUCTS, null, new Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }
}

ProductServices productServices = ProductServices();
