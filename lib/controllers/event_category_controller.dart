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

    await connection.query("""INSERT INTO event_category (category_id, event_id, category_name, event_name, creation_date)
      VALUES (@categoryId, @eventId, @categoryName, @eventName, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from user_interested_events table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM event_categories WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from user_interested_events table.
  Future<void> update(int id, {int categoryId, int eventId, String categoryName, String eventName, DateTime creationDate}) async {
    if(categoryId == null && eventId == null && categoryName == null && eventName == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE event_categories SET ";
      if(categoryId != null) { query += "category_id = $categoryId"; }
      if(eventId != null) { query += "event_id = $eventId "; }
      if(categoryName != null) { query += "category_name = $categoryName"; }
      if(eventName != null) { query += "event_name = $eventName "; }
      if(creationDate != null) { query += "creation_date = '$creationDate' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<List<EventCategory>> getEventCategory({int id, int categoryId, int eventId, String categoryName, String eventName}) async{
    await connect();

    List<EventCategory> result = [];


    String query = "SELECT * from event_categories ";

    if(eventId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(eventId != null) { query += "event_id = $eventId ";}
      else if(categoryId != null) { query += "category_id = $categoryId";}
      else if(categoryName != null) { query += "category_name = $categoryName";}
      else if(eventName != null) { query += "event_name = $eventName";}
      else if(id != null) { query += "id = $id ";}
    }


    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(EventCategory.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}