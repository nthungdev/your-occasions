class GuestLists {
  // PROPERTIES //
  int _id;
  int _userId;
  int _eventId;
  int _sharerId;
  DateTime _creationDate;
  

  // CONSTRUCTORS //
  GuestLists(this._id, this._userId, this._eventId);
  GuestLists.create();
  GuestLists.createFromMap(Iterable<Map<int, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      userId = item['userID'];
      eventId= item['eventId'];
      sharerId = item['sharerId'];
      creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  int get id => _id;
  int get userId => _userId;
  int get eventId => _eventId;
  int get sharerId => _sharerId;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set userId(int userId) => _userId = userId;
  set eventId(int eventId) => _eventId = eventId;
  set sharerId(int sharerId) => _sharerId = sharerId;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuesstLists, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['eventId'] = eventId;
    map['creationDate'] = creationDate;
    map ['sharerId'] = sharerId;

    return map;
  }

}