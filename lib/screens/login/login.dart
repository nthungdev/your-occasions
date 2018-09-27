import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';

final UserController _userController = UserController();

class LoginWithEmailScreen extends StatelessWidget {

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
            Text("Email"),
          
          ]
        ),
      )
    );
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