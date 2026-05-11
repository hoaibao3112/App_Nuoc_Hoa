import 'package:dio/dio.dart';
import '../models/address.dart';
import '../utils/constants.dart';

class AddressService {
  Future<List<Address>> getAddresses() async {
    try {
      final response = await ApiClient.dio.get('${Constants.apiUrl}/addresses');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Address.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Lỗi tải danh sách địa chỉ: $e');
      return [];
    }
  }

  Future<Address?> addAddress(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post('${Constants.apiUrl}/addresses', data: data);
      if (response.statusCode == 201) {
        return Address.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Lỗi thêm địa chỉ: $e');
      return null;
    }
  }

  Future<bool> updateAddress(String id, Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.patch('${Constants.apiUrl}/addresses/$id', data: data);
      return response.statusCode == 200;
    } catch (e) {
      print('Lỗi cập nhật địa chỉ: $e');
      return false;
    }
  }

  Future<bool> deleteAddress(String id) async {
    try {
      final response = await ApiClient.dio.delete('${Constants.apiUrl}/addresses/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Lỗi xoá địa chỉ: $e');
      return false;
    }
  }
}
