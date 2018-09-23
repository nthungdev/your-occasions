import 'dart:async';

import 'package:postgres/postgres.dart';

final String host = "ec2-54-83-50-145.compute-1.amazonaws.com";
final int port = 5432;
final String databaseName = "dfchidtpalcucu";
final String username = "ejubwoptcfhmle";
final String password = "0caba2030cf2ee29a8fc9ce693fbd05c10bb3efe1492d60124bf329b248b534a";

class BaseController {
  // PROPERTIES //
  String _host;
  int _port;
  String _databaseName;
  String _username;
  String _password;
  PostgreSQLConnection connection;

  // CONSTRUCTORS //
  BaseController() {
    this._host = host;
    this._port = port;
    this._databaseName = databaseName;
    this._username = username;
    this._password = password;
  }

  // METHODS //
  /// Create and open a connection to the server.
  Future<void> connect() async {
    connection = PostgreSQLConnection(host, port, databaseName, username: username, password: password, useSSL: true);
    await connection.open();
  }

  /// Close the connection to the server.
  Future<void> disconnect() async {
    await connection.close();
  }

}