import 'package:flutter/material.dart';
import 'package:pingup/Widgets/index.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> contacts = [
      {'name': 'abc', 'profile': '../assets/profile1.png'},
      {'name': 'abc', 'profile': '../assets/profile1.png'},
      {'name': 'abc', 'profile': '../assets/profile1.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(contacts[index]['profile']!),
            ),
            title: Text(contacts[index]['name']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(name : contacts[index]['name']! ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
