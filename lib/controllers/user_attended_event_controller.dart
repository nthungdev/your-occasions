import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/user_attended_event.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class UserAttendedController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into user_attended_events table.
  Future<void> insert(UserAttendedEvent model) async {
    await connect();

    await connection.query("""INSERT INTO user_attended_events (user_id, event_id, creation_date)
      VALUES (@userId, @eventId, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from user_attended_events table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM user_attended_events WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from user_attended_events table.
  Future<void> update(int id, {String userId, int eventId, DateTime creationDate}) async {
    if(userId == null && eventId == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE user_attended_events SET ";
      if(userId != null) { query += "user_id = '$userId' "; }
      if(eventId != null) { query += "event_id = $eventId "; }
      if(creationDate != null) { query += "creation_date = '$creationDate' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<List<UserAttendedEvent>> getUserAttendedEvent({String userId, int eventId , int id}) async{
    await connect();

    List<UserAttendedEvent> result = [];


    String query = "SELECT * from user_attended_events ";

    if(eventId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(eventId != null) { query += "event_id = $eventId ";}
      else if(userId != null) { query += "user_id = '$userId' ";}
      else if(id != null) { query += "id = $id ";}
    }


    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(UserAttendedEvent.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}