import '../models/cart.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class CartService {
  Future<List<CartItem>> getCart() async {
    try {
      final response = await ApiClient.dio.get('/cart');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Chú ý: Backend hiện tại trả về cấu trúc tuỳ thuộc entity (giả định có trường id, quantity, product)
        return data.map((json) => CartItem(
          id: json['id'],
          product: Product.fromJson(json['product']),
          quantity: json['quantity']
        )).toList();
      }
    } catch (e) {
      print('Get cart error: $e');
    }
    return [];
  }

  Future<bool> addToCart(String productId, int quantity) async {
    try {
      final response = await ApiClient.dio.post(
        '/cart/add',
        data: {'productId': productId, 'quantity': quantity},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Add to cart error: $e');
      return false;
    }
  }
  Future<bool> updateQuantity(String itemId, int quantity) async {
    try {
      final response = await ApiClient.dio.put(
        '/cart/update/$itemId',
        data: {'quantity': quantity},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Update cart quantity error: $e');
      return false;
    }
  }

  Future<bool> removeItem(String itemId) async {
    try {
      final response = await ApiClient.dio.delete('/cart/remove/$itemId');
      return response.statusCode == 200;
    } catch (e) {
      print('Remove cart item error: $e');
      return false;
    }
  }

  Future<bool> clearCart() async {
    try {
      final response = await ApiClient.dio.delete('/cart/clear');
      return response.statusCode == 200;
    } catch (e) {
      print('Clear cart error: $e');
      return false;
    }
  }
}

