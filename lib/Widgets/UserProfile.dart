import 'package:flutter/material.dart';
import '../models/index.dart';

class UserProfile extends StatelessWidget {

  final User user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User profile photo
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user.profilePhoto),
            ),
            const SizedBox(height: 20),

            // User name
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // User email
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Online/Offline Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  user.status == 'Online' ? Icons.circle : Icons.circle_outlined,
                  color: user.status == 'Online' ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Text(
                  user.status,
                  style: TextStyle(
                    fontSize: 16,
                    color: user.status == 'Online' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
