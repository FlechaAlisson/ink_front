import 'package:dio/dio.dart';
import 'package:ink_front/core/token_provider.dart';
import 'package:ink_front/shared/others/custom_print.dart';

class DioClient {
  late final Dio _dio;
  final TokenProvider tokenProvider;

  DioClient({
    BaseOptions? options,
    required this.tokenProvider,
  }) {
    _dio = Dio(
      options ??
          BaseOptions(
            baseUrl: "http://10.0.2.2:5001/ink-front-0023/us-central1",
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            contentType: 'application/json',
            responseType: ResponseType.json,
          ),
    );

    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenProvider.getIdToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          final method = options.method.toUpperCase();
          final url = options.uri.toString();

          CustomPrint.call(
            '➡️ $method $url',
            level: LogLevel.info,
          );

          if (options.data != null) {
            CustomPrint.call(
              '📦 Body: ${options.data}',
              level: LogLevel.info,
            );
          }

          if (options.headers.isNotEmpty) {
            CustomPrint.call(
              '🧾 Headers: ${options.headers}',
              level: LogLevel.info,
            );
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final status = response.statusCode;
          final url = response.realUri.toString();

          CustomPrint.call(
            '✅ Response [$status] $url',
            level: LogLevel.info,
          );

          // Loga conteúdo (limitado)
          final body = response.data.toString();
          CustomPrint.call(
            '📨 Data: ${body.length > 500 ? '${body.substring(0, 500)}...' : body}',
            level: LogLevel.info,
          );

          return handler.next(response);
        },
        onError: (error, handler) {
          final request = error.requestOptions;
          final status = error.response?.statusCode;
          final url = request.uri.toString();

          CustomPrint.call(
            '❌ ERROR [$status] ${request.method} $url',
            level: LogLevel.error,
            error: error,
            stackTrace: error.stackTrace,
          );

          if (error.response?.data != null) {
            CustomPrint.call(
              '🧨 Body: ${error.response?.data}',
              level: LogLevel.error,
            );
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
