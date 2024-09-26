import 'dart:async';

import 'package:pingup/Services/index.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:pingup/global.dart';

class WebSocketImpl implements WebSocketService
{
  Socket? _socket;
  Socket? get socket => _socket;
  bool _isAuthenticallyConnected = false;

  @override
  void dispose() {
    _isAuthenticallyConnected = false;
    _socket!.disconnect();
    _socket = null;
  }

  @override
  Future<bool> initialize(String jwt) async
  {
    if(!_isAuthenticallyConnected){
      Completer<bool> completer = Completer();

      _socket = io(baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket!.connect();

      _socket!.onConnect((_) {
        print('Connected to WebSocket server');
        _socket!.emit('authenticate', {'jwt': jwt});
      });

      socket!.on('authenticated', (data) {
        if(!completer.isCompleted){
          print('WebSocket authenticated: $data');
          _isAuthenticallyConnected = true;
          completer.complete(true);
        }
      });
      socket!.on('unauthorized', (data) {
        if(!completer.isCompleted){
          print('WebSocket unauthorized: $data');
          dispose();
          completer.complete(false);
        }
      });

      _socket!.onDisconnect((_) {
        print('Disconnected from WebSocket server');
      });

      _socket!.onError((error) {
        if(!completer.isCompleted){
          print('WebSocket error: $error');
          dispose();
          completer.complete(false);
        }
      });

      return completer.future;
    }
    else{
      return true;
    }

  }
}