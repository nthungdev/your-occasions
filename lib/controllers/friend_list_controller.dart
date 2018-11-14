//ib
import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/friend_list.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class FriendListController extends BaseController{
  // PROPERTIES //

  // CONSTRUCTORS //

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into friendlists table.
  Future<void> insert(FriendList model) async {
    await connect();

    await connection.query("""INSERT INTO friendlists (user_id, friend_id, creation_date)
      VALUES (@userId, @friendId, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from friendlists table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM friendlists WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  Future<void> deleteFriend(int userId, int friendId) async {
    await connect();

    await connection.query("""DELETE FROM friendlists WHERE user_id = @userId AND friend_id = @friendId""", substitutionValues: { 'userId': userId,'friendId': friendId });  

    await disconnect();
  }

  /// Update an existing row from friendlists table.
  Future<void> update(int id, {int, userId, int friendId, DateTime creationDate}) async {
    if(userId == null && friendId == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE friendlists SET ";
      if(userId != null) { query += "user_id = $userId"; }
      if(friendId != null) { query += "friend_id = $friendId"; }
      if(creationDate != null) { query += "creation_date = '$creationDate' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<bool> getFriend(int userId, int friendId) async{
    await connect();

    List<FriendList> result = [];


    String query = "SELECT * from friendlists ";

    query += """where user_id = $userId AND friend_id = $friendId""";

    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(FriendList.createFromMap(item.values));
    }

    await disconnect();

    return result == [];
  }


  Future<List<FriendList>> getFriendList({int userId, int id}) async{
    await connect();

    List<FriendList> result = [];


    String query = "SELECT * from friendlists ";

    if(userId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(userId != null) { query += "user_id = $userId";}
      else if(id != null) { query += "id = $id ";}
    }


    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(FriendList.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}
