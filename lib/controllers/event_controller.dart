import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/Event.dart';
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

    await connection.query("""INSERT INTO events (host_id, name, description, location_name, start_time, endtime,
    age, price, category, is_used, creation_date)
      VALUES (@hostId, @name, @description, @locationName, @startTime, @endTime,
      @age, @price, @category, @isUsed, @creationDate)""",
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
  int age, int price, String category, bool isUsed, DateTime creationDate}) async {
    if(hostId == null && name == null && description == null && locationName == null && startTime == null && endTime == null
    && age == null && price == null && category == null && isUsed == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE Events SET ";
      if(hostId != null) { query += "host_id = '$hostId' "; }
      if(name != null) { query += "name = '$name' "; }
      if(description != null) { query += "email = '$description "; }
      if(locationName != null) { query += "password = '$locationName'"; }
      if(startTime != null) { query += "birthday = '$startTime'"; }
      if(endTime != null) { query += "picture = '$endTime'"; }
      if(age != null) { query += "is_used = '$age'"; }

      query += " WHERE id = '$id'";

      await connection.query(query);  

      await disconnect();
    }
    
    
  }

  /// Select all rows from Events table and return a list of Event objects.
  Future<List<Event>> getAllEvents([String orderBy, bool asc = true]) async {
    await connect();

    List<Event> result = [];
    var queryResult = await connection.mappedResultsQuery("""SELECT * FROM Events ORDER BY $orderBy ${asc ? 'ASC' : 'DESC'}""");
    for (var item in queryResult) {
      result.add(Event.createFromMap(item.values));
    }

    await disconnect();

    _count = result.length;
    _allEvents = result;

    return result;
  }

  void test() async {
    // update(9);
    await getAllEvents('name');
    print(allEvents);

  }
}
