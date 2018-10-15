class EventCategory {
  // PROPERTIES //
  int _id;
  int _categoryId;
  int _eventId;
  String _eventName;
  String _categoryName;
  DateTime _creationDate;
  
  // CONSTRUCTORS //
  EventCategory.create();
  EventCategory({int categoryId, int eventId, String categoryName, String eventName}){
    this._categoryId = categoryId;
    this._eventId = eventId;
    this._categoryName = categoryName;
    this._eventName = eventName;
    this._creationDate = DateTime.now();
  }
  EventCategory.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      this._id = item['id'];
      this._categoryId = item['category_id'];
      this._eventId = item['event_id'];
      this._categoryName = item['category_id'];
      this._eventName = item['event_name'];
      this._creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  int get id => _id;
  int get categoryId => _categoryId;
  int get eventId => _eventId;
  String get categoryName => _categoryName;
  String get eventName => _eventName;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set categoryId(int categoryId) => _categoryId = categoryId;
  set eventId(int eventId) => _eventId = eventId;
  set categoryName(String categoryName) => _categoryName = categoryName;
  set eventName(String eventName) => _eventName = eventName;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuesstLists, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['categoryId'] = categoryId;
    map['eventId'] = eventId;
    map['categoryName'] = categoryName;
    map['eventName'] = eventName;
    map['creationDate'] = creationDate;

    return map;
  }

}