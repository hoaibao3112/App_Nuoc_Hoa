import 'cart.dart';
import 'product.dart';

class Order {
  final String id;
  final double totalAmount;
  final String status;
  final List<CartItem> items; // Tái sử dụng model cấu trúc tương tự CartItem cho đơn giản
  final DateTime? createdAt;

  Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.items,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<CartItem> orderItems = itemsList.map((i) => CartItem(
      id: i['id'], 
      product: i['product'] != null ? Product.fromJson(i['product']) : Product(id: '', name: 'Unknown', price: 0), 
      quantity: i['quantity']
    )).toList();

    return Order(
      id: json['id'],
      totalAmount: double.tryParse(json['totalAmount'].toString()) ?? 0.0,
      status: json['status'] ?? 'PENDING',
      items: orderItems,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
