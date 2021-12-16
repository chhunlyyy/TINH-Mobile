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
      print(e);
      return [];
    }
  }
}

PhoneBrandService phoneBrandService = PhoneBrandService();
