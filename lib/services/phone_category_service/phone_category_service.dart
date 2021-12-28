import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/phone_category/phone_category_model.dart';

class PhoneCategoryService {
  Future<List<PhoneCategoryModel>> getPhoneCategory() async {
    try {
      return await httpApiService.get(HttApi.API_PHONE_CATEGORY, null, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneCategoryModel>.from(value.data.map((x) => PhoneCategoryModel.fromJson(x)));
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> addPhoneCategory(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PHONE_CATEGORY, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      print(e);
      return '402';
    }
  }
}

PhoneCategoryService phoneCategoryService = PhoneCategoryService();
