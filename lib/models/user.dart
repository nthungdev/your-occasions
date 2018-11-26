import 'package:meta/meta.dart';

class User {
  // PROPERTIES //
  String id;
  String name;
  String email;
  String provider;
  DateTime birthday;
  String picture;
  int one;
  int two;
  int three;
  int four;
  int five;
  double rating;
  bool isUsed;
  DateTime creationDate;
  int followers;
  int following;

  // CONSTRUCTORS //
  User.create();
  User({@required this.id, this.name, this.email, @required this.provider, this.birthday, this.picture, 
  this.one, this.two, this.three, this.four, this.five, this.rating, bool isUsed=true}) {
    this.isUsed = isUsed;
    this.creationDate = DateTime.now();
  }
  User.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      name = item['name'];
      email = item['email'];
      provider = item['provider'];
      birthday = item['birthday'];
      picture = item['picture'];
      one = item['one'];
      two = item['two'];
      three = item['three'];
      four = item['four'];
      five = item['five'];
      rating = item['rating'];
      isUsed = item['isUsed'];
      creationDate = item['creationDate'];
      followers = item['followers'];
      following = item['following'];
    });
  }

  // GETTERS //
  // String get id => _id;
  // String get name => _name;
  // String get email => _email;
  // String get password => _password;
  // DateTime get birthday => _birthday;
  // String get picture => _picture;
  // int get one => _one;
  // int get two => _two;
  // int get three => _three;
  // int get four => _four;
  // int get five => _five;
  // double  get rating => _rating;
  // int get followers => _followers;
  // bool get isUsed => _isUsed;
  // DateTime get creationDate => _creationDate;

  // SETTERS //
  // set id(String id) => _id = id;
  // set name(String name) => _name = name;
  // set email(String email) => _email = email;
  // set password(String password) => _password = password;
  // set birthday(DateTime birthday) => _birthday = birthday;
  // set picture(String picture) => _picture = picture;
  // set one(int one) => _one = one;
  // set two(int two) => _two = two;
  // set three(int three) => _three = three;
  // set four(int four) => _four = four;
  // set five(int five) => _five = five;
  // set rating(double rating) => _rating = rating;
  // set followers(int followers) => _followers = followers;
  // set isUsed(bool isUsed) => _isUsed = isUsed;
  // set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //
  static User clone(User user) {
    return User.createFromMap(List.filled(1, user.getProperties()));
  }

  void printInfo() {
    String info = """
    ID: $id
    Name: $name
    Email: $email
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
    map['id'] = this.id;
    map['name'] = name;
    map['email'] = email;
    map['provider'] = provider;
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
    map['followers'] = followers;
    map['following'] = following;
    return map;
  }

  String toString() => "An instance of User id=$id, name=$name";

}