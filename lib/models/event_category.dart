class EventCategory {
  // PROPERTIES //
  int _id;
  int _categoryId;
  int _eventId;
  String _category;
  DateTime _creationDate;
  
  // CONSTRUCTORS //
  EventCategory.create();
  EventCategory({int categoryId, int eventId, String category}){
    this._categoryId = categoryId;
    this._eventId = eventId;
    this._category = category;
    this._creationDate = DateTime.now();
  }
  EventCategory.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      this._id = item['id'];
      this._categoryId = item['category_id'];
      this._eventId = item['event_id'];
      this._category = item['category_id'];
      this._creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  int get id => _id;
  int get categoryId => _categoryId;
  int get eventId => _eventId;
  String get category => _category;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set categoryId(int categoryId) => _categoryId = categoryId;
  set eventId(int eventId) => _eventId = eventId;
  set category(String category) => _category = category;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuesstLists, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['categoryId'] = categoryId;
    map['eventId'] = eventId;
    map['category'] = category;
    map['creationDate'] = creationDate;

    return map;
  }

}