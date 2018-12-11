import 'package:youroccasions/models/category.dart';

class Event {
  // PROPERTIES //
  int id;
  String hostId;
  String name;
  String description;
  String locationName;
  String address;
  String placeId;
  DateTime startTime;
  DateTime endTime;
  int views;
  int age;
  int price;
  String category;
  String picture;
  int one;
  int two;
  int three;
  int four;
  int five;
  num rating;
  bool isUsed;
  List<String> categories;
  DateTime creationDate;

  // CONSTRUCTORS //
  Event.create();
  Event({this.hostId, this.name, this.description, this.locationName, this.address, this.placeId, this.startTime, this.endTime, 
      this.views, this.age, this.price, this.category, this.picture, this.one, this.two, this.three, this.four, this.five, this.rating, 
      this.isUsed=true}) {
    this.creationDate = DateTime.now();
  }
  Event.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      this.id = item['id'];
      this.hostId = item['host_id'];
      this.name = item['name'];
      this.description = item['description'];
      this.locationName = item['location_name'];
      this.address = item['address'];
      this.placeId = item['place_id'];
      this.startTime= item['start_time'];
      this.endTime = item['end_time'];
      this.views = item['views'];
      this.age = item['age'];
      this.price = item['price'];
      this.picture = item['picture'];
      this.category = item['category'];
      this.one = item['one'];
      this.two = item['two'];
      this.three = item['three'];
      this.four = item['four'];
      this.five = item['five'];
      this.rating = item['rating'];
      this.isUsed = item['is_used'];
      this.creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  // int get id => _id;
  // String get hostId => _hostId;
  // String get name => _name;
  // String get description => _description;
  // String get locationName => _locationName;
  // DateTime get startTime => _startTime;
  // DateTime get endTime => _endTime;
  // int get views => _views;
  // int get age => _age;
  // int get price => _price;
  // String get category => _category;
  // String get picture => _picture;
  // int get one => _one;
  // int get two => _two;
  // int get three => _three;
  // int get four => _four;
  // int get five => _five;
  // num get rating => _rating;
  // bool get isUsed => _isUsed;
  // DateTime get creationDate => _creationDate;

  // SETTERS //
  // set id(int id) => _id = id;
  // set hostId(String hostId) => _hostId = hostId;
  // set name(String name) => _name = name;
  // set description(String description) => _description = description;
  // set locationName(String locationName) => _locationName = locationName;
  // set startTime(DateTime startTime) => _startTime = startTime;
  // set endTime(DateTime endTime) => _endTime = endTime;
  // set views(int views) => _views = views;
  // set age(int age) => _age = age;
  // set price(int price) => _price = price;
  // set category(String category) => _category = category;
  // set picture(String picture) => _picture = picture;
  // set one(int one) => _one = one;
  // set two(int two) => _two = two;
  // set three(int three) => _three = three;
  // set four(int four) => _four = four;
  // set five(int five) => _five = five;
  // set rating(num rating) => _rating = rating;
  // set isUsed(bool isUsed) => _isUsed = isUsed;
  // set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //
  /// Return a Map<String, dynamic> with keys are the properties of User, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['hostId'] = hostId;
    map['name'] = name;
    map['description'] = description;
    map['locationName'] = locationName;
    map['address'] = address;
    map['placeId'] = placeId;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['views'] = views;
    map['age'] = age;
    map['price'] = price;
    map['category'] = category;
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

  String toString() => "An instance of Event id=$id, name=$name";

}