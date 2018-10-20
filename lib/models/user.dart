class User {
  // PROPERTIES //
  int _id;
  String _name;
  String _email;
  String _password;
  DateTime _birthday;
  String _picture;
  int _one;
  int _two;
  int _three;
  int _four;
  int _five;
  double _rating;
  bool _isUsed;
  DateTime _creationDate;

  // CONSTRUCTORS //
  User.create();
  User({String name, String email, String password, DateTime birthday, String picture, 
  int one, int two, int three, int four, int five, double rating, bool isUsed=true}) {
    // print("name is $name");
    this._name = name;
    this._email = email;
    this._password = password;
    this._birthday = birthday;
    this._picture = picture;
    this._one = one;
    this._two = two;
    this._three = three;
    this._four = four;
    this._five = five;
    this._rating = rating;
    this._isUsed = isUsed;
    this._creationDate = DateTime.now();
  }
  User.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      _id = item['id'];
      _name = item['name'];
      _email = item['email'];
      _password = item['password'];
      _birthday = item['birthday'];
      _picture = item['picture'];
      _one = item['one'];
      _two = item['two'];
      _three = item['three'];
      _four = item['four'];
      _five = item['five'];
      _rating = item['rating'];
      _isUsed = item['isUsed'];
      _creationDate = item['creationDate'];
    });
  }

  // GETTERS //
  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  DateTime get birthday => _birthday;
  String get picture => _picture;
  int get one => _one;
  int get two => _two;
  int get three => _three;
  int get four => _four;
  int get five => _five;
  double  get rating => _rating;
  bool get isUsed => _isUsed;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  set birthday(DateTime birthday) => _birthday = birthday;
  set picture(String picture) => _picture = picture;
  set one(int one) => _one = one;
  set two(int two) => _two = two;
  set three(int three) => _three = three;
  set four(int four) => _four = four;
  set five(int five) => _five = five;
  set rating(double rating) => _rating = rating;
  set isUsed(bool isUsed) => _isUsed = isUsed;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //
  User clone() {
    return User.createFromMap(List.filled(1, this.getProperties()));
  }

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
    map['one'] = one;
    map['two'] = two;
    map['three'] = three;
    map['four'] = four;
    map['five'] = five;
    map['rating'] = rating;
    map['isUsed'] = isUsed;
    map['creationDate'] = creationDate;
    return map;
  }

  String toString() => "An instance of User id=$id, name=$name";

}