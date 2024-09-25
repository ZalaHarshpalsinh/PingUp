import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Widgets/UserProfile.dart';
import 'package:pingup/Services/index.dart';
import 'package:pingup/Widgets/index.dart';
import 'package:pingup/models/index.dart';
import 'package:pingup/global.dart';


class UserProfilePage extends StatefulWidget
{
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
{
  final MainService mainService = getIt<MainService>();
  final FlutterSecureStorage _storage = getIt<FlutterSecureStorage>();
  final WebSocketService webSocketService = getIt<WebSocketService>();
  User? _user;

  @override
  void initState() {
    _fetchUserProfile();
    _setupWebSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Fetch user profile from HTTP request
  Future<void> _fetchUserProfile() async {
    try
    {
      String? jwt = await _storage.read(key: 'jwt');
      final response = await mainService.getUserProfile(jwt!, widget.userId);

      if (response['success']) {
        setState(() {
          _user = User.fromJson(response['data']);
        });
      } else {
        // Handle error (e.g., display message)
        print(response['message']);
      }
    }
    catch (error) {
      // Handle error
      print('Error fetching profile: $error');
    }
  }

  // Setup WebSocket connection and listen for "Profile Update" events
  void _setupWebSocket() {
    // Listen for 'Profile Update' event
    webSocketService.socket!.on('Profile Update', (data)
    {
      print("Profile update ${data['name']}");
      User tmp = User.fromJson(data);
      if (tmp.id == widget.userId)
      {
        if(mounted)
          {
            setState(() {
              _user = tmp;
            });
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Center(
        child: CircularProgressIndicator(semanticsLabel: "Fetching profile..."),
      );
    }

    return UserProfile(user: _user!);
  }
}
