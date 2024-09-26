import 'package:pingup/models/index.dart';

// class Chat
// {
//   final String id;
//   final List<User> participants;
//   final Message? lastMessage;
//   final int unseenCount;
//
//   Chat({
//     required this.id,
//     required this.participants,
//     required this.lastMessage,
//     required this.unseenCount,
//   });
//
//   factory Chat.fromJson(Map<String, dynamic> json) {
//     List<dynamic> usersJson = json['participants'];
//     List<User> participants = usersJson.map((json)=>User.fromJson(json)).toList();
//
//     Message? lastMessage = json['last_msg'] != null
//         ? Message.fromJson(json['last_msg'])
//         : null;
//
//     return Chat(
//       id: json['_id'],
//       participants: participants,
//       lastMessage: lastMessage,
//       unseenCount: json['unseenMessagesCount'],
//     );
//   }
// }

class Chat {
  String _id;
  List<User> _participants;
  Message? _lastMessage;
  int _unseenCount;

  Chat({
    required String id,
    required List<User> participants,
    Message? lastMessage,
    required int unseenCount,
  })  : _id = id,
        _participants = participants,
        _lastMessage = lastMessage,
        _unseenCount = unseenCount;

  // Getters
  String get id => _id;
  List<User> get participants => _participants;
  Message? get lastMessage => _lastMessage;
  int get unseenCount => _unseenCount;

  // Setters
  set id(String value) {
    _id = value;
  }

  set participants(List<User> value) {
    _participants = value;
  }

  set lastMessage(Message? value) {
    _lastMessage = value;
  }

  set unseenCount(int value) {
    if (value >= 0) {
      _unseenCount = value;
    } else {
      throw ArgumentError('Unseen count cannot be negative');
    }
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    List<dynamic> usersJson = json['participants'];
    List<User> participants = usersJson.map((json) => User.fromJson(json)).toList();

    Message? lastMessage = json['last_msg'] != null
        ? Message.fromJson(json['last_msg'])
        : null;

    return Chat(
      id: json['_id'], // Assign ID from JSON
      participants: participants,
      lastMessage: lastMessage,
      unseenCount: json['unseenMessagesCount'],
    );
  }
}
