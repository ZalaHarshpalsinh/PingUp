import './MainService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TmpMainService implements MainService
{
  final String baseUrl = "http://localhost:5000";

  @override
  Future<List<Map<String, dynamic>>> getChatList(String userId) async
  {
    final response = await http.get(Uri.parse("$baseUrl/user/$userId/chats"));
    if( response.statusCode == 200)
    {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    else{
      print("Error: $response.body");
      return json.decode("{}");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMessages(String senderId, String receiverId) async {
    final response = await http.get(Uri.parse("$baseUrl/messages/$senderId/$receiverId"));
    if( response.statusCode == 200)
    {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    else{
      print("Error: $response.body");
      return json.decode("{}");
    }
  }

  @override
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/user/$userId"));
    if( response.statusCode == 200)
    {
      return json.decode(response.body);
    }
    else{
      print("Error: $response.body");
      return json.decode("{}");
    }
  }

  @override
  void sendMessage(String senderId, String receiverId, String message) async {
    final response = await http.post(
        Uri.parse("$baseUrl/message"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender': senderId,
          'receiver': receiverId,
          'message': message,
        }) );
    if( response.statusCode != 200)
    {
      print("Error: $response.body");
    }
  }
  
}