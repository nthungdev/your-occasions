import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';

final UserController _userController = UserController();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                )
              ),
              child: Text("Type your Email")
            ),
            emailInput,
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                )
              ),
              child: Text("Type your password")
            ),
            passwordInput,
            Padding(
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
                    if(result) {
                      // print("success");
                    }
                    else{
                      // print("login unsuccessful");
                    }
                  },
                  // color: Colors.lightBlueAccent,
                  child: Text('Log In', style: TextStyle(color: Colors.black)),
                ),
              )
            ),
          ]
        ),
      )
    );
  }

  final emailInput = Container(
    margin: const EdgeInsets.all(10.0),
    width: 250.0,
    color: const Color(0xFF00FF00),
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: 'dsds',
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    )
  );

  final passwordInput = Container(
    margin: const EdgeInsets.all(10.0),
    width: 250.0,
    color: const Color(0xFF00FF00),
    child: TextFormField(
      controller: passwordController,
      autofocus: false,
      // initialValue: 'dsd',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      )
    ),
  );

  final loginButton = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.lightBlueAccent.shade100,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () { 
        } ,
        // color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.black)),
      ),
    )
  );

  Future<bool> login() async {
    String email = emailController.text;
    print("DEBUG  email text : ${emailController.text}");
    String password = passwordController.text;
    User loginUser = await _userController.loginWithEmail(email, password);
    if(loginUser != null) {
      print("Login sucessfully!");
      return true;
    }
    else {
      print("\nEither your email or password is not correct!\nPlease retype your email and/or password!");
      return false;
    }
  
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
  while(true) {
    print("What is your password?");
    password = stdin.readLineSync();
    print("Please retype your password");
    String passwordRetype = stdin.readLineSync();
    if(isPasswordMatched(password, passwordRetype)) { break; }
    print("Your passwords are not matched!");
  }
  print("What is your date of birth (yyyy-mm-dd)");
  DateTime birthday = DateTime.parse(stdin.readLineSync());
  print("DEBUG : name = $name | email = $email | password = $password");
  User newUser = User(name: name, email: email, password: password, birthday: birthday);
  print("DEBUG new user is : $newUser");
  _userController.insert(newUser)
    ..then((value) {
      print("DEBUG name is : ${newUser.name}");
      print("Your account is created successfully!");
    }, onError: (e) { print("Sign up failed"); });
}

void login() async {
  bool isLogin = true;
  while(isLogin) {
    print("What is your email?");
    String email = stdin.readLineSync();
    print("Please type your password");
    String password = stdin.readLineSync();
    User loginUser = await _userController.loginWithEmail(email, password);
    print("DEBUG user is: $loginUser");
    if(loginUser != null) {
      print("Login sucessfully!");
      isLogin = false;
    }
    else {
      print("\nEither your email or password is not correct!\nPlease retype your email and/or password!");
    }
  }
}

bool isPasswordMatched(String password, String passwordRetype) {
  if(password == passwordRetype) { return true; }
  return false;
}

void main() {
  while(true) {
    print("Welcome to Your Occasions!");
    print("Do you wanna (L)ogin or (S)ign up?");
    String answer = stdin.readLineSync();
    if(["l", "login"].contains(answer.toLowerCase().trim())) {
      login();
      break;
    }
    else if (['s','signup'].contains(answer.toLowerCase().trim())) {
      signup();
      break;
    }
  }
}