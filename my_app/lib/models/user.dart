class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? role;
  final String? avatarUrl;
  final String? gender;
  final String? birthDate;
  final int points;
  final String rank;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.avatarUrl,
    this.gender,
    this.birthDate,
    this.points = 0,
    this.rank = 'Bạc',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'],
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      points: json['points'] ?? 0,
      rank: json['rank'] ?? 'Bạc',
    );
  }
}

