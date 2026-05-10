import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Constants {
  // Thay URL này bằng IP máy thật của bạn nếu chạy trên thiết bị thật (Vd: 192.168.1.x)
  // 10.0.2.2 là địa chỉ localhost của máy tính khi chạy trên Android Emulator
  static const String apiUrl = 'http://10.0.2.2:3000/api';
}

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Constants.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      // Cho phép Dio gửi kèm credentials (cookie)
      extra: {'withCredentials': true}, 
    ),
  );

  static Future<void> initCookieJar() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final PersistCookieJar cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
    
    // Thêm Interceptor để format data giống backend { success, message, data }
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.data != null && response.data['data'] != null) {
          response.data = response.data['data']; // Bóc tách dữ liệu chuẩn từ backend
        }
        return handler.next(response);
      },
    ));
  }
}
