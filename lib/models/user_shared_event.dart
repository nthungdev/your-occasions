class UserSharedEvent {
  // PROPERTIES //
  int _id;
  String _userId;
  int _eventId;
  int _sharerId;
  DateTime _creationDate;

  // CONSTRUCTORS //
  UserSharedEvent.create();
  UserSharedEvent({String userId, int eventId, int sharerId, DateTime creationDate}){
    _userId = userId;
    _eventId = eventId;
    _sharerId = sharerId;
    _creationDate = creationDate;
  }
  UserSharedEvent.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      _id = item['id'];
      _userId = item['userId'];
      _eventId= item['eventId'];
      _sharerId = item['sharerId'];
      _creationDate = item['creationDate'];
    });
  }

  // GETTERS //
  int get id => _id;
  String get userId => _userId;
  int get eventId => _eventId;
  int get sharerId => _sharerId;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set userId(String userId) => _userId = userId;
  set eventId(int eventId) => _eventId = eventId;
  set sharerId(int sharerId) => _sharerId = sharerId;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of UserSharedEvent, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['eventId'] = eventId;
    map['sharerId'] = sharerId;
    map['creationDate'] = creationDate;
    return map;
  }

}