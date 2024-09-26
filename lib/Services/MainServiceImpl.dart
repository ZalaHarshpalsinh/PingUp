import './MainService.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';


class MainServiceImpl implements MainService {

  @override
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/user/$userId"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print("Error: $response.body");
      return json.decode("{}");
    }
  }

  @override
  Future<Map<String, dynamic>> setStatusOnline(String jwt) async {
    final response = await http.post(
        Uri.parse("$baseUrl/setStatusOnline"),
        headers: { 'Authorization': 'Bearer $jwt'}
    );

    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> setStatusOffline(String jwt) async
  {
    final response = await http.post(
        Uri.parse("$baseUrl/setStatusOffline"),
        headers: { 'Authorization': 'Bearer $jwt'}
    );

    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> registerUser (String name, String email, String password, File? profilePhoto) async
  {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/register"), // Replace with your API endpoint
    );

    // Add fields
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;

    // Add profile image if selected
    if(profilePhoto != null)
      request.files.add(await http.MultipartFile.fromPath('profilePhoto', profilePhoto!.path));

    // Sending the request
    var response = await request.send();

    // Check the status code of the response
    return json.decode((await http.Response.fromStream(response)).body);
  }

  @override
  Future<Map<String, dynamic>> loginUser(String email, String password) async{
    final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email' : email,
          'password': password,
        }));

    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(String jwt, String userId) async {
    final response = await http.get(
        Uri.parse("$baseUrl/users/$userId"),
        headers: { 'Authorization': 'Bearer $jwt'}
    );
    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> searchUsers(String jwt, String searchText) async {
    final response = await http.get(Uri.parse("$baseUrl/availableUsers?q=$searchText"),
        headers: { 'Authorization': 'Bearer $jwt'}
    );

    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> createChat(String jwt, String userId) async
  {
      final response = await http.post(
          Uri.parse("$baseUrl/createChat"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt',
          },
          body: json.encode({
            "withUserId": userId
          })
      );
      return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> getChatList(String jwt) async {

    final response = await http.get(Uri.parse("$baseUrl/chats"),
        headers: { 'Authorization': 'Bearer $jwt'}
    );
    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> getMessages(String jwt, String chatId) async {
    final response = await http.get(
        Uri.parse("$baseUrl/chat/$chatId/messages"),
        headers: { 'Authorization': 'Bearer $jwt'}
    );

    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> sendMessage(String jwt, String chatId, String message) async
  {
     final response = await http.post(
       Uri.parse("$baseUrl/chat/$chatId/messages"),
       headers: {
         'Authorization': 'Bearer $jwt',
         'Content-Type': 'application/json'
       },
       body: json.encode({
         "messageText": message
       })
     );

     return json.decode(response.body);
  }
}