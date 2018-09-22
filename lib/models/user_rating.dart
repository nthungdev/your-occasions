class UserRating {
  // PROPERTIES //
  int _id;
  int _userId;
  int _one;
  int _two;
  int _three;
  int _four;
  int _five;
  double _rating;

  // CONSTRUCTORS //
  UserRating.create();
  UserRating({int userId, int one, int two, int three, int four, int five, double rating}){
    _userId = userId;
    _one = one;
    _two = two;
    _three = three;
    _four = four;
    _five = five;
    _rating = rating;
  }
  UserRating.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      one = item['one'];
      two = item['two'];
      three = item['three'];
      four = item['four'];
      five = item['five'];
      rating = item['rating'];
    });
  }

  // GETTERs //
  int get id => _id;
  int get userId => _userId;
  int get one => _one;
  int get two => _two;
  int get three => _three;
  int get four => _four;
  int get five => _five;
  double  get rating => _rating;

  // SETTERs //
  set id(int id) => _id = id;
  set userId(int userId) => _userId = userId;
  set one(int one) => _one = one;
  set two(int two) => _two = two;
  set three(int three) => _three = three;
  set four(int four) => _four = four;
  set five(int five) => _five = five;
  set rating(double rating) => _rating = rating;

  // METHODS //
  
  /// Return a Map<String, dynamic> with keys are the properties of UserRating, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['one'] = one;
    map['two'] = two;
    map['three'] = three;
    map['four'] = four;
    map['five'] = five;
    map['rating'] = rating;

    return map;
  }
}