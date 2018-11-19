class FriendList {
  // PROPERTIES //
  int _id;
  int _userId;
  int _friendId;
  DateTime _creationDate;
  

  // CONSTRUCTORS //
  FriendList.create();
  FriendList({int userId, int friendId}){
    _userId = userId;
    _friendId = friendId;
    _creationDate = DateTime.now();
  }
  FriendList.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      _userId = item['userID'];
      _friendId= item ['friendId'];
      _creationDate = item['creationDate'];
    });
  }

  // GETTERS //
  int get id => _id;
  int get userId => _userId;
  int get friendId => _friendId;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set userId(int userId) => _userId = userId;
  set friendId(int friendId) => _friendId = friendId;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuesstLists, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userId'] = userId;
    map['creationDate'] = creationDate;
    map ['friendId'] = friendId;

    return map;
  }

}