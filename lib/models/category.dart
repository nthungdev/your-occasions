class Category {
  // PROPERTIES //
  int _id;
  String _name;
  String _description;
  bool _isUsed;
  DateTime _creationDate;

  // CONSTRUCTORS //
  Category.create();
  Category({String name, String description, bool isUsed=true}) {
    this._name = name;
    this._description = description;
    this._isUsed = isUsed;
    this._creationDate = DateTime.now();
  }
  Category.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      this._id = item['id'];
      this._name = item['name'];
      this._description = item['description'];
      this._isUsed = item['isUsed'];
      this._creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  int get id => _id;
  String get name => _name;
  String get description => _description;
  bool get isUsed => _isUsed;
  DateTime get creationDate => _creationDate;

  // SETTERS //
  set id(int id) => _id = id;
  set name(String name) => _name = name;
  set description(String description) => _description = description;
  set isUsed(bool isUsed) => _isUsed = isUsed;
  set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //
  /// Return a Map<String, dynamic> with keys are the properties of User, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['isUsed'] = isUsed;
    map['creationDate'] = creationDate;

    return map;
  }

  String toString() => "An instance of Event id=$id, name=$name";

}