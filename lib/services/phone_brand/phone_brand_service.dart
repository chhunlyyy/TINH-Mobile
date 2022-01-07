import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/phone_brand/phone_brand_model.dart';

class PhoneBrandService {
  Future<List<PhoneBrandModel>> getAllPhoneBrand() async {
    try {
      return await httpApiService.get(HttApi.API_PHONE_BRAND, null, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneBrandModel>.from(value.data.map((x) => PhoneBrandModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<String> addPhonebrand(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PHONE_BRAND, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> updatePhonebrand(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_UPDATE_PHONE_BRAND, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '402';
    }
  }
}

PhoneBrandService phoneBrandService = PhoneBrandService();
