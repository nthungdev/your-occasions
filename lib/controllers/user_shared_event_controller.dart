import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/user_shared_event.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class UserSharedEventController extends BaseController{
  // PROPERTIES //
  int _count;
  List<UserSharedEvent> _allUsers;

  // CONSTRUCTORS //
  UserSharedEventController() : super();

  // CONSTRUCTORS //

  // GETTERS //
  int get count => _count;
  List<UserSharedEvent> get allUsers => _allUsers;

  // SETTERS //
  

  // METHODS //
  /// Insert a new row into user_shared_events table.
  Future<void> insert(UserSharedEvent model) async {
    await connect();

    await connection.query("""INSERT INTO user_shared_events (user_id, event_id, sharer_id, creation_date)
      VALUES (@userId, @eventId, @sharerId, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from user_shared_events table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM user_shared_events WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from user_shared_events table.
  Future<void> update(int id, {String userId, int eventId, String sharerId}) async {
    if(userId == null && eventId == null && sharerId == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE user_shared_events SET ";
      if(userId != null) { query += "user_id = '$userId' "; }
      if(eventId != null) { query += "eventId = $eventId "; }
      if(sharerId != null) { query += "sharerId = '$sharerId' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<List<UserSharedEvent>> getUserSharedEvent({int id , String userId, int eventId, String sharerId}) async{
    await connect();

    List<UserSharedEvent> result = [];

    String query = "SELECT * FROM user_shared_events ";

    if(id == null && userId == null && eventId == null && sharerId == null) {

    }
    else {
      query += "WHERE ";
      
      if(id != null) { query += "id = $id ";}
      else if(userId != null) { query += "user_id = '$userId' ";}
      else if(eventId != null) { query += "event_id = $eventId ";}
      else if(sharerId != null) { query += "sharer_id = '$sharerId' ";}
    }

    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(UserSharedEvent.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }
}