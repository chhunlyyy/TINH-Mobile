import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';

class InsertProductService {
  Future<String> insertProductDetail(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PRODUCT_DETAIL, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> insertProductColor(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PRODUCT_COLOR, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> insertProduct(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PRODUCT, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['productId'].toString();
      });
    } catch (e) {
      return '402';
    }
  }

  //
  Future<String> updateProduct(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_UPDATE_PRODCUT, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> updatePorductDetail(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_UPDATE_PRODUCT_DETAIL, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> updateProductColor(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_UPDATE_PRODUCT_COLOR, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '402';
    }
  }
}

InsertProductService insertProductService = InsertProductService();
