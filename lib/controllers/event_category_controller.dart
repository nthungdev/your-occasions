import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/event_category.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class EventCategoryController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into user_interesteded_events table.
  Future<void> insert(EventCategory model) async {
    await connect();

    await connection.query("""INSERT INTO event_category (event_id, category, creation_date)
      VALUES (@eventId, @category, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from user_interested_events table.
  Future<void> delete(eventId, String category) async {
    await connect();

    await connection.query("""DELETE FROM event_categories WHERE event_id = @event_id AND category = @category""", substitutionValues: { 'event_id': eventId, 'category': category});  

    await disconnect();
  }

  /// Update an existing row from user_interested_events table.
  // Future<void> update(int event_id, String category, {int eventId, String category, DateTime creationDate}) async {
  //   if(categoryId == null && eventId == null && category == null && creationDate == null) {
  //     throw UpdateQueryException(); //
  //   }
  //   else {
  //     await connect();

  //     String query = "UPDATE event_categories SET ";
  //     if(categoryId != null) { query += "category_id = $categoryId"; }
  //     if(eventId != null) { query += "event_id = $eventId "; }
  //     if(category != null) { query += "category = $category"; }
  //     if(creationDate != null) { query += "creation_date = '$creationDate' "; }

  //     query += " WHERE id = '$id'";

  //     await connection.query(query); 

  //     await disconnect();
  //   }
  // }

  Future<List<EventCategory>> getEventCategory({int eventId, String category}) async {
    if (eventId == null && category == null) {
      throw UpdateQueryException();
    }

    await connect();

    List<EventCategory> result = [];

    String query = "SELECT * from event_categories WHERE ";

    if (eventId != null) { query += "event_id = $eventId "; }
    if (eventId != null && category != null) { query += "AND "; }
    if (category != null) { query += "category = '$category' "; }

    // print(query);

    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(EventCategory.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}