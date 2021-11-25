import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';

class UserServices {
  Future<String> checkUserToken(String token) async {
    String status = '';
    try {
      Map<String, dynamic> params = {'token': token};
      return await httpApiService.get(HttApi.API_USER_CHECK_TOKEN, params, new Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'].toString();
      });
    } catch (e) {
      status = '500';
    }
    return status;
  }
}

UserServices userServices = UserServices();
