import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Services/index.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator()
{
  getIt.registerSingleton<MainService>(MainServiceImpl());
  getIt.registerSingleton<WebSocketService>(WebSocketImpl());
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
}