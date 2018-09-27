class EventReview {
  // PROPERTIES //
  int _id;
  int _eventId;
  int _reviewerId;
  int _hostId;
  int _score;
  String _description;
  bool _isUsed;
  DateTime _creationDate;

  // CONSTRUCTORS //
  EventReview.create();
  EventReview({int eventId, int reviewerId, int hostId, String description, bool isUsed}) {
    eventId = eventId;
    reviewerId = reviewerId;
    hostId = hostId;
    description = description;
    isUsed = isUsed;
    creationDate = DateTime.now();
  }
  EventReview.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      _id = item['id'];
      _eventId = item['eventId'];
      _reviewerId = item['reviewId'];
      _hostId = item['host_id'];
      _description = item['description'];
      _isUsed = item['is_used'];
      _creationDate = item['creationDate'];
    });
  }

  // GETTERS //
  int get id => _id;
  int get eventId => _eventId;
  int get reviewerId => _reviewerId;
  int get hostId => _hostId;
  String get description => _description;
  bool get isUsed => _isUsed;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set eventId(int eventId) => _eventId = eventId;
  set reviewerId(int reviewerId) => reviewerId = reviewerId;
  set hostId(int hostId) => _hostId = hostId;
  set description(String description) => _description = description;
  set isUsed(bool isUsed) => _isUsed = isUsed;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //
  /// Return a Map<String, dynamic> with keys are the properties of User, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['eventId'] = eventId;
    map['reviewerId'] = reviewerId;
    map['hostId'] = hostId;
    map['description'] = description;
    map['isUsed'] = isUsed;
    map['creationDate'] = creationDate;
    return map;
  }

  String toString() => "An instance of EventReview id=$id.";

}