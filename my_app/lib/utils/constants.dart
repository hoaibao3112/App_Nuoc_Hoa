import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Constants {
  // Thay URL này bằng IP máy thật của bạn nếu chạy trên thiết bị thật (Vd: 192.168.1.x)
  static const String apiUrl = 'http://10.0.2.2:3000/api';
}

class ApiClient {
  static final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Constants.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

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
      onError: (DioException e, handler) {
        // Có thể bổ sung logic auto refresh token ở đây nếu statusCode là 401
        return handler.next(e);
      },
    ));
  }
}

