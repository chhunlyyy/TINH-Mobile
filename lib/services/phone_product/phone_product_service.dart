import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:tinh/models/message/message_model.dart';
import 'package:tinh/models/phone_product/phone_product_model.dart';

class PhoneProductServices {
  Future<List<PhoneProductModel>> getAllPhone({int pageSize = 10, int pageIndex = 0, required int isNew}) async {
    try {
      Map<String, dynamic> params = {'pageSize': pageSize, 'pageIndex': pageIndex, 'is_new': isNew};
      return await httpApiService.get(HttApi.API_PHONE_PRODUCT, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneProductModel>.from(value.data.map((x) => PhoneProductModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<PhoneProductModel?> getPhoneById(String id) async {
    try {
      Map<String, dynamic> params = {'id': id};
      return await httpApiService.get(HttApi.API_PHONE_BY_ID, params, new Options(headers: HttpConfig.headers)).then((value) {
        return PhoneProductModel.fromJson(value.data);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<PhoneProductModel>> getDiscountPhone({int pageSize = 10, int pageIndex = 0}) async {
    try {
      Map<String, dynamic> params = {'pageSize': pageSize, 'pageIndex': pageIndex};
      return await httpApiService.get(HttApi.API_DISCOUNT_PHONE, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneProductModel>.from(value.data.map((x) => PhoneProductModel.fromJson(x)));
      });
    } catch (e) {
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
      return [];
    }
  }

  Future<List<PhoneProductModel>> searchPhone({required String phoneName, required int pageSize, required int pageIndex}) async {
    try {
      Map<String, dynamic> params = {
        'phone_name': phoneName,
        'pageSize': pageSize,
        'pageIndex': pageIndex,
      };
      return await httpApiService.get(HttApi.API_SEARCH_PHONE, params, new Options(headers: HttpConfig.headers)).then((value) {
        return List<PhoneProductModel>.from(value.data.map((x) => PhoneProductModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<MessageModel> deletePhone({required String id}) async {
    MessageModel messageModel = MessageModel(message: '', status: '');
    try {
      Map<String, dynamic> params = {'id': id};
      return await httpApiService.post(HttApi.API_DELETE_PHONE_PRODUCT, params, null, new Options(headers: HttpConfig.headers)).then((value) {
        return messageModel = MessageModel.fromJson(value.data[0]);
      });
    } catch (e) {
      messageModel = MessageModel(message: 'មានបញ្ហាក្នុងពេលលុប', status: '402');
    }

    return messageModel;
  }
}

PhoneProductServices phoneProductServices = PhoneProductServices();
