import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/event_rating.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class EvenRatingController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into event_ratings table.
  Future<void> insert(EventRating model) async {
    await connect();

    await connection.query("""INSERT INTO event_ratings (event_id, one, two, three, four, five, rating)
      VALUES (@eventId, @one, @two, @three, @four, @five, @rating)""",
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
  Future<void> update(int id, {int eventId, int one, int two, int three, int four, int five, double rating}) async {
    if(eventId == null && one == null && two == null && three == null && four == null && five == null && rating == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE event_ratings SET ";
      if(eventId != null) { query += "event_id = $eventId "; }
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

  Future<List<EventRating>> getEventRating({int eventId , int id}) async{
    await connect();

    List<EventRating> result = [];


    String query = "SELECT * from event_ratings ";

    if(eventId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(eventId != null) { query += "event_id = $eventId ";}
      else if(id != null) { query += "id = $id ";}
    }


    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(EventRating.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}