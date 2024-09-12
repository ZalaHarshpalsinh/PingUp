import 'package:flutter/material.dart';
import '../Widgets/index.dart';


class ChatCard extends StatelessWidget
{
  final String friendId;
  final String name;
  final String email;
  final String profilePhotoUrl;

  const ChatCard({super.key, required this.friendId, required this.name, required this.email, required this.profilePhotoUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(profilePhotoUrl),
      ),
      title: Text(name, style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text(email, style: const TextStyle(fontSize: 13),),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(personId: friendId, personName:  name ),
          ),
        );
      },
    );
  }
}
