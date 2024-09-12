import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Widgets/index.dart';
import 'package:pingup/Services/index.dart';

class Auth extends StatelessWidget {
  Auth({super.key});

  final MainService mainService = MainServiceImpl();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<bool> authenticate() async {
    String? jwt = await secureStorage.read(key: 'jwt');
    print("From auth: $jwt");
    if(jwt == null) return false;

    Map<String, dynamic> response = await mainService.setStatusOnline(jwt);

    return (response["success"] == true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authenticate(),//to do
      builder:(context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting) {
          if (snapshot.data == true) {
            return const MainPage();
          }
          else {
            return const LoginPage();
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}


