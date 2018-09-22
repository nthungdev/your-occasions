import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/user_rating.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class EvenRatingController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into user_ratings table.
  Future<void> insert(UserRating model) async {
    await connect();

    await connection.query("""INSERT INTO user_ratings (user_id, one, two, three, four, five, rating)
      VALUES (@userId, @one, @two, @three, @four, @five, @rating)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from user_ratings table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM user_ratings WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from user_ratings table.
  Future<void> update(int id, {int userId, int one, int two, int three, int four, int five, double rating}) async {
    if(userId == null && one == null && two == null && three == null && four == null && five == null && rating == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE user_ratings SET ";
      if(userId != null) { query += "user_id = $userId "; }
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

  Future<List<UserRating>> getUserRating({int userId , int id}) async{
    await connect();

    List<UserRating> result = [];


    String query = "SELECT * from user_ratings ";

    if(userId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(userId != null) { query += "user_id = $userId ";}
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