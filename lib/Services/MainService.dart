import 'dart:io';

abstract class MainService
{
  Future<Map<String, dynamic>> setStatusOnline(String jwt);
  Future<Map<String, dynamic>> setStatusOffline(String jwt);
  Future<Map<String, dynamic>> registerUser(String name, String email, String password, File? profilePhoto);
  Future<Map<String, dynamic>> loginUser(String email, String password);
  Future<Map<String, dynamic>> getUserProfile(String jwt, String userId);
  Future<Map<String, dynamic>> searchUsers(String jwt, String searchText);
  Future<Map<String, dynamic>> createChat(String jwt, String userId);
  Future<Map<String, dynamic>> getChatList(String jwt);
  Future<Map<String, dynamic>> getMessages(String jwt, String chatId);
  Future<Map<String, dynamic>> sendMessage(String jwt, String chatId, String message);
}
