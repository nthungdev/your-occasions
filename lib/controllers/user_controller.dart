import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/Models/user.dart';
import 'package:youroccasions/exceptions/UpdateQueryException.dart';

class UserController extends BaseController {
  // PROPERTIES //
  int _count;
  List<User> _allUsers;

  // CONSTRUCTORS //
  UserController() : super();

  // GETTERS //
  List<User> get allUsers => _allUsers;
  int get count => _count;

  // SETTERS //
  

  // METHODS //
  /// Insert a new row into users table.
  Future<void> insert(User model) async {
    await connect();

    await connection.query("""INSERT INTO users (name, email, password, birthday, is_used, creation_date)
      VALUES (@name, @email, @password, @birthday, @isUsed, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  /// Delete an existing row from users table.
  Future<void> delete(int id) async {
    await connect();

    await connection.query("""DELETE FROM users WHERE id = @id""", substitutionValues: { 'id': id, });  

    await disconnect();
  }

  /// Update an existing row from users table.
  Future<void> update(int id, {String name, String email, String password, DateTime birthday, String picture, bool isUsed}) async {
    if(name == null && email == null && password == null && birthday == null && picture == null && isUsed == null) {
      throw UpdateQueryException(); //
    }
    else {
      await connect();

      String query = "UPDATE users SET ";
      if(name != null) { query += "name = '$name' "; }
      if(email != null) { query += "email = '$email' "; }
      if(password != null) { query += "password = '$password' "; }
      if(birthday != null) { query += "birthday = '$birthday' "; }
      if(picture != null) { query += "picture = '$picture' "; }
      if(isUsed != null) { query += "is_used = '$isUsed' "; }

      query += " WHERE id = '$id'";

      await connection.query(query);  

      await disconnect();
    }
    
    
  }

  /// Select all rows from users table and return a list of User objects.
  Future<List<User>> getAllUsers([String orderBy, bool asc = true]) async {
    await connect();

    List<User> result = [];
    var queryResult = await connection.mappedResultsQuery("""SELECT * FROM users ORDER BY $orderBy ${asc ? 'ASC' : 'DESC'}""");
    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }

    await disconnect();

    _count = result.length;
    _allUsers = result;

    return result;
  }

  Future<List<User>> getUser({String email, String name, int id}) async{
    await connect();

    List<User> result = [];


    String query = "SELECT * from users where ";
    if(name != null) { query += "name = '$name' "; }
    if(email != null) { query += "email = '$email' "; }
    if(id != null) { query += "id = $id ";}

    var queryResult = await connection.mappedResultsQuery(query);

    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }

    await disconnect();

    return result;
  }

  void test() async {
    // update(9);
    List<User> result = await getUser(id: 5);
    print(result);

  }
}

  

void main() {
  UserController test = UserController();
  test.test();

}