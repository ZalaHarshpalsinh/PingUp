import 'package:socket_io_client/socket_io_client.dart';

abstract class WebSocketService
{
  Socket? _socket;
  Socket? get socket => _socket;
  bool _isAuthenticallyConnected = false;

  Future<bool> initialize(String jwt);
  void dispose();
}