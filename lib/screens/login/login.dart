import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/utilities/validator..dart';

final UserController _userController = UserController();
bool _isLogging = false;

class LoginWithEmailScreen extends StatefulWidget {
  @override
  _LoginWithEmailScreen createState() => _LoginWithEmailScreen();
}

class _LoginWithEmailScreen extends State<LoginWithEmailScreen> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  static final passwordController = new TextEditingController();
  static final emailController = new TextEditingController();

   @override
   void dispose() {
     // Clean up the controller when the Widget is removed from the Widget tree
     passwordController.dispose();
     emailController.dispose();
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.red,
                  )),
                  child: Text("Type your Email")),
              emailInput(),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.red,
                  )),
                  child: Text("Type your password")),
              passwordInput(),
              loginButton(),
              switchPageButton()
            ]
          ),
        )
      )
    );
  }

  Future<Null> _loginUnsuccessful() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Rewind and remember'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('You will never be satisfied.'),
                new Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget switchPageButton() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            // color: Colors.lightBlueAccent,
            child: Text('Go to Home', style: TextStyle(color: Colors.black)),
          ),
        ));
  }

  Widget loginButton() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () async {
              bool result = await login();
              if (result) {
                // print("success");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
                // _loginUnsuccessful();
                // print("login unsuccessful");
              }
            },
            // color: Colors.lightBlueAccent,
            child: Text('Log In', style: TextStyle(color: Colors.black)),
          ),
        ));
  }

  Widget emailInput() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 250.0,
        // color: const Color(0xFF00FF00),
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (email) => isEmail(email) ? "Invalid" : "Valid",
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget passwordInput() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      // color: const Color(0xFF00FF00),
      child: TextFormField(
          controller: passwordController,
          autofocus: false,
          keyboardType: TextInputType.text,
          // initialValue: 'dsd',
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          )),
    );
  }

  Future<bool> login() async {
    if (!_isLogging) {
      _isLogging = true;
      String email = emailController.text;
      String password = passwordController.text;
      // print("DEBUG email text : ${emailController.text}");
      User loginUser = await _userController.loginWithEmail(email, password);
      if (loginUser != null) {
        print("Login sucessfully!");
        // Saved user's id and email on device
        setIsLogin(true);
        setUserId(loginUser.id);
        setUserEmail(loginUser.email);
        _isLogging = false;
        return true;
      } else {
        print("\nEither your email or password is not correct!\nPlease retype your email and/or password!");
        return false;
      }
    }
    return false;
  }
}

void signup() {
  print("What is your full name?");
  String name = stdin.readLineSync();
  print("DEBUG input name is: $name");
  print("What is your email?");
  String email = stdin.readLineSync();
  print("DEBUG input email is: $email");
  String password;
  while (true) {
    print("What is your password?");
    password = stdin.readLineSync();
    print("Please retype your password");
    String passwordRetype = stdin.readLineSync();
    if (isPasswordMatched(password, passwordRetype)) {
      break;
    }
    print("Your passwords are not matched!");
  }
  print("What is your date of birth (yyyy-mm-dd)");
  DateTime birthday = DateTime.parse(stdin.readLineSync());
  print("DEBUG : name = $name | email = $email | password = $password");
  User newUser =
      User(name: name, email: email, password: password, birthday: birthday);
  print("DEBUG new user is : $newUser");
  _userController.insert(newUser)
    ..then((value) {
      print("DEBUG name is : ${newUser.name}");
      print("Your account is created successfully!");
    }, onError: (e) {
      print("Sign up failed");
    });
}

void login() async {
  bool isLogin = true;
  while (isLogin) {
    print("What is your email?");
    String email = stdin.readLineSync();
    print("Please type your password");
    String password = stdin.readLineSync();
    User loginUser = await _userController.loginWithEmail(email, password);
    print("DEBUG user is: $loginUser");
    if (loginUser != null) {
      print("Login sucessfully!");
      isLogin = false;
    } else {
      print(
          "\nEither your email or password is not correct!\nPlease retype your email and/or password!");
    }
  }
}

bool isPasswordMatched(String password, String passwordRetype) {
  if (password == passwordRetype) {
    return true;
  }
  return false;
}

void main() {
  while (true) {
    print("Welcome to Your Occasions!");
    print("Do you wanna (L)ogin or (S)ign up?");
    String answer = stdin.readLineSync();
    if (["l", "login"].contains(answer.toLowerCase().trim())) {
      login();
      break;
    } else if (['s', 'signup'].contains(answer.toLowerCase().trim())) {
      signup();
      break;
    }
  }
}
