import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pingup/Services/index.dart';
import 'package:pingup/models/index.dart';
import 'package:pingup/Widgets/index.dart';

class CreateChatCard extends StatelessWidget
{
  User user;
  final Future<void> Function(User user) onCreateChat;
  CreateChatCard({super.key, required this.user, required this.onCreateChat});

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final MainService mainService = MainServiceImpl();

  void _showCreateChatDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create Chat with ${user.name}"),
          content: const Text("Do you want to create a chat?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                onCreateChat(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(user.profilePhoto),
      ),
      title: Text(user.name, style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text(user.email, style: const TextStyle(fontSize: 13),),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(userId: user.id),
          ),
        );
      },
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor, // WhatsApp-like color for the button
        ),
        onPressed: () => _showCreateChatDialog(context, user),
        child: const Text( "Create Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
