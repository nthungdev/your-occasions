class Category {
  // PROPERTIES //
  // int _id;
  String name;
  String description;
  bool isUsed;
  DateTime creationDate;

  // CONSTRUCTORS //
  Category({String name, String description}) {
    this.name = name;
    this.description = description;
    this.isUsed = true;
    this.creationDate = DateTime.now();
  }
  Category.createFromMap(Iterable<Map<String, dynamic>> map){
    map.forEach((item) {
      // this._id = item['id'];
      this.name = item['name'];
      this.description = item['description'];
      this.isUsed = item['isUsed'];
      this.creationDate = item['creation_date'];
    });
  }

  // GETTERS //
  // int get id => _id;
  // String get name => _name;
  // String get description => _description;
  // bool get isUsed => _isUsed;
  // DateTime get creationDate => _creationDate;

  // SETTERS //
  // set id(int id) => _id = id;
  // set name(String name) => _name = name;
  // set description(String description) => _description = description;
  // set isUsed(bool isUsed) => _isUsed = isUsed;
  // set creationDate(DateTime creationDate) => _creationDate = creationDate;

  // METHODS //
  /// Return a Map<String, dynamic> with keys are the properties of User, values are the properties' values.
  Map<String, dynamic> getProperties() {
    Map<String, dynamic> map = {};
    // map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['isUsed'] = isUsed;
    map['creationDate'] = creationDate;

    return map;
  }

  String toString() => "An instance of Category name=$name";

}

class Categories {
  // TODO write descriptions for each category of event
  // TODO document description for each category in comments

  static final all = [music, 
                      food, 
                      festival, 
                      party,
                      business, 
                      tech,
                      charity, 
                      sports, 
                      politics, 
                      comedy, 
                      fashion,
                      science,
                      study];

  static final Category music = Category(name: "Music", description: "Music event");
  static final Category food = Category(name: "Food", description: "Food event");
  static final Category festival = Category(name: "Festival", description: "Festival event");
  static final Category party = Category(name: "Party", description: "Party event");
  static final Category business = Category(name: "Business", description: "Business event");
  static final Category tech = Category(name: "Tech", description: "Tech event");
  static final Category charity = Category(name: "Charity", description: "Charity event");
  static final Category sports = Category(name: "Sports", description: "Sports event");
  static final Category politics = Category(name: "Politics", description: "Politics event");
  static final Category comedy = Category(name: "Comedy", description: "Comedy event");
  static final Category fashion = Category(name: "Fashion", description: "Fashion event");
  static final Category science = Category(name: "Science", description: "Science event");
  static final Category study = Category(name: "Study", description: "Study event");

}
