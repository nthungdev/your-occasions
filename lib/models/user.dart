class User {
  // PROPERTIES //
  int _id;
  String _name;
  String _email;
  String _password;
  DateTime _birthday;
  String _picture;
  bool _isUsed;
  DateTime _creationDate;

  // CONSTRUCTORS //
  User.create();
  User({String name, String email, String password, DateTime birthday, String picture, bool isUsed}) {
    name = name;
    email = email;
    password = password;
    birthday = birthday;
    picture = picture;
    isUsed = isUsed;
    creationDate = DateTime.now();
  }
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

  // GETTERS //
  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  DateTime get birthday => _birthday;
  String get picture => _picture;
  bool get isUsed => _isUsed;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  set birthday(DateTime birthday) => _birthday = birthday;
  set picture(String picture) => _picture = picture;
  set isUsed(bool isUsed) => _isUsed = isUsed;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //
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

  /// Return a Map<String, dynamic> with keys are the properties of User, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['password'] = password;
    map['birthday'] = birthday;
    map['picture'] = picture;
    map['isUsed'] = isUsed;
    map['creationDate'] = creationDate;

    return map;
  }

  String toString() => "An instance of User id=$id, name=$name";

}