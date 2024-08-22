abstract class MainService
{
  Future<Map<String, dynamic>> getUserDetails(String userId);
  Future<List<Map<String, dynamic>>> getChatList(String userId);
  Future<List<Map<String, dynamic>>> getMessages(String senderId, String receiverId);
  Future<void> sendMessage(String senderId, String receiverId, String message);
}