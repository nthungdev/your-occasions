import 'dart:async';

import 'package:postgres/postgres.dart';
import 'package:youroccasions/utilities/secret.dart';

// final String host = "localhost";
// final int port = 5432;
// final String databaseName = "yo";
// final String username = "postgres";
// final String password = "nimda";

class BaseController {
  // PROPERTIES //
  // String _host;
  // int _port;
  // String _databaseName;
  // String _username;
  // String _password;
  PostgreSQLConnection connection;

  // CONSTRUCTORS //
  BaseController() {
    // this._host = host;
    // this._port = port;
    // this._databaseName = databaseName;
    // this._username = username;
    // this._password = password;
  }

  // METHODS //
  /// Create and open a connection to the server.
  Future<void> connect() async {
    // print(PORT);
    // print(DATABASENAME);
    connection = PostgreSQLConnection(HOST, PORT, DATABASENAME, username: USERNAME, password: PASSWORD, useSSL: true, timeoutInSeconds: 10);
    await connection.open();
  }

  /// Close the connection to the server.
  Future<void> disconnect() async {
    await connection.close();
  }

  /// Try to make connection to the server and do a query.
  Future<bool> testDatabase() async {
    try {
      await connect();
      
      await connection.query("""SELECT * FROM users""",);

      await disconnect();

      return true;
    }
    catch (e) {
      return false;
    }
  }

}