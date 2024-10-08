import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pingup/Widgets/index.dart';
import 'package:pingup/Services/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: MainAppBar(tabController: _tabController),
        body: MainBody(tabController: _tabController),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor, // WhatsApp-like color
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserSearchPage()),
            );
          },
          child: const Icon(Icons.message, color: Colors.white), // WhatsApp-like icon
        ),
    );
  }
}
