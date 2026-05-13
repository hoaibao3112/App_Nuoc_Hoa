import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class Constants {
  // API URL can be provided at build time via --dart-define=API_URL
  // Fallbacks:
  // - If API_URL is set, use it.
  // - For web default to production Render URL.
  // - For mobile/emulator default to emulator host.
  static const _envApiUrl = String.fromEnvironment('API_URL', defaultValue: '');

  static String get apiUrl {
    if (_envApiUrl.isNotEmpty) return _envApiUrl;
    return 'https://app-nuoc-hoa.onrender.com/api';
  }
}

class ApiClient {
  static final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static Future<String?>? _refreshingToken;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Constants.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static Future<String?> _refreshAccessToken() async {
    if (_refreshingToken != null) {
      return _refreshingToken;
    }

    _refreshingToken = () async {
      final refreshToken = await secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) return null;

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: Constants.apiUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      try {
        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newAccessToken = response.data['accessToken'];
          final newRefreshToken = response.data['refreshToken'];

          if (newAccessToken != null) {
            await secureStorage.write(key: 'accessToken', value: newAccessToken);
          }
          if (newRefreshToken != null) {
            await secureStorage.write(key: 'refreshToken', value: newRefreshToken);
          }

          return newAccessToken as String?;
        }
      } catch (_) {
        // Ignore refresh errors and let caller handle cleanup.
      } finally {
        _refreshingToken = null;
      }

      return null;
    }();

    return _refreshingToken;
  }

  static Future<void> init() async {
    // Interceptor tự động gắn token vào header và xử lý cấu trúc response
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Đọc token từ Secure Storage
        final accessToken = await secureStorage.read(key: 'accessToken');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.data != null && response.data['data'] != null) {
          response.data = response.data['data']; // Bóc tách dữ liệu chuẩn từ backend
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final requestOptions = e.requestOptions;

          if (requestOptions.extra['retry'] != true) {
            final newToken = await _refreshAccessToken();
            if (newToken != null) {
              requestOptions.headers['Authorization'] = 'Bearer $newToken';
              requestOptions.extra['retry'] = true;

              try {
                final retryResponse = await dio.fetch(requestOptions);
                handler.resolve(retryResponse);
                return;
              } catch (error) {
                if (error is DioException) {
                  handler.next(error);
                  return;
                }
                handler.next(
                  DioException(requestOptions: requestOptions, error: error),
                );
                return;
              }
            }

            await secureStorage.delete(key: 'accessToken');
            await secureStorage.delete(key: 'refreshToken');
            handler.next(e);
            return;
          }
        }

        debugPrint('--- [API ERROR] ---');
        debugPrint('Path: ${e.requestOptions.path}');
        debugPrint('Method: ${e.requestOptions.method}');
        debugPrint('Status Code: ${e.response?.statusCode}');
        debugPrint('Error Data: ${e.response?.data}');
        debugPrint('Message: ${e.message}');
        debugPrint('-------------------');
        handler.next(e);
      },
    ));
  }
}

