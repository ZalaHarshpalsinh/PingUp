import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:pingup/Widgets/index.dart';
import 'package:pingup/Services/index.dart';
import 'package:pingup/global.dart';
import 'package:pingup/models/index.dart';

class ChatListPage extends StatefulWidget
{
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final FlutterSecureStorage _storage = getIt<FlutterSecureStorage>();
  final MainService mainService = getIt<MainService>();

  List<Chat> chats = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> _fetchInitialChats() async
  {
    try {
      setState(() {
        isLoading = true;
      });

      final jwt = await _storage.read(key: 'jwt');

      final response = await mainService.getChatList(jwt!);

      if (response['success'])
      {
        print(response['data']);
        List<dynamic> data = response['data'];
        setState(() {
          chats = data.map((json) => Chat.fromJson(json)).toList();
          isLoading = false;
          hasError = false;
        });
      }
      else
      {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        print("Client error: ${e}");
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchInitialChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text('Failed to load chats.'))
          : ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            Chat chat = chats[index];
            return ChatCard(chat:chat);
          },
      ),
    );
  }
}
