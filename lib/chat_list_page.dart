import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Static list of contacts
    final List<Map<String, String>> contacts = [
      {'name': 'abc', 'profile': '../../assets/profile1.png'},
      {'name': 'abc', 'profile': '../../assets/profile1.png'},
      {'name': 'abc', 'profile': '../../assets/profile1.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
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
              Navigator.pushNamed(context, '/chat', arguments: contacts[index]);
            },
          );
        },
      ),
    );
  }
}
