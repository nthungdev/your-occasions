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
  // Properties
  int _id;
  String _name;
  String _email;
  String _password;
  DateTime _birthday;
  String _picture;
  bool _isUsed;
  DateTime _creationDate;

  // Constructors
  User(this._name, this._email, this._password, this._birthday);
  User.create();
  User.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      name = item['name'];
      email = item['email'];
      password = item['password'];
      birthday = item['birthday'];
      picture = item['picture'];
      isUsed = item['is_used'];
      creationDate = item['creation_date'];
    });
  }

  // Getters
  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  DateTime get birthday => _birthday;
  String get picture => _picture;
  bool get isUsed => _isUsed;
  DateTime get creationDate => _creationDate;

  // Setters
  set id(int id) => _id = id;
  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  set birthday(DateTime birthday) => _birthday = birthday;
  set picture(String picture) => _picture = picture;
  set isUsed(bool isUsed) => _isUsed = isUsed;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // Methods
  void printInfo() {
    String info = """
    ID: ${id.toString()}
    Name: $name
    Email: $email
    Password: $password
    Birthday: $birthday
    Picture: $picture
    IsUsed: $isUsed
    Creation Date: $creationDate
    """;

    print(info);
  }

}