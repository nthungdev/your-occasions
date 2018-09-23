import 'dart:async';

import 'package:youroccasions/controllers/base_controller.dart';
import 'package:youroccasions/models/user.dart';
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

  /// Select rows from users table and return a list of User objects.
  Future<List<User>> getUser({String email, String name, int id, bool isUsed=true}) async{
    await connect();
    List<User> result = [];
    String query = "SELECT * FROM users ";
    if(email == null && name == null && id == null) {

    }
    else {
      query += "WHERE ";
      if(name != null) { query += "name = @name "; }
      else if(email != null) { query += "email = @email "; }
      else if(id != null) { query += "id = @id ";}
    }

    query += "AND is_used = @isUsed;";
    // print("DEBUG QUERY IS $query");
    var queryResult = await connection.mappedResultsQuery(query, 
    substitutionValues: { 
      'email' : email,
      'id' : id,
      'name' : name,
      'isUsed' : isUsed,
    });
    // print("DEBUG RESULT is : $queryResult");
    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }
    await disconnect();
    return result;
  }
  
  /// Check email and password is valid in the database or not.
  /// 
  /// Return User object if valid, null otherwise.
  Future<User> loginWithEmail(String email, String password) async {
    var result = await getUser(email: email);
    // print("DEBUG RESULT IS : result");
    if(result.length != 0) {
      User loginUser = result[0];
      if(loginUser.password == password) { return result[0]; }
    }
    return null;
  }

  void test() async {
    // update(9);
    // List<User> result = await getUser(id: 5);
    // print(result);
    // await connect();
    // await connection.query("""SELECT * FROM users WHERE email = @email """,
    // substitutionValues: {'email' : "nthungdev@gmail.com"});
    // await disconnect();
  }

}

void main() {
  UserController test = UserController();
  test.test();
  Future<User> loginResult = test.loginWithEmail('nthungdev@gmail.com', '1')
    ..then((value) { print("VALUE is $value");} );
  // print(loginResult);
  
  // print(loginResult);
  // if(test.loginWithEmail("nthungdev@gmail.com", "1"))
}