import 'package:google_sign_in/google_sign_in.dart';
import '../utils/constants.dart';
import '../models/user.dart';
import 'dart:convert';

class GoogleSignInService {
  // Dùng Web Client ID cho serverClientId để có thể lấy được idToken gửi lên Backend
  static const String _serverClientId =
      '384701986163-10tp1gf4rveo2ur6recc93ff6vvc1d04.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _serverClientId,
    scopes: ['email', 'profile'],
  );

  /// Đăng nhập bằng Google và trả về {user, accessToken, refreshToken}
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // 1. Mở giao diện chọn tài khoản Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User hủy đăng nhập

      // 2. Lấy authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Không lấy được Google ID Token');
      }

      // 3. Gửi idToken lên Backend để xác thực và nhận JWT
      final response = await ApiClient.dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Google Sign-In Error Detail: $e');
      rethrow;
    }
  }

  /// Đăng xuất khỏi Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Google Sign-Out error: $e');
    }
  }

  /// Kiểm tra xem user đã đăng nhập Google chưa
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
