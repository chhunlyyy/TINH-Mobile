import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/message/message_model.dart';

class CartServices {
  Future<MessageModel> addToCart(Map<String, dynamic> postData) async {
    try {
      return await httpApiService.post(HttApi.API_CART_ADD, postData, {}, new Options(headers: HttpConfig.headers)).then((value) {
        return MessageModel.fromJson(value.data[0]);
      });
    } catch (e) {
      return MessageModel(message: 'សូមអភ័យទោស មានបញ្ហាក្នុងការដាក់ទំនិញចូលក្នុងរទេះ', status: '500');
    }
  }
}

CartServices cartServices = CartServices();
