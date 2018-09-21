import 'package:postgres/postgres.dart';

import 'dart:async';

final String host = "ec2-54-83-50-145.compute-1.amazonaws.com";
final int port = 5432;
final String databaseName = "dfchidtpalcucu";
final String username = "ejubwoptcfhmle";
final String password = "0caba2030cf2ee29a8fc9ce693fbd05c10bb3efe1492d60124bf329b248b534a";

class BaseController {
  String _host;
  int _port;
  String _databaseName;
  String _username;
  String _password;
  PostgreSQLConnection connection;

  BaseController(){
    this._host = host;
    this._port = port;
    this._databaseName = databaseName;
    this._username = username;
    this._password = password;
    connection = PostgreSQLConnection(host, port, databaseName, username: username, password: password);
  }

  Future<void> connect() async {
    await connection.open();
  }

  void disconnect() async {
    await connection.close();
  }

  


  
}