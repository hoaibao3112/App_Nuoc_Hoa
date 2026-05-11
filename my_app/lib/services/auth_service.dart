import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Lưu token vào SecureStorage
        final accessToken = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];
        if (accessToken != null) await ApiClient.secureStorage.write(key: 'accessToken', value: accessToken);
        if (refreshToken != null) await ApiClient.secureStorage.write(key: 'refreshToken', value: refreshToken);

        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  Future<User?> register(String email, String password, String fullName, String phone) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      print('Register error: $e');
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      await ApiClient.dio.post('/auth/logout');
      // Xoá token khỏi SecureStorage
      await ApiClient.secureStorage.delete(key: 'accessToken');
      await ApiClient.secureStorage.delete(key: 'refreshToken');
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<User?> getProfile() async {
    try {
      final response = await ApiClient.dio.get('/auth/profile');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      print('Get profile error: $e');
    }
    return null;
  }

  Future<bool> refreshToken() async {
    try {
      final oldRefresh = await ApiClient.secureStorage.read(key: 'refreshToken');
      if (oldRefresh == null) return false;

      final response = await ApiClient.dio.post('/auth/refresh', data: {'refreshToken': oldRefresh});
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        if (newAccessToken != null) await ApiClient.secureStorage.write(key: 'accessToken', value: newAccessToken);
        if (newRefreshToken != null) await ApiClient.secureStorage.write(key: 'refreshToken', value: newRefreshToken);
        return true;
      }
    } catch (e) {
      print('Refresh token error: $e');
    }
    return false;
  }

  Future<User?> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.patch('/users/me', data: data);
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      print('Update profile error: $e');
    }
    return null;
  }
}


