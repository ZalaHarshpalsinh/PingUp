import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Widgets/UserProfile.dart';
import '../Services/index.dart';
import '../models/index.dart';

class UserProfilePage extends StatefulWidget
{
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
{
  final MainService mainService = MainServiceImpl();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> userProfileFetcher() async
  {
      String? jwt = await _storage.read(key: 'jwt');
      return mainService.getUserProfile(jwt!, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userProfileFetcher(),
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.waiting) {
          if(snapshot.hasError){
            return const Text("Something went wrong...!!");
          }
          if(!snapshot.data!['success']){
            return Text(snapshot.data!['message']);
          }

          return UserProfile(user: User.fromJson(snapshot.data!['data']));
        }

        return const Center(child: CircularProgressIndicator(semanticsLabel: "Fetching profile...",));
      },
    );
  }
}
