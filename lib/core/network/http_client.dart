import 'package:dio/dio.dart';
import '../config/api_config.dart';

/// HTTP client wrapper for API requests with interceptors
class HttpClient {
  late final Dio _dio;

  HttpClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.openaiBaseUrl,
        connectTimeout: Duration(seconds: ApiConfig.connectTimeout),
        receiveTimeout: Duration(seconds: ApiConfig.receiveTimeout),
        sendTimeout: Duration(seconds: ApiConfig.sendTimeout),
        contentType: Headers.jsonContentType,
        headers: {
          'Authorization': 'Bearer ${ApiConfig.apiKey}',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_RequestInterceptor());
    _dio.interceptors.add(_ResponseInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());
  }

  Dio get dio => _dio;

  /// Update API key in headers
  void setApiKey(String apiKey) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    ApiConfig.setApiKey(apiKey);
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<T> post<T>(
    String path, {
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> postStream(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          responseType: ResponseType.stream,
        ),
      );
      return response.toString();
    } catch (e) {
      rethrow;
    }
  }
}

class _RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvironmentConfig.enableDebugLogs) {
      print('🚀 REQUEST: ${options.method} ${options.path}');
      print('📦 DATA: ${options.data}');
    }
    handler.next(options);
  }
}

class _ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (EnvironmentConfig.enableDebugLogs) {
      print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    }
    handler.next(response);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message}');
    if (err.response != null) {
      print('   Status: ${err.response?.statusCode}');
      print('   Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}
