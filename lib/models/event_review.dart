class EventReview {
  // PROPERTIES //
  int id;
  int eventId;
  String reviewerId;
  String hostId;
  int score;
  String description;
  bool isUsed;
  DateTime creationDate;

  // CONSTRUCTORS //
  EventReview.create();
  EventReview({this.eventId, this.reviewerId, this.hostId, this.description, this.isUsed}) {
    creationDate = DateTime.now();
  }
  EventReview.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      id = item['id'];
      eventId = item['eventId'];
      reviewerId = item['reviewId'];
      hostId = item['host_id'];
      description = item['description'];
      isUsed = item['is_used'];
      creationDate = item['creationDate'];
    });
  }

  // GETTERS //
  // int get id => _id;
  // int get eventId => _eventId;
  // String get reviewerId => _reviewerId;
  // String get hostId => _hostId;
  // String get description => _description;
  // bool get isUsed => _isUsed;
  // DateTime get creationDate => _creationDate;

  // SETTERS //
  // set id(int id) => _id = id;
  // set eventId(int eventId) => _eventId = eventId;
  // set reviewerId(String reviewerId) => reviewerId = reviewerId;
  // set hostId(String hostId) => _hostId = hostId;
  // set description(String description) => _description = description;
  // set isUsed(bool isUsed) => _isUsed = isUsed;
  // set creationDate(DateTime creationDate) => _creationDate = creationDate;

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