class FriendList {
  // PROPERTIES //
  int _id;
  String _userId;
  String _friendId;
  DateTime _creationDate;
  

  // CONSTRUCTORS //
  FriendList.create();
  FriendList({String userId, String friendId}){
    _userId = userId;
    _friendId = friendId;
    _creationDate = DateTime.now();
  }
  FriendList.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      _userId = item['user_id'];
      _friendId= item ['friend_id'];
      _creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  int get id => _id;
  String get userId => _userId;
  String get friendId => _friendId;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set userId(String userId) => _userId = userId;
  set friendId(String friendId) => _friendId = friendId;
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