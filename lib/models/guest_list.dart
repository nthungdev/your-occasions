class GuestList {
  // PROPERTIES //
  int id;
  String userId;
  int eventId;
  DateTime creationDate;
  

  // CONSTRUCTORS //
  GuestList.create();
  GuestList({String userId, int eventId, DateTime creationDate}){
    userId = userId;
    eventId = eventId;
    creationDate = creationDate;
  }
  GuestList.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
<<<<<<< HEAD
      id = item['id'];
      userId = item['userId'];
      eventId= item['eventId'];
      creationDate = item['creationDate'];
=======
      _id = item['id'];
      _userId = item['user_id'];
      _eventId= item['event_id'];
      _creationDate = item['creation_date'];
>>>>>>> c52c85a389ecbebd1f1596ec593e4b402f1aaa8e
    });
  }

  // GETTERS //
  // int get id => _id;
  // String get userId => _userId;
  // int get eventId => _eventId;
  // DateTime get creationDate => _creationDate;

  // SETTERS //
  // set id(int id) => _id = id;
  // set userId(String userId) => _userId = userId;
  // set eventId(int eventId) => _eventId = eventId;
  // set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuestList, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['eventId'] = eventId;
    map['creationDate'] = creationDate;

    return map;
  }

}