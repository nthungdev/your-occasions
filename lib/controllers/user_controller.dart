import 'package:postgres/postgres.dart';
import 'base_controller.dart';
import '../models/user.dart';

class UserController extends BaseController {
  List<User> _allModel;


  UserController() : super();

  void insertUser(User model) async {
    connect();
    
    List result = await connection.query("""INSERT INTO table (name, email, password, birthday, is_used, creation_date)
      VALUES (${model.name}, ${model.email}, ${model.password}, ${model.birthday}, ${model.isUsed}, ${model.creationDate});""");

    disconnect();

    print(result);

  }

  void test() async {
    await connect();
    
    print("1");

    // List<List<dynamic>> result = await connection.query("INSERT INTO users (name) VALUES (@name)", 
      // substitutionValues: {"name": "Hung",});

    
    List<List<dynamic>> result2 = await connection.query("select * from users");


    List<Map<String, Map<String, dynamic>>> result3 = await connection.mappedResultsQuery("select * from users");


    print("2");
    disconnect();

    print("3");
    // print(result);

    print(result2);

    // print("result 3: \n $result3");

    List<User> alist = [];

    for (var item in result3){
      // print("item is " + item.toString());
      // print(item.values);
      
      // print(item);
      var map = item.values;
      // print(map);

      map.forEach((item) {
        User newUser = User.create();
        newUser.id = item['id'];
        newUser.name = item['name'];
        newUser.email = item['email'];
        newUser.password = item['password'];
        newUser.birthday = item['birthday'];
        newUser.picture = item['picture'];
        newUser.isUsed = item['is_used'];
        newUser.creationDate = item['creation_date'];
        
        newUser.printInfo();
      });

    }

  }
}

void main() {
  UserController test = UserController();
  test.test();
}