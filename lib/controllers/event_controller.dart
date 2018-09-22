import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
<<<<<<< HEAD
import 'package:youroccasions/models/event.dart';
=======
import 'package:youroccasions/models/Event.dart';
>>>>>>> 7ccbea979e333b21fb4d2b88c8bd47d5ecafd6ab
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
  Future<void> update(int id, {int hostId, String name, String description, String locationName, DateTime startTime, DateTime endTime,
  int age, int price, String category, bool isUsed, DateTime creationDate}) async {
    if(hostId == null && name == null && description == null && locationName == null && startTime == null && endTime == null
    && age == null && price == null && category == null && isUsed == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE events SET ";
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

  /// Select rows from users table and return a list of User objects.
  Future<List<Event>> getEvent({int id, int hostId, String name, String category, DateTime startTime, DateTime endTime}) async{
    await connect();

    List<Event> result = [];


    String query = "SELECT * FROM events ";

    if(hostId == null && name == null && id == null) {

    }
    else {
      query += "WHERE ";
      if (name != null) { query += "name = '$name' "; }
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
  void test() async {
    // update(9);
    await getEvent();
    print(allEvents);

  }
}
