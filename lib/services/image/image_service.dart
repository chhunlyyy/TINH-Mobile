import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tinh/api/api.dart';
import 'package:tinh/http/http_api_service.dart';
import 'package:tinh/http/http_config.dart';
import 'package:path/path.dart';

class ImageService {
  Future<String> insertImage(List<File> files, String imageIdRef) async {
    String result = '';
    Map<String, dynamic> postData = {
      'id_ref': imageIdRef,
    };

    if (files.isNotEmpty) {
      postData['images'] = [];
      for (File file in files) {
        postData['images'] = [];
        postData['images'].add(await MultipartFile.fromFile(file.path, filename: basename(file.path)));
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
}

ImageService imageService = ImageService();
