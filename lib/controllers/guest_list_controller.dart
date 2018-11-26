//ib
import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/guest_list.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class GuestListController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into guestlists table.
  Future<void> insert(GuestList model) async {
    await connect();

    await connection.query("""INSERT INTO guestlists (user_id, event_id, creation_date)
      VALUES (@userId, @eventId, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from guestlists table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM guestlists WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from guestlists table.
  Future<void> update(int id, {String userId, int eventId, DateTime creationDate}) async {
    if(userId == null && eventId == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE guest_lists SET ";
      if(userId != null) { query += "user_id = '$userId' "; }
      if(eventId != null) { query += "event_id = $eventId "; }
      if(creationDate != null) { query += "creation_date = '$creationDate' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<List<GuestList>> getGuestList({String userId, String guestId, int id}) async{
    await connect();

    List<GuestList> result = [];


    String query = "SELECT * from guestlists ";

    if(guestId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(guestId != null) { query += "guest_id = '$guestId' ";}
      else if(userId != null) { query += "user_id = '$userId' ";}
      else if(id != null) { query += "id = $id ";}
    }


    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(GuestList.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}