import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';

class PhoneProductServices {
  Future<List<PhoneProductModel>> getAllPhone({int pageSize = 10, int pageIndex = 0, required int isNew}) async {
    try {
      Map<String, dynamic> params = {'pageSize': pageSize, 'pageIndex': pageIndex, 'is_new': isNew};
      return await httpApiService.get(HttApi.API_PHONE_PRODUCT, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneProductModel>.from(value.data.map((x) => PhoneProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<PhoneProductModel>> getAllPhoneByBrand({int pageSize = 10, int pageIndex = 0, required int brandId}) async {
    try {
      Map<String, dynamic> params = {'pageSize': pageSize, 'pageIndex': pageIndex, 'brand_id': brandId};
      return await httpApiService.get(HttApi.API_PHONE_BY_BRAND, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneProductModel>.from(value.data.map((x) => PhoneProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<PhoneProductModel>> getAllPhoneByCategory({int pageSize = 10, int pageIndex = 0, required int brandId, required int categoryId, required int isNew}) async {
    try {
      Map<String, dynamic> params = {'is_new': isNew, 'pageSize': pageSize, 'pageIndex': pageIndex, 'brand_id': brandId, 'category_id': categoryId};
      return await httpApiService.get(HttApi.API_PHONE_BY_CATEGORY, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneProductModel>.from(value.data.map((x) => PhoneProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<PhoneProductModel>> searchPhone(String phoneName) async {
    try {
      Map<String, dynamic> params = {
        'phone_name': phoneName,
      };
      return await httpApiService.get(HttApi.API_SEARCH_PHONE, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneProductModel>.from(value.data.map((x) => PhoneProductModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }
}

PhoneProductServices phoneProductServices = PhoneProductServices();
