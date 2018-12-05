class EventCategory {
  // PROPERTIES //
  // int _id;
  // int _categoryId;
  int eventId;
  String category;
  DateTime creationDate;
  
  // CONSTRUCTORS //
  EventCategory.create();
  EventCategory({this.eventId, this.category}){
    this.creationDate = DateTime.now();
  }
  EventCategory.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      // this._id = item['id'];
      // this._categoryId = item['category_id'];
      this.eventId = item['event_id'];
      this.category = item['category'];
      this.creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  // int get id => _id;
  // int get categoryId => _categoryId;
  // int get eventId => _eventId;
  // String get category => _category;
  // DateTime get creationDate => _creationDate;

  // SETTERS //
  // set id(int id) => _id = id;
  // set categoryId(int categoryId) => _categoryId = categoryId;
  // set eventId(int eventId) => _eventId = eventId;
  // set category(String category) => _category = category;
  // set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //

  /// Return a Map<int, dynamic> with keys are the properties of GuesstLists, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    // map['id'] = id;
    // map['categoryId'] = categoryId;
    map['eventId'] = eventId;
    map['category'] = category;
    map['creationDate'] = creationDate;

    return map;
  }

}