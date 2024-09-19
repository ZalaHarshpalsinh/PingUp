class User {
  final String id;
  final String name;
  final String email;
  final String profilePhoto;
  final String status;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePhoto,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      profilePhoto: json['profilePhoto'],
      status: json['status'],
    );
  }
}
