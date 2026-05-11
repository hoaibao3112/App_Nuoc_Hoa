class Address {
  final String id;
  final String userId;
  final String title;
  final String receiverName;
  final String phone;
  final String address;
  final bool isDefault;

  Address({
    required this.id,
    required this.userId,
    required this.title,
    required this.receiverName,
    required this.phone,
    required this.address,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      receiverName: json['receiverName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'receiverName': receiverName,
      'phone': phone,
      'address': address,
      'isDefault': isDefault,
    };
  }
}
