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

    await connection.query("""INSERT INTO friend_lists (user_id, friend_id, creation_date)
      VALUES (@userId, @friendId, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from friendlists table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM friend_lists WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  Future<void> deleteFriend(String userId, String friendId) async {
    await connect();

    await connection.query("""DELETE FROM friend_lists WHERE user_id = @userId AND friend_id = @friendId""", substitutionValues: { 'userId': userId,'friendId': friendId });  

    await disconnect();
  }

  /// Update an existing row from friendlists table.
  Future<void> update(int id, {String userId, String friendId, DateTime creationDate}) async {
    if(userId == null && friendId == null && creationDate == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE friend_lists SET ";
      if(userId != null) { query += "user_id = '$userId' "; }
      if(friendId != null) { query += "friend_id = '$friendId'"; }
      if(creationDate != null) { query += "creation_date = '$creationDate' "; }

      query += " WHERE id = '$id'";

      await connection.query(query); 

      await disconnect();
    }
  }

  Future<bool> getFriend(String userId, String friendId) async{
    await connect();

    List<FriendList> result = [];


    String query = "SELECT * from friend_lists ";

    query += """where user_id = @userId AND friend_id = @friendId """;
    // print(query);
    var queryResult = await connection.mappedResultsQuery(query, substitutionValues: {
      'userId': userId,
      'friendId': friendId,
    });

    for (var item in queryResult) {
      result.add(FriendList.createFromMap(item.values));
    }

    await disconnect();

    print(result);

    return result.isNotEmpty;
  }

  Future<List<FriendList>> getFriendList({int id, String userId, String friendId}) async{
    await connect();

    List<FriendList> result = [];


    String query = "SELECT * from friend_lists ";

    if(userId == null && id == null) {

    }
    else {
      query += "where ";
      
      if(userId != null) { query += "user_id = '$userId' " ; }
      else if (friendId != null) { query += "friend_id = '$friendId' "; }
      else if(id != null) { query += "id = $id "; }
    }

    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      print(item.values);
      result.add(FriendList.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

}
