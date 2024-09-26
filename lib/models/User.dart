// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String profilePhoto;
//   final String status;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profilePhoto,
//     required this.status,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       name: json['name'],
//       email: json['email'],
//       profilePhoto: json['profilePhoto'],
//       status: json['status'],
//     );
//   }
// }

class User {
  String _id;
  String _name;
  String _email;
  String _profilePhoto;
  String _status;

  User({
    required String id,
    required String name,
    required String email,
    required String profilePhoto,
    required String status,
  })  : _id = id,
        _name = name,
        _email = email,
        _profilePhoto = profilePhoto,
        _status = status;

  // Getters
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get profilePhoto => _profilePhoto;
  String get status => _status;

  // Setters
  set id(String value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set profilePhoto(String value) {
    _profilePhoto = value;
  }

  set status(String value) {
    if (value == 'Online' || value == 'Offline') {
      _status = value;
    } else {
      throw ArgumentError('Invalid status value');
    }
  }

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
