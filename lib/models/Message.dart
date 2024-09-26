// import 'package:pingup/models/index.dart';
//
// class Message
// {
//   final String id;
//   final String message;
//   final String senderId;
//
//   Message({required this.id, required this.message, required this.senderId});
//
//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['_id'],
//       message: json['message'],
//       senderId: json['sender'],
//     );
//   }
// }

class Message {
  String _id;
  String _message;
  String _senderId;

  Message({
    required String id,
    required String message,
    required String senderId,
  })  : _id = id,
        _message = message,
        _senderId = senderId;

  // Getters
  String get id => _id;
  String get message => _message;
  String get senderId => _senderId;

  // Setters
  set id(String value) {
    _id = value;
  }

  set message(String value) {
    _message = value;
  }

  set senderId(String value) {
    _senderId = value;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],  // Assign ID from JSON
      message: json['message'],
      senderId: json['sender'],
    );
  }
}
