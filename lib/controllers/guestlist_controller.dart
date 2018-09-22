//ib
import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/guest_list.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class EvenRatingController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into event_ratings table.
  Future<void> insert(GuestLists model) async {
    await connect();

    await connection.query("""INSERT INTO event_ratings (user_id, event_id, creation)_date)
      VALUES (@userId, @eventId, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from event_ratings table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM event_ratings WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from event_ratings table.
  Future<void> update(int id, {int, userId, int eventId, DateTime creationDate}) async {
    if(userId == null && eventId == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE event_ratings SET ";
      if(userId != null) { query += "user_id = $userId"; }
      if(eventId != null) { query += "event_id = $eventId "; }
      if(creationDate != null) { query += "creation_date = '$creationDate' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<List<GuestLists>> getGuestLists({int userId, int eventId , int id}) async{
    await connect();

    List<GuestLists> result = [];


    String query = "SELECT * from event_ratings ";

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
      result.add(GuestLists.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}