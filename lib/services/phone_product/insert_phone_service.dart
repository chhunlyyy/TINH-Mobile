import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';

class InsertPhoneService {
  Future<String> insertColor(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PHONE_COLOR, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      print(e);
      return '402';
    }
  }

  Future<String> insertPhoneStorage(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PHONE_STORAGE, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      print(e);
      return '402';
    }
  }

  Future<String> insertPhoneDetail(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PHONE_DETAIL, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      print(e);
      return '402';
    }
  }

  Future<String> insertPhoneProduct(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_INSERT_PHONE_PRODUCT, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['productId'].toString();
      });
    } catch (e) {
      print(e);
      return '402';
    }
  }
}

InsertPhoneService insertPhoneService = InsertPhoneService();
