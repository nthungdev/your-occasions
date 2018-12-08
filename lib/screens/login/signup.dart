
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/utilities/validator..dart';

final UserController _userController = UserController();
List<User> userList = [];

class SignUpWithEmailScreen extends StatefulWidget {
  @override
  _SignUpWithEmailScreen createState() => _SignUpWithEmailScreen();
}

class _SignUpWithEmailScreen extends State<SignUpWithEmailScreen> {
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController password2Controller;
  FocusNode firstNameNode;
  FocusNode lastNameNode;
  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode password2Node;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime birthday;

  bool _isDuplicatedEmail;


  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    password2Controller = TextEditingController();

    firstNameNode = FocusNode();
    lastNameNode = FocusNode();
    emailNode = FocusNode();
    passwordNode = FocusNode();
    password2Node = FocusNode();

    _isDuplicatedEmail = false;
  }

  @override
  void dispose() {
    // Clean up the controllers when the Widget is removed from the Widget tree
    super.dispose();
    firstNameNode.dispose();
    lastNameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    password2Node.dispose();
    
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    password2Controller.dispose();
  }

  String _validateEmail(String input) {
    if (_isDuplicatedEmail) {
      _isDuplicatedEmail = false;
      return "The email address is already in use by another account";
    }
    
    if (!isEmail(input)) {
      return "Invalid Email";
    }

    return null;
  }

  void _submit() async {
    if (!this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      // Validate failed
      print("Invalid login");
      return;
    }

    this._formKey.currentState.save();

    try {
      var userFirebase = await _auth.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text);

      String name = "${firstNameController.text} ${lastNameController.text}";

      User newUser = User(id: userFirebase.uid, email: userFirebase.email, provider: "password", name: name, birthday: birthday);
      await _userController.insert(newUser)
        .then((value) {
          print("Your account is created successfully!");
        }, onError: (e) {
          print("Sign up with email failed");
          print("error $e");
        }
      );
      // String id = userFirebase.uid;

      Navigator.of(context).pop();

      // print(_auth.currentUser());

    } on PlatformException catch (e) {
      print("Error occurs: \n${e.toString()}");
      
      switch (e.message) {
        case "The email address is already in use by another account.":
          print("The email address is already in use by another account.");
          FocusScope.of(context).requestFocus(emailNode);
          _isDuplicatedEmail = true;
          this._emailKey.currentState.validate();
          break;
      }
    }
  }

  String _getDateFormatted(DateTime date) {
    if (date == null) {
      return "MM/DD/YYYY";
    }
    return "${date.month.toString().padLeft(2, "0")}/${date.day.toString().padLeft(2, "0")}/${date.year}";
  }

   String _getTimeFormatted(TimeOfDay time) {
    if (time == null) {
      return "HH:MM AM/PM";
    }
    String hour = (time.hour > 12)
      ? (time.hour - 12).toString().padLeft(2, "0")
      : time.hour.toString().padLeft(2, "0");
    String period = (time.hour > 12) ? 'PM' : 'AM';
    return "$hour:${time.minute.toString().padLeft(2, "0")} $period";
  }

  Future<void> popUpSelectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: birthday == null ? DateTime.now() : birthday,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 2));

      setState(() {
        birthday = picked;
      });
  }

  // Future<void> selectStartTime(BuildContext context) async {
  //   final TimeOfDay picked = await showTimePicker(
  //     context: context,
  //     initialTime: birthday == null ? TimeOfDay.now() : birthday
  //   );

  //   setState(() {
  //     birthday = picked;
  //     _autoValidateDateTime();
  //   });
  // }

  Widget _buildBirthdayInput() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
        width: screen.width / 1.5,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black54,
                    width: 1
                  )
                )
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Birthday",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          popUpSelectStartDate(context);
                        },
                        child: Text(
                          _getDateFormatted(birthday),
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: "Monaco"
                          ),
                        ),
                      ),
                    ],
                  )),
                ]
              )
            )
          ]
        )
      );
    }

  Widget _buildSignUpButton() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5 + 10,
      height: 40,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45))),
        color: Colors.blue,
        onPressed: _submit,
        // color: Colors.lightBlueAccent,
        child: Text('SIGN UP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFirstNameInput() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5,
      child: TextFormField(
        focusNode: firstNameNode,
        controller: firstNameController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        validator: (name) => isName(name) ? null : "Invalid",
        autofocus: false,
        onFieldSubmitted: (term) {
          emailNode.unfocus();
          FocusScope.of(context).requestFocus(lastNameNode);
        },
        decoration: InputDecoration(
          labelText: "FIRST NAME",
          labelStyle: TextStyle(fontWeight: FontWeight.bold)
        ),
      ));
  }

  Widget _buildLastNameInput() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5,
      child: TextFormField(
        focusNode: lastNameNode,
        controller: lastNameController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        validator: (name) => isName(name) ? null : "Invalid",
        autofocus: false,
        onFieldSubmitted: (term) {
          emailNode.unfocus();
          FocusScope.of(context).requestFocus(emailNode);
        },
        decoration: InputDecoration(
          labelText: "LAST NAME",
          labelStyle: TextStyle(fontWeight: FontWeight.bold)
        ),
      ));
  }

  Widget _buildEmailInput() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5,
      child: TextFormField(
        key: _emailKey,
        focusNode: emailNode,
        controller: emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
        autofocus: false,
        onFieldSubmitted: (term) {
          emailNode.unfocus();
          FocusScope.of(context).requestFocus(passwordNode);
        },
        decoration: InputDecoration(
          labelText: "EMAIL",
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          errorMaxLines: 2
        ),
      ));
  }

  Widget _buildPasswordInput() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5,
      child: TextFormField(
        focusNode: passwordNode,
        controller: passwordController,
        autofocus: false,
        validator: (password) => isPassword(password) ? null : "Invalid",
        textInputAction: TextInputAction.next,
        obscureText: true,
        onFieldSubmitted: (term) {
          emailNode.unfocus();
          FocusScope.of(context).requestFocus(password2Node);
        },
        decoration: InputDecoration(
          labelText: "PASSWORD",
          labelStyle: TextStyle(fontWeight: FontWeight.bold)
        )),
    );
  }

  Widget _buildPassword2Input() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5,
      child: TextFormField(
        focusNode: password2Node,
        controller: password2Controller,
        autofocus: false,
        validator: (password) => isPassword(password) ? null : "Invalid",
        textInputAction: TextInputAction.done,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "COMFIRM PASSWORD",
          labelStyle: TextStyle(fontWeight: FontWeight.bold)
        )),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () { Navigator.of(context).pop(); },
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        // title: Text("Sign Up"),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: screen.height * 0.1,),
                _buildFirstNameInput(),
                _buildLastNameInput(),
                _buildEmailInput(),
                _buildBirthdayInput(),
                _buildPasswordInput(),
                _buildPassword2Input(),
                SizedBox(height: screen.height * 0.05,),
                _buildSignUpButton(),
              ],
            ),
          ),
        ]
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
