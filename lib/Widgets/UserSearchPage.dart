import 'package:flutter/material.dart';
import '../models/index.dart';
import '../Services/index.dart';
import '../Widgets/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage>
{
  final FlutterSecureStorage _storage = getIt<FlutterSecureStorage>();
  final MainService mainService = getIt<MainService>();
  final TextEditingController _searchController = TextEditingController();
  List<User> users = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_fetchUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async
  {

    try {
      setState(() {
        isLoading = true;
      });

      final jwt = await _storage.read(key: 'jwt');

      final response = await mainService.searchUsers(jwt!, _searchController.text);

      if (response['success'])
      {
        List<dynamic> data = response['data'];
        setState(() {
          users = data.map((json) => User.fromJson(json)).toList();
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
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _createChat(User user) async
  {
    try {
      setState(() {
        isLoading = true;
      });

      final jwt = await _storage.read(key: 'jwt');

      final response = await mainService.createChat(jwt!, user.id);

      if (response['success'])
      {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context)=>
            const MainPage()
          )
        );
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
        hasError = true;
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: Theme.of(context).primaryColor, // WhatsApp-like color
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text('Failed to load users.'))
          : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return CreateChatCard(user: user, onCreateChat: _createChat);
            },
          ),
    );
  }
}
