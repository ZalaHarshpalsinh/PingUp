import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Widgets/index.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({super.key});

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Future<void> logout(BuildContext context) async
  {
    await _storage.delete(key: 'jwt');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context){
          return Auth();
        })
    );
  }

  Map<String, VoidCallback> _menuOptions(BuildContext context) {
    return {
      'Profile': () => {},
      'Logout': () => logout(context),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(-100, 10),
      builder: (BuildContext context, MenuController controller, Widget? child){
        return IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white,),
          tooltip: 'Menu',
          onPressed: () {
            if(controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: _menuOptions(context).keys.map((String option){
        return MenuItemButton(
          onPressed: _menuOptions(context)[option],
          child: SizedBox(
            width: 100,
            child: Text(option),
          ) ,
        );
      }
      ).toList(),
    );
  }
}
