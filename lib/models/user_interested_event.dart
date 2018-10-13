class UserInterestedEvent {
  // PROPERTIES //
  int _id;
  int _userId;
  int _eventId;
  DateTime _creationDate;
  
  // CONSTRUCTORS //
  UserInterestedEvent.create();
  UserInterestedEvent({int userId, int eventId}){
    _userId = userId;
    _eventId = eventId;
    _creationDate = DateTime.now();
  }
  UserInterestedEvent.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      _id = item['id'];
      _userId = item['user_id'];
      _eventId= item['event_id'];
      _creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  int get id => _id;
  int get userId => _userId;
  int get eventId => _eventId;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set userId(int userId) => _userId = userId;
  set eventId(int eventId) => _eventId = eventId;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuesstLists, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['eventId'] = eventId;
    map['creationDate'] = creationDate;

    return map;
  }

}