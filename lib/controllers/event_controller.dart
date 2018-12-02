import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class EventController extends BaseController {
  // PROPERTIES //
  int _count;
  List<Event> _allEvents;

  // CONSTRUCTORS //
  EventController() : super();

  // GETTERS //
  List<Event> get allEvents => _allEvents;
  int get count => _count;

  // SETTERS //
  

  // METHODS //
  /// Insert a new row into Events table.
  Future<void> insert(Event model) async {
    await connect();

    await connection.query("""INSERT INTO events (host_id, name, description, location_name, start_time, end_time, age, price, picture, is_used, creation_date)
      VALUES (@hostId, @name, @description, @locationName, @startTime, @endTime, @age, @price, @picture, @isUsed, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from Events table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM events WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from Events table based on id.
  Future<void> update(int id, {String hostId, String name, String description, String locationName, DateTime startTime, DateTime endTime,
  int views, int age, int price, String category, int one, int two, int three, int four, int five, double rating, bool isUsed, String picture, DateTime creationDate}) async {
    
    if(hostId == null && name == null && description == null && locationName == null && startTime == null && endTime == null
    && views == null && age == null && price == null && category == null && one == null && two == null && three == null && four == null && five == null && rating == null 
    && isUsed == null && picture == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE events SET ";
      if(hostId != null) { query += "host_id = '$hostId', "; }
      if(name != null) { query += "name = '$name', "; }
      if(description != null) { query += "description = '$description', "; }
      if(locationName != null) { query += "locationName = '$locationName', "; }
      if(startTime != null) { query += "start_time = '$startTime', "; }
      if(endTime != null) { query += "end_time = '$endTime', "; }
      if(views != null) { query += "views = '$views', "; }
      if(age != null) { query += "age = '$age', "; }
      if(one != null) { query += "one = $one, "; }
      if(two != null) { query += "two = $two, "; }
      if(three != null) { query += "three = $three, "; }
      if(four != null) { query += "four = $four, "; }
      if(five != null) { query += "five = $five, "; }
      if(rating != null) { query += "rating = $rating, "; }
      if(isUsed != null) { query += "is_used = $isUsed, "; }
      if(picture != null) { query += "picture = '$picture', "; }
      query = query.substring(0, query.length - 2);
      query += " WHERE id = '$id'";
      print("DEBUG: $query");
      await connection.query(query);

      await disconnect();
    }
  }

  /// Select rows from users table and return a list of User objects.
  Future<List<Event>> getEvent({int id, String hostId, String name, String category, DateTime startTime, DateTime endTime}) async {
    await connect();

    List<Event> result = [];

    String query = "SELECT * FROM events ";

    if(hostId == null && name == null && id == null) {

    }
    else {
      query += "WHERE ";
      if (name != null) { query += "LOWER(name) LIKE LOWER('%$name%') "; }
      else if (hostId != null) { query += "host_id = '$hostId' "; }
      else if (id != null) { query += "id = $id "; }
      else if (category != null) { query += "category = '$category' "; }
      else if (startTime != null) { query += "start_time = '$startTime' "; }
      else if (endTime != null) { query += "end_time = '$endTime' "; }
    }

    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(Event.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

  Future<void> increaseView(int id) async {
    await connect();

    String query = "UPDATE events SET views = views + 1 WHERE id = $id";

    await connection.execute(query);

    await disconnect();
  }
  

  Future<List<Event>> getPastEvents() async {
    await connect();
    var query = """
SELECT *
FROM events
WHERE start_time < NOW();
""";
    var queryResult = await connection.mappedResultsQuery(query);
    print(queryResult);
    await disconnect();
    return List<Event>.generate(queryResult.length, (index) {
      return Event.createFromMap(queryResult[index].values);
    });
  }

  Future<List<Event>> getUpcomingEvents() async {
    await connect();
    var query = """
SELECT *
FROM events
WHERE start_time < NOW();
""";
    var queryResult = await connection.mappedResultsQuery(query);
    print(queryResult);
    await disconnect();
    return List<Event>.generate(queryResult.length, (index) {
      return Event.createFromMap(queryResult[index].values);
    });
  }
}