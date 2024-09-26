import 'package:flutter/material.dart';
import 'package:pingup/Widgets/index.dart';
import 'package:pingup/Services/index.dart';

void main() {
  setupServiceLocator();
  runApp(PingUp());
}

class PingUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PingUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Auth(),
    );
  }
}
