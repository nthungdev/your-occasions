class FriendLists {
  // PROPERTIES //
  int _id;
  int _userId;
  int _eventId;
  int _friendId;
  DateTime _creationDate;
  

  // CONSTRUCTORS //
  FriendLists(this._id, this._userId, this._eventId, this._friendId);
  FriendLists.create();
  FriendLists.createFromMap(Iterable<Map<int, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      userId = item['userID'];
      eventId= item['eventId'];
      friendId= item ['friendId'];
      creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  int get id => _id;
  int get userId => _userId;
  int get eventId => _eventId;
  int get friendId => _friendId;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set userId(int userId) => _userId = userId;
  set eventId(int eventId) => _eventId = eventId;
  set friendId(int friendId) => _friendId = friendId;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuesstLists, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['eventId'] = eventId;
    map['creationDate'] = creationDate;
    map ['friendId'] = friendId;

    return map;
  }

}