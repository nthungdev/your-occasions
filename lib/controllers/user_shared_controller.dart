//ib
import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/user_shared_events_rating.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class UsersharedController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into user_shared_events table.
  Future<void> insert(Usershared model) async {
    await connect();

    await connection.query("""INSERT INTO user_shared_events (user_shared_events_id, one, two, three, four, five, rating)
      VALUES (@user_shared_eventsId, @one, @two, @three, @four, @five, @rating)""",
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
  Future<void> update(int id, {int user_shared_eventsId, int one, int two, int three, int four, int five, double rating}) async {
    if(user_shared_eventsId == null && one == null && two == null && three == null && four == null && five == null && rating == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE user_shared_events SET ";
      if(user_shared_eventsId != null) { query += "user_shared_events_id = $user_shared_eventsId "; }
      if(one != null) { query += "one = $one "; }
      if(two != null) { query += "two = $two "; }
      if(three != null) { query += "three = $three "; }
      if(four != null) { query += "four = $four "; }
      if(five != null) { query += "five = $five "; }
      if(rating != null) { query += "rating = $rating ";}

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<List<UserRating>> getUserRating({int user_shared_eventsId , int id}) async{
    await connect();

    List<UserRating> result = [];


    String query = "SELECT * from user_shared_events ";

    if(user_shared_eventsId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(user_shared_eventsId != null) { query += "user_shared_events_id = $user_shared_eventsId ";}
      else if(id != null) { query += "id = $id ";}
    }


    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(UserRating.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}