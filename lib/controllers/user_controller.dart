import 'dart:async';

import 'package:postgres/postgres.dart';
import 'base_controller.dart';
import '../models/user.dart';

class UserController extends BaseController {
  // PROPERTIES //
  List<User> _allModel;

  // CONSTRUCTORS //
  UserController() : super();

  // GETTERS //


  // SETTERS //
  

  // METHODS //
  /// Insert a new row into database.
  Future<void> insert(User model) async {
    await connect();

    await connection.query("""INSERT INTO users (name, email, password, birthday, is_used, creation_date)
      VALUES (@name, @email, @password, @birthday, @isUsed, @creationDate)""",
      substitutionValues: model.getProperties());

    await disconnect();
  }

  void test() async {
    print("1");

    // List<List<dynamic>> result = await connection.query("INSERT INTO users (name) VALUES (@name)", 
      // substitutionValues: {"name": "Hung",});

    
    // // List<List<dynamic>> result2 = await connection.query("select * from users");


    // List<Map<String, Map<String, dynamic>>> result3 = await connection.mappedResultsQuery("select * from users");


    // print("2");
    // disconnect();

    // print("3");
    // // print(result);

    // // print(result2);

    // // print("result 3: \n $result3");

    // List<User> alist = [];

    // for (var item in result3){
    //   // print("item is " + item.toString());
    //   // print(item.values);
      
    //   // print(item);
    //   var map = item.values;
      
    //   User auser = User.createFromMap(map);
    //   auser.printInfo();
    // }

    var auser = User.create();
    auser.name = 'Hunger';
    auser.email = 'nthungdev@gmail.com';
    auser.birthday = DateTime(1998, 7, 5);
    auser.creationDate = DateTime.now();

    insert(auser);

  }
}

void main() {
  UserController test = UserController();
  test.test();
}