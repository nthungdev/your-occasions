import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/category.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class CategoryController extends BaseController {
  // PROPERTIES //
  int _count;
  List<Category> _allCategories;

  // CONSTRUCTORS //
  CategoryController() : super();

  // GETTERS //
  List<Category> get allCategories => _allCategories;
  int get count => _count;

  // SETTERS //
  

  // METHODS //
  /// Insert a new row into Events table.
  Future<void> insert(Category model) async {
    await connect();

    await connection.query("""INSERT INTO categories (name, description, is_used, creation_date)
      VALUES (@name, @description, @isUsed, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from Events table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM categories WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from Events table based on id.
  Future<void> update(int id, {String name, String description, bool isUsed, DateTime creationDate}) async {
    
    if(name == null && description == null && isUsed == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE categories SET ";
      if(name != null) { query += "name = '$name' "; }
      if(description != null) { query += "email = '$description "; }
      if(isUsed != null) { query += "is_used = '$isUsed'"; }
      if(creationDate != null) { query += "creation_date = $creationDate "; }

      query += " WHERE id = '$id'";

      await connection.query(query);

      await disconnect();
    }
  }

  /// Select rows from users table and return a list of User objects.
  Future<List<Category>> getCategory({int id, String name}) async {
    await connect();

    List<Category> result = [];

    String query = "SELECT * FROM categories ";

    if(name == null && id == null) {

    }
    else {
      query += "WHERE ";
      if (name != null) { query += "name = '$name' "; }
      else if (id != null) { query += "id = $id "; }
    }
    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(Category.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }
  
  Future<void> test() async {
  }
}

void main () {
  CategoryController e = CategoryController();


}