class UserAttendedEvent {
  // PROPERTIES //
  int id;
  String userId;
  int eventId;
  DateTime creationDate;
  

  // CONSTRUCTORS //
  UserAttendedEvent.create();
  UserAttendedEvent({this.userId, this.eventId, this.creationDate}){
    userId = userId;
    eventId = eventId;
    creationDate = creationDate;
  }
  UserAttendedEvent.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      userId = item['userId'];
      eventId= item['eventId'];
      creationDate = item['creationDate'];
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

  /// Return a Map<int, dynamic> with keys are the properties of UserAttendedEvent, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['eventId'] = eventId;
    map['creationDate'] = creationDate;

    return map;
  }

}