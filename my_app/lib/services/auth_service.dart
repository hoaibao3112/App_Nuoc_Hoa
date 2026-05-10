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
}
