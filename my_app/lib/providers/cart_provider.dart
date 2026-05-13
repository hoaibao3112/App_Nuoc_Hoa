import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import '../utils/constants.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      final accessToken = await ApiClient.secureStorage.read(key: 'accessToken');
      if (accessToken == null) {
        _items = [];
        return;
      }
      _items = await _cartService.getCart();
    } catch (e) {
      print('Fetch cart error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(String productId, int quantity) async {
    final success = await _cartService.addToCart(productId, quantity);
    if (success) {
      await fetchCart();
    }
    return success;
  }

  Future<bool> updateQuantity(String itemId, int quantity) async {
    final success = await _cartService.updateQuantity(itemId, quantity);
    if (success) {
      // Optimistic update or just refetch
      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index].quantity = quantity;
        notifyListeners();
      }
    }
    return success;
  }

  Future<bool> removeItem(String itemId) async {
    final success = await _cartService.removeItem(itemId);
    if (success) {
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
    }
    return success;
  }

  Future<bool> clearCart() async {
    final success = await _cartService.clearCart();
    if (success) {
      _items.clear();
      notifyListeners();
    }
    return success;
  }
}
