class FriendList {
  // PROPERTIES //
  int id;
  String userId;
  String friendId;
  DateTime creationDate;
  

  // CONSTRUCTORS //
  FriendList.create();
  FriendList({this.userId, this.friendId}){
    creationDate = DateTime.now();
  }
  FriendList.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      userId = item['userID'];
      friendId= item ['friendId'];
      creationDate = item['creationDate'];
    });
  }

  // GETTERS //
  // int get id => _id;
  // String get userId => _userId;
  // String get friendId => _friendId;
  // DateTime get creationDate => _creationDate;

  // SETTERS //
  // set id(int id) => _id = id;
  // set userId(String userId) => _userId = userId;
  // set friendId(String friendId) => _friendId = friendId;
  // set creationDate(DateTime creationDate) => _creationDate = creationDate;

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