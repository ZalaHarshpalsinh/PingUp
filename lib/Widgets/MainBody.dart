import 'package:flutter/material.dart';
import 'package:pingup/Widgets/index.dart';

class MainBody extends StatelessWidget
{
  final TabController tabController;
  const MainBody({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        controller: tabController,
        children: [
          ChatListPage(),
          const Text("Groups")],
    );
  }
}
