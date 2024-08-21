import 'package:flutter/material.dart';
import 'package:pingup/Widgets/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {

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
    );
  }
}
