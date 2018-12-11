import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/event_category.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class EventCategoryController extends BaseController {
  // PROPERTIES //

  // CONSTRUCTORS //
  // CONSTRUCTORS //
  EventCategoryController() : super();

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into user_interesteded_events table.
  Future<void> insert(EventCategory model) async {
    await connect();

    await connection.query("""INSERT INTO event_categories (event_id, category, creation_date)
      VALUES (@eventId, @category, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Insert a new row into user_interesteded_events table.
  Future<void> bulkInsert(List<String> models, int eventId) async {
    await connect();

    for (String model in models) {
      EventCategory ec = EventCategory(
        category: model,
        eventId: eventId,
      );
      await connection.query("""INSERT INTO event_categories (event_id, category, creation_date)
        VALUES (@eventId, @category, @creationDate)""",
        substitutionValues: ec.getProperties());
    }

    await disconnect();
  }
  

  /// Delete rows from event_categories table.
  Future<void> bulkDelete(int eventId) async {
    await connect();

    await connection.query("""DELETE FROM event_categories WHERE event_id = @event_id""", substitutionValues: { 'event_id': eventId });  

    await disconnect();
  }

  /// Delete an existing row from event_categories table.
  Future<void> delete(eventId, String category) async {
    await connect();

    await connection.query("""DELETE FROM event_categories WHERE event_id = @event_id AND category = @category""", substitutionValues: { 'event_id': eventId, 'category': category});  

    await disconnect();
  }


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