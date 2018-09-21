import 'package:postgres/postgres.dart';

final String host = "ec2-54-83-50-145.compute-1.amazonaws.com";
final int port = 5432;
final String databaseName = "dfchidtpalcucu";
final String username = "ejubwoptcfhmle";
final String password = "0caba2030cf2ee29a8fc9ce693fbd05c10bb3efe1492d60124bf329b248b534a";

void main() async {
  var connection = new PostgreSQLConnection(host, port, databaseName, username: username, password: password, useSSL: true);
  await connection.open();

  print("test");

  List<List<dynamic>> results = await connection.query("SELECT * FROM users");

  print(results);
  // for (int i = 0 ; i < results.length ; ++i){
  //   print(i);
  // }
}

class User {
  int _id;
  String _name;
  String _email;
  String _password;
  DateTime _birthday;
  String _picture;
  bool _isUsed;
  DateTime _creationDate;

  User(this._name, this._email, this._password, this._birthday){
  }

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  DateTime get birthday => _birthday;
  String get picture => _picture;
  bool get isUsed => _isUsed;
  DateTime get creationDate => _creationDate;
}