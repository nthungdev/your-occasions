class EventRating {
  // PROPERTIES //
  int _id;
  int _eventId;
  int _one;
  int _two;
  int _three;
  int _four;
  int _five;
  double _rating;

  // CONSTRUCTORS //
  EventRating.create();
  EventRating({int eventId, int one, int two, int three, int four, int five, double rating}){
    _eventId = eventId;
    _one = one;
    _two = two;
    _three = three;
    _four = four;
    _five = five;
    _rating = rating;
  }
  EventRating.createFromMap(Iterable<Map<String, dynamic>> map){
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
  int get eventId => _eventId;
  int get one => _one;
  int get two => _two;
  int get three => _three;
  int get four => _four;
  int get five => _five;
  double  get rating => _rating;

  // SETTERs //
  set id(int id) => _id = id;
  set eventId(int eventId) => _eventId = eventId;
  set one(int one) => _one = one;
  set two(int two) => _two = two;
  set three(int three) => _three = three;
  set four(int four) => _four = four;
  set five(int five) => _five = five;
  set rating(double rating) => _rating = rating;

  // METHODS //
  
  /// Return a Map<String, dynamic> with keys are the properties of EventRating, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['eventId'] = eventId;
    map['one'] = one;
    map['two'] = two;
    map['three'] = three;
    map['four'] = four;
    map['five'] = five;
    map['rating'] = rating;

    return map;
  }
}