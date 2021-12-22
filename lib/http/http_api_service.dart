import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinh/http/http_config.dart';
import 'package:dio/dio.dart';

class HttpApiService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: 500000,
    receiveTimeout: 500000,
    headers: HttpConfig.headers,
  ));

  // Singleton Declaration
  static final HttpApiService _instance = HttpApiService._internal();
  factory HttpApiService() {
    return _instance;
  }

  HttpApiService._internal() {
    // _setupInterceptors();
  }

  Dio getDio() => _dio;

  /// Handy method to make http GET request, which is a alias of [Dio.request].
  Future get(String endpoint, Map<String, dynamic>? queryParams, Options options) async {
    //try {
    String urlEndpoint = _buildUrl(endpoint);
    Response response = await _dio.get(urlEndpoint, queryParameters: queryParams, options: options);
    return response;
    // } on DioError catch (e) {
    //   assert(e.response.statusCode == 404);
    // }
  }

  /// Handy method to make http POST request, which is a alias of  [Dio.request].
  Future post(String endpoint, dynamic postData, Map<String, dynamic> queryParams, Options options) async {
    // try {
    String urlEndpoint = _buildUrl(endpoint);
    Response response = await _dio.post(urlEndpoint, data: postData, queryParameters: queryParams, options: options);
    return response;
    //
  }

  /// Handy method to make http PUT request, which is a alias of  [Dio.request].
  Future put(String endpoint, dynamic putData, Map<String, dynamic> queryParams, Options options) async {
    //try {
    String urlEndpoint = _buildUrl(endpoint);
    Response response = await _dio.put(urlEndpoint, data: putData, queryParameters: queryParams, options: options);
    return response;
    // } on DioError catch (e) {
    //   assert(e.response.statusCode == 404);
    // }
  }

  Future patch(String endpoint, dynamic putData, Map<String, dynamic> queryParams, Options options) async {
    //try {
    String urlEndpoint = _buildUrl(endpoint);
    Response response = await _dio.patch(urlEndpoint, data: putData, queryParameters: queryParams, options: options);
    return response;
    // } on DioError catch (e) {
    //   assert(e.response.statusCode == 404);
    // }
  }

  /// Handy method to make http DELETE request, which is a alias of  [Dio.request].
  Future delete(String endpoint, dynamic deleteData, Map<String, dynamic> queryParams, Options options) async {
    //try {
    String urlEndpoint = _buildUrl(endpoint);
    Response response = await _dio.delete(urlEndpoint, data: deleteData, queryParameters: queryParams, options: options);
    return response;
    // } on DioError catch (e) {
    //   print(e.message);
    //   assert(e.response.statusCode == 404);
    // }
  }

  var url = '';
  String _buildUrl(String endPoint) {
    return url + endPoint;
  }

  Future<void> initUrl() async {
    var collection = FirebaseFirestore.instance.collection('BASE-URL');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      url = data['URL'] + '/api';
    }
  }
}

HttpApiService httpApiService = new HttpApiService();
