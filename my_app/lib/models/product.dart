class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;

  Product({
    required this.id, 
    required this.name, 
    required this.price, 
    this.description, 
    this.imageUrl
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
