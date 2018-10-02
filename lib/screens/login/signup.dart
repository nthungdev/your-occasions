//import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
//import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/utilities/validator..dart';

final UserController _userController = UserController();
bool _isSigningUp = false;
List<User> userList = [];

class SignUpWithEmailScreen extends StatefulWidget {
  @override
  _SignUpWithEmailScreen createState() => _SignUpWithEmailScreen();
}

class _SignUpWithEmailScreen extends State<SignUpWithEmailScreen> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  static final passwordController = new TextEditingController();
  static final password2Controller = new TextEditingController();
  static final emailController = new TextEditingController();
  static final firstNameController = new TextEditingController();
  static final lastNameController = new TextEditingController();

  final formKey = new GlobalKey<FormState>();
  // @override
  // void dispose() {
  //   // Clean up the controller when the Widget is removed from the Widget tree
  //   passwordController.dispose();
  //   emailController.dispose();
  //   super.dispose();
  // }

  void _submit() async {
    final form = formKey.currentState;

    userList = await _userController.getUser(email: emailController.text);

    if (form.validate()) {
      form.save();
      bool result = await signUp();
      print(result);
      if(result) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  }

  String _validateEmail(String email) {
    if(!isEmail(email)) { return "Invalid email"; }
   
    if(userList.length == 0) { return null; }
    else { return "Already taken email!"; }
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

  Widget signUpButton() {
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
              _submit();
            },
            // color: Colors.lightBlueAccent,
            child: Text('Sign Up', style: TextStyle(color: Colors.black)),
          ),
        ));
  }

  Widget firstNameForm() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 120.0,
        child: TextFormField(
          controller: firstNameController,
          keyboardType: TextInputType.emailAddress,
          validator: (name) => !isName(name) ? "Invalid name" : null,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'First Name',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget lastNameForm() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 120.0,
        child: TextFormField(
          controller: lastNameController,
          keyboardType: TextInputType.emailAddress,
          validator: (name) => !isName(name) ? "Invalid name" : null,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Last Name',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget emailForm() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 260.0,
        // color: const Color(0xFF00FF00),
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          // validator: (email) !_validateEmail(email) ? "Invalid email" : null,
          validator: (email) => _validateEmail(email),
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget passwordForm() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      child: TextFormField(
          controller: passwordController,
          autofocus: false,
          keyboardType: TextInputType.text,
          validator: (password) => !isPassword(password) ? "Invalid password" : null,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          )),
    );
  }

  Widget password2Form() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      child: TextFormField(
          controller: password2Controller,
          autofocus: false,
          keyboardType: TextInputType.text,
          validator: (password) => !isPasswordMatched(passwordController.text, password) ? "Password not matched!" : null,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          )),
    );
  }


  Future<bool> signUp() async {
    if (!_isSigningUp) {
      _isSigningUp = true;
      String name = "${firstNameController.text} ${lastNameController.text}";
      String email = emailController.text;
      String password = passwordController.text;
      User newUser = User(name: name, email: email, password: password);
      print("DEBUG new user is : $newUser");
      _userController.insert(newUser)
        ..then((value) {
          print("DEBUG name is : ${newUser.name}");
          print("Your account is created successfully!");
        }, onError: (e) {
          print("Sign up failed");
          print(e);
        });
      _isSigningUp = false;
      return true;
    }
    return false;
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  firstNameForm(),
                  lastNameForm()
              ],),
              emailForm(),
              passwordForm(),
              password2Form(),
              signUpButton(),
              switchPageButton()
            ]
          ),
        )
      )
    );
  }
}

bool isPasswordMatched(String password, String passwordRetype) {
  if (password == passwordRetype) {
    return true;
  }
  return false;
}
