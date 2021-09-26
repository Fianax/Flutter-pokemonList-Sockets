import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus=ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus=>_serverStatus;

  IO.Socket get socket=>_socket;
  Function get emit=>_socket.emit;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    // Dart client
    _socket = IO.io('http://192.168.1.227:3000',<String, dynamic>{
      'transports':['websocket'],
      'autoConnect':true,
    });

    _socket.on('connect',(_) {
      _serverStatus=ServerStatus.online;
      notifyListeners();
    });
    _socket.on('disconnect',(_) {
    _serverStatus=ServerStatus.offline;
        notifyListeners();
    });
  }

}