import 'package:tinh/http/http_config.dart';
import 'package:tinh/http/http_get_base_url.dart';
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

  // Setup Interceptor
  // void _setupInterceptors() {
  //   _dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
  //     print("--> RequestOptions:");
  //     print("--> ${options.method} ${options.path}");
  //     print("--> Headers: ${options.headers}");
  //     print("--> Datas: ${options.data}");
  //     print("--> QueryParams: ${options.queryParameters}");
  //     print("--> Content type: ${options.contentType}");
  //     print("<-- END RequestOptions");
  //     return options;
  //   }, onResponse: (Response response) {
  //     print("--> Response:");
  //     print("<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
  //     //String responseAsString = response.data.toString();
  //     print(response.data);
  //     print("<-- END Response HTTP");
  //     return response; // continue
  //   }, onError: (DioError e) {
  //     print("--> Request/Response ERROR:");
  //     // The request was made and the server responded with a status code
  //     // that falls out of the range of 2xx and is also not 304.
  //     if (e.response != null) {
  //       print(e.response.data);
  //       print(e.response.headers);
  //       print(e.response.request);
  //     } else {
  //       // Something happened in setting up or sending the request that triggered an Error
  //       print(e.request);
  //       print(e.message);
  //     }
  //     print("--> End Request/Response ERROR");
  //     return e; //continue
  //   }));
  // }

  String _buildUrl(String endPoint) {
    return httpGetBaseUrl.get + endPoint;
  }
}

HttpApiService httpApiService = new HttpApiService();
