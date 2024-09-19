import 'package:flutter/material.dart';
import '../models/index.dart';
import '../Services/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage>
{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final MainService mainService = MainServiceImpl();
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
    //print("Fetching users...");
    try {
      setState(() {
        isLoading = true;
      });

      final jwt = await _storage.read(key: 'jwt');
      //print(_searchController.text);
      final response = await mainService.searchUsers(jwt!, _searchController.text);

      if (response['success'])
      {
        List<dynamic> data = response['data'];
        //print(data);
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
          //print("error from server");
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        //print(e);
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
      //print(_searchController.text);
      final response = await mainService.createChat(jwt!, user.id);

      if (response['success'])
      {
        Navigator.of(context).pop();
      }
      else
      {
        setState(() {
          hasError = true;
          //print("error from server");
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        //print(e);
        isLoading = false;
      });
    }
  }

  void _showCreateChatDialog(User user) {
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
                _createChat(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePhoto),
            ),
            title: Text(user.name),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // WhatsApp-like color for the button
              ),
              onPressed: () => _showCreateChatDialog(user),
              child: const Text(
                "Create Chat",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
