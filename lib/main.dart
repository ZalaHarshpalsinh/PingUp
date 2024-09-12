import 'package:flutter/material.dart';
import 'package:pingup/Widgets/index.dart';

void main() {
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
