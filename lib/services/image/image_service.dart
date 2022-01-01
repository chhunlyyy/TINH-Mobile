import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:path/path.dart';
import 'package:tinh/models/message/message_model.dart';

class ImageService {
  Future<String> insertImage(List<File> files, String imageIdRef) async {
    String result = '';
    Map<String, dynamic> postData = {
      'id_ref': imageIdRef,
    };

    if (files.isNotEmpty) {
      for (File file in files) {
        postData['images'] = await MultipartFile.fromFile(file.path, filename: basename(file.path));
        try {
          return await httpApiService.post(HttApi.API_INSERT_IMAGE, FormData.fromMap(postData), null, new Options(headers: HttpConfig.headers)).then((value) {
            result = value.data[0]['status'];

            return result;
          });
        } catch (e) {
          print(e);
          result = '402';
        }
      }
    }

    return result;
  }

  Future<MessageModel> deleteImage(List<String> pathList, String imageIdRef) async {
    MessageModel messageModel = MessageModel(message: '', status: '');
    Map<String, dynamic> postData = {
      'id_ref': imageIdRef,
    };

    if (pathList.isNotEmpty) {
      for (String path in pathList) {
        postData['path'] = path;
        try {
          return await httpApiService.post(HttApi.API_DELETE_IMAGE, postData, null, new Options(headers: HttpConfig.headers)).then((value) {
            messageModel = value.data;

            return messageModel;
          });
        } catch (e) {
          print(e);
          messageModel = MessageModel(message: 'មានបញ្ហាក្នុងពេលលុប', status: '402');
        }
      }
    }

    return messageModel;
  }
}

ImageService imageService = ImageService();
