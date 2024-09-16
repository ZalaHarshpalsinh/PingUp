import 'package:flutter/material.dart';
import '../Widgets/index.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget
{
  final TabController tabController;
  const MainAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('PingUp',
        style: TextStyle(
            color: Colors.white
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: (){}, color: Colors.white,),
        PopupMenu(),
      ],
      bottom: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        controller: tabController,
        tabs: const [
          Tab(text: "Chats",),
          Tab(text: 'Groups',),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

