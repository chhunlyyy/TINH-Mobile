import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/message/message_model.dart';
import 'package:tinh/models/user/user_model.dart';
import 'package:tinh/store/main/main_store.dart';

class UserServices {
  Future<String> checkUserToken(String token, MainStore mainStore) async {
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

  // Future<MessageModel> registerAccount(Map<String, dynamic> postData) async {
  //   try {
  //     return await httpApiService.post(HttApi.API_USER_REGISTER, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
  //       return MessageModel.fromJson(value.data[0]);
  //     });
  //   } catch (e) {
  //     return MessageModel(message: 'សូមអភ័យទោស មានបញ្ហាក្នុងការបង្កើតគណនី', status: '500');
  //   }
  // }

  Future<dynamic> login(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_USER_LOGIN, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        if (value.data[0]['status'] != '200') {
          return MessageModel.fromJson(value.data[0]);
        } else {
          MainStore mainStore = MainStore();
          mainStore.userStore.changeUserStatus(true);
          return MessageModel(status: '200', message: 'success');
        }
      });
    } catch (e) {
      return MessageModel(message: 'សូមអភ័យទោស មានបញ្ហាក្នុងការចូលប្រើ', status: '500');
    }
  }

  Future<dynamic> logOut(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_USER_LOGOUT, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        if (value.data[0]['status'] != '200') {
          return MessageModel.fromJson(value.data[0]);
        } else {
          return MessageModel(status: '200', message: 'success');
        }
      });
    } catch (e) {
      return MessageModel(message: 'សូមអភ័យទោស មានបញ្ហាក្នុងការចាកចេញ', status: '500');
    }
  }
}

UserServices userServices = UserServices();
