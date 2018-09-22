import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/event_review.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class EventReviewController extends BaseController {
  // PROPERTIES //
  int _count;
  List<EventReview> _allEvents;

  // CONSTRUCTORS //
  EventReviewController() : super();

  // GETTERS //
  List<EventReview> get allEvents => _allEvents;
  int get count => _count;

  // SETTERS //
  

  // METHODS //
  /// Insert a new row into Events table.
  Future<void> insert(EventReview model) async {
    await connect();

    await connection.query("""INSERT INTO event_reviews (event_id, reviewer_id, host_id, description, is_used, creation_date)
      VALUES (@eventId, @reviewerId, @hostId, @name, @description, @isUsed, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from Events table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM event_reviews WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from Events table based on id.
  Future<void> update(int id, {int eventId, int reviewerId, int hostId, String description, bool isUsed, DateTime creationDate}) async {
    if(eventId == null && reviewerId == null && hostId == null && description == null && isUsed == null && creationDate == null) {
      throw UpdateQueryException(); 
    }
    else {
      await connect();

      String query = "UPDATE event_reviews SET ";
      if(eventId != null) { query += "host_id = '$hostId' "; }
      if(reviewerId != null) { query += "name = '$reviewerId' "; }
      if(hostId != null) { query += "host_id = '$hostId' "; }
      if(description != null) { query += "email = '$description "; }

      query += " WHERE id = '$id'";

      await connection.query(query);  

      await disconnect();
    }
  }

  /// Select rows from users table and return a list of User objects.
  Future<List<EventReview>> getEventReview({int id, int eventId, int reviewerId, int hostId}) async{
    await connect();

    List<EventReview> result = [];


    String query = "SELECT * FROM event_reviews ";

    if(id == null && eventId == null && reviewerId == null && hostId == null) {

    }
    else {
      query += "WHERE ";
      if (id != null) { query += "id = $id "; }
      else if (eventId != null) { query += "event_id = $eventId "; }
      else if (reviewerId != null) { query += "reviewer_id = $reviewerId "; }
      else if (hostId != null) { query += "host_id = $hostId "; }
    }

    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(EventReview.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }
  
  void test() async {
    // update(9);
    await getEventReview();
    print(allEvents);

  }
}
