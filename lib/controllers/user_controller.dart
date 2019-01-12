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
    await connection.query("""INSERT INTO users (id, name, email, provider, birthday, is_used, creation_date, picture)
      VALUES (@id, @name, @email, @provider, @birthday, @isUsed, @creationDate, @picture)""",
      substitutionValues: model.getProperties());
    await disconnect();
  }

  Future<void> updateUser(String id, String name, DateTime birthday) async{
    await connect();

    await connection.query("""UPDATE users SET name = @name , birthday = @birthday WHERE id = @id""", 
    substitutionValues: {
      'name': name,
      'birthday': birthday,
      'id': id, 
      });

    await disconnect();

  }

  /// Delete an existing row from users table.
  Future<void> delete(int id) async {
    await connect();
    await connection.query("""DELETE FROM users WHERE id = @id""", substitutionValues: { 'id': id, });  
    await disconnect();
  }

  Future<void> increaseFollowers(String id) async {
    await connect();

    await connection.query("""UPDATE users SET followers = followers + 1 WHERE id = @id""", substitutionValues: { 'id': id, });
    
    await disconnect();
  }

  Future<void> decreaseFollowers(String id) async {
    await connect();

    await connection.query("""UPDATE users SET followers = followers - 1 WHERE id = @id""", substitutionValues: { 'id': id, });
    
    await disconnect();
  }

  /// Update an existing row from users table.
  Future<void> update(String id, {String name, String email, String password, DateTime birthday, String picture, 
  int one, int two, int three, int four, int five, double rating, bool isUsed}) async {
    if(name == null && email == null && password == null && birthday == null && picture == null 
    && one == null && two == null && three == null && four == null && five == null && rating == null && isUsed == null) {
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
      if(one != null) { query += "one = $one "; }
      if(two != null) { query += "two = $two "; }
      if(three != null) { query += "three = $three "; }
      if(four != null) { query += "four = $four "; }
      if(five != null) { query += "five = $five "; }
      if(rating != null) { query += "rating = $rating "; }
      if(isUsed != null) { query += "is_used = '$isUsed' "; }

      query += "WHERE id = '$id' ";
      await connection.query(query);  
      await disconnect();
    }
  }

  /// Select rows from users table and return a list of User objects.
  Future<List<User>> getUsers({ String id, String email, String name, String provider, bool isUsed=true}) async{
    await connect();
    List<User> result = [];
    String query = "SELECT * FROM users ";
    if(email == null && name == null && id == null) {

    }
    else {
      query += "WHERE ";
      if(name != null) { query += "upper(name) LIKE upper('%$name%') "; }
      else if(email != null) { query += "email = @email "; }
      else if(provider != null) { query += "provider = @provider "; }
      else if(id != null) { query += "id = @id ";}
    }
    // print("DEBUG email is: $email");
    // query += "AND is_used = @isUsed;";
    // print("DEBUG QUERY IS $query");
    var queryResult = await connection.mappedResultsQuery(query, 
    substitutionValues: { 
      'email' : email,
      'id' : id,
      'name' : name,
      'provider' : provider,
      'isUsed' : isUsed,
    });
    // print("DEBUG RESULT is : $queryResult");
    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }
    await disconnect();
    return result;
  }

  Future<User> getUserWithEmail(String email) async{
    await connect();
    List<User> result = [];
    String query = "SELECT * FROM users WHERE email = @email ";
    
    var queryResult = await connection.mappedResultsQuery(query, substitutionValues: { 'email': email });
    
    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }

    if (result.length == 0) { return null; }

    await disconnect();
    return result[0];
  }

  Future<User> getUserWithId(String id) async{
    await connect();
    List<User> result = [];
    String query = "SELECT * FROM users WHERE id = @id ";
    
    var queryResult = await connection.mappedResultsQuery(query, substitutionValues: { 'id': id });
    
    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }

    if (result.length == 0) { return null; }

    await disconnect();
    return result[0];
  }

  Future<User> getUserWithFacebook(String email) async{
    await connect();
    List<User> result = [];
    String query = "SELECT * FROM users WHERE email = @email AND provider = 'facebook'";
    
    var queryResult = await connection.mappedResultsQuery(query, substitutionValues: { 'email': email });
    
    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }

    if (result.length == 0) { return null; }

    await disconnect();
    return result[0];
  }

  Future<User> getUserWithGoogle(String email) async{
    await connect();
    List<User> result = [];
    String query = "SELECT * FROM users WHERE email = @email AND provider = 'google'";
    
    var queryResult = await connection.mappedResultsQuery(query, substitutionValues: { 'email': email });
    
    for (var item in queryResult) {
      result.add(User.createFromMap(item.values));
    }

    if (result.length == 0) { return null; }

    await disconnect();
    return result[0];
  }

  Future<List<User>> getMostFollowedUsers() async {
    await connect();
    var query = "SELECT * FROM mostfollowedusers()";
    var queryResult = await connection.mappedResultsQuery(query);
    print(queryResult);
    await disconnect();
    return List<User>.generate(queryResult.length, (index) {
      return User.createFromMap(queryResult[index].values);
    });
  }
  
  /// Check email and password is valid in the database or not.
  /// 
  /// Return User object if valid, null otherwise.
  // Future<User> loginWithEmail(String email, String password) async {
  //   var result = await getUser(email: email);
  //   // print("DEBUG RESULT IS : $result");
  //   if(result.length != 0) {
  //     User loginUser = result[0];
  //     if(loginUser.password == password) { return result[0]; }
  //   }
  //   return null;
  // }

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


void main() async {
  UserController test = UserController();
  // test.test();
  // Future<User> loginResult = test.loginWithEmail('nthungdev@gmail.com', '1')
  //   ..then((value) { print("VALUE is $value");} );
  // // print(loginResult);
  
  // print(loginResult);
  // if(test.loginWithEmail("nthungdev@gmail.com", "1"))

  // var connection = PostgreSQLConnection(host, port, databaseName, username: username, password: password, useSSL: true);
  // await connection.open();
  // String query = "select * from test(50)";
  // var queryResult = await connection.mappedResultsQuery(query);
  // print(queryResult);
  // await connection.close();

  print(await test.getMostFollowedUsers());




}