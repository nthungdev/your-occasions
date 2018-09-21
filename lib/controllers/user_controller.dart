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
    List<List<dynamic>> result = await connection.query("""INSERT INTO users (name) VALUES ('Hung')""");

    print("2");
    disconnect();

    print("3");
    print(result);

  }
}

void main() {
  UserController test = UserController();
  test.test();
}