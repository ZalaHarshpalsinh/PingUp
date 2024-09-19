import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Widgets/UserProfile.dart';
import '../Services/index.dart';
import '../models/index.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../global.dart';

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
  User? _user;
  IO.Socket? _socket;

  @override
  void initState() {
    _fetchUserProfile();
    _setupWebSocket();
    super.initState();
  }

  @override
  void dispose() {
    _socket?.disconnect();
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
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.connect();

    _socket?.onConnect((_) {
      print('WebSocket connected');
    });

    // Listen for 'Profile Update' event
    _socket?.on('Profile Update:${widget.userId}', (data)
    {
      User tmp = User.fromJson(data);
      if (tmp.id == widget.userId) {
        setState(() {
          _user = tmp;
        });
      }
    });

    _socket?.onDisconnect((_) {
      print('WebSocket disconnected');
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
