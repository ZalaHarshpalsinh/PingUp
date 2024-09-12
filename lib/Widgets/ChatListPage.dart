import 'package:flutter/material.dart';
import '../Widgets/index.dart';
import '../Services/index.dart';
import '../global.dart';

class ChatListPage extends StatelessWidget
{
  final MainService mainService = MainServiceImpl();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: mainService.getChatList(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats available.'));
          } else {
            final chatList = snapshot.data!;
            return ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return ChatCard(friendId: chat['_id'], name: chat['name'], email: chat["email"], profilePhotoUrl: chat['profilePhotoUrl']);
              },
            );
          }
        },
      ),
    );
  }
}
