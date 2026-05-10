import '../models/order.dart';
import '../utils/constants.dart';

class OrderService {
  Future<Order?> createOrder() async {
    try {
      final response = await ApiClient.dio.post('/orders');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Order.fromJson(response.data);
      }
    } catch (e) {
      print('Create order error: $e');
    }
    return null;
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await ApiClient.dio.get('/orders');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Order.fromJson(json)).toList();
      }
    } catch (e) {
      print('Get orders error: $e');
    }
    return [];
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await ApiClient.dio.put('/orders/$orderId/cancel');
      return response.statusCode == 200;
    } catch (e) {
      print('Cancel order error: $e');
      return false;
    }
  }
}
