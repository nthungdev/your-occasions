import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/user_interested_event.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class UserInterestedEventController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into user_interesteded_events table.
  Future<void> insert(UserInterestedEvent model) async {
    await connect();

    await connection.query("""INSERT INTO user_interested_events (user_id, event_id, creation_date)
      VALUES (@userId, @eventId, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from user_interested_events table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM user_interested_events WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from user_interested_events table.
  Future<void> update(int id, {int, userId, int eventId, DateTime creationDate}) async {
    if(userId == null && eventId == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE user_interested_events SET ";
      if(userId != null) { query += "user_id = $userId"; }
      if(eventId != null) { query += "event_id = $eventId "; }
      if(creationDate != null) { query += "creation_date = '$creationDate' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<List<UserInterestedEvent>> getUserInterestedEvent({int userId, int eventId , int id}) async{
    await connect();

    List<UserInterestedEvent> result = [];


    String query = "SELECT * from user_interested_events ";

    if(eventId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(eventId != null) { query += "event_id = $eventId ";}
      else if(userId != null) { query += "user_id = $userId";}
      else if(id != null) { query += "id = $id ";}
    }


    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(UserInterestedEvent.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}