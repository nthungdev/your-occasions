import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youroccasions/models/data.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/screens/login/signup.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/utilities/validator..dart';

final UserController _userController = UserController();

const String ERROR_CODE_00 = "User is not registered";
const String ERROR_CODE_01 = "The password is invalid or the user does not have a password";
const String ERROR_CODE_02 = "The email address is badly formatted";
const String ERROR_CODE_03 = "There is no user record corresponding to this identifier. The user may have been deleted";
const String ERROR_CODE_04 = "Given String is empty or null";

class LoginWithEmailScreen extends StatefulWidget {
  @override
  _LoginWithEmailScreen createState() => _LoginWithEmailScreen();
}

class _LoginWithEmailScreen extends State<LoginWithEmailScreen> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  TextEditingController passwordController;
  TextEditingController emailController;
  FocusNode emailNode;
  FocusNode passwordNode;
  String emailErrorMessage;
  String passwordErrorMessage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    print("ENTER LOGIN SCREEN");
    passwordController = TextEditingController();
    emailController = TextEditingController();
    emailNode = FocusNode();
    passwordNode = FocusNode();
  }

  @override
  void dispose(){
    super.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void showSnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1),
    ));
  }

  void _loginWithEmail() async {
    try {
      if (!this._formKey.currentState.validate()) {
        this._formKey.currentState.save();
        // Validate failed
        print("Invalid login");
        return;
      }
      this._formKey.currentState.save();
      
      // print("DEBUG signin email : " + signInEmail);
      var userFirebase = await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      // String id;
      // print("User firebase is : $userFirebase");
      // await userFirebase.getIdToken().then((idToken) => id = idToken);
      // print("Id is : $id");

      await setUserId(userFirebase.uid);
      await setIsLogin(true);
      await setUserEmail(userFirebase.email);
      await setUserName(userFirebase.displayName);
      Dataset.currentUser.value = await _userController.getUserWithEmail(userFirebase.email);
      print("User: ");
      print(Dataset.currentUser.value);

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
    }
    catch (e) {
      print("Error occurs: \n$e");
      if(e.toString().contains(ERROR_CODE_01)) {
        passwordErrorMessage = "Incorrect password";
      }
      else if(e.toString().contains(ERROR_CODE_02)) {
        // TODO handle username case and email case separately
        emailErrorMessage = "Incorrect format username or email";
      }
      else if (e.toString().contains(ERROR_CODE_03)) {
        showSnackbar("The user has not registered!");
      }
      else if (e.toString().contains(ERROR_CODE_04)) {
        emailErrorMessage = "Email or username cannot be blank";
        passwordErrorMessage = "Password cannot be blank";
      }
      else {
        print("Unhandled Error!");
        passwordErrorMessage = "Invalid password";
        emailErrorMessage = "Invalid email";
        showSnackbar("Unhandled Error!");
      }
    }

  }

  void _loginWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleUser = await _googleSignIn.signIn().catchError((error) {
        print("Error occurs: \n$error");
      });
      if (googleUser == null) return;
      print(googleUser);
      print("googleUser User's picture: ${googleUser.photoUrl}");
      /// Check email is used on any other user or not.
      /// If yes, stop. 
      User userFromDB = await _userController.getUserWithGoogle(googleUser.email);
      if (userFromDB != null && userFromDB.provider != "google") { 
        showSnackbar("Email is used");
        print("Email is used");
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      FirebaseUser firebaseUser = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("uid: ${firebaseUser.uid}");

      if (userFromDB == null) {
        User newUser = User(id: firebaseUser.uid, name: firebaseUser.displayName, email: firebaseUser.email, picture: firebaseUser.photoUrl, provider: "google");
        await _userController.insert(newUser)
          .then((value) {
            print("DEBUG name is : ${newUser.name}");
            print("Your account is created successfully!");
          }, onError: (e) {
            print("Sign up with Google failed");
            print("error $e");
          }
        );
      }
      
      await setUserId(firebaseUser.uid);
      await setUserEmail(firebaseUser.email);
      await setUserName(firebaseUser.displayName);
      
      print("Firebase User's picture: ${firebaseUser.photoUrl}");
      Dataset.currentUser.value = await _userController.getUserWithEmail(firebaseUser.email);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);

    }
    catch (e) {
      print("error $e");
    }

  }

  void handleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    return;
  }

  Widget _buildLoginButton() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5 + 10,
      height: 40,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45))),
        color: Colors.blue,
        onPressed: _loginWithEmail,
        // color: Colors.lightBlueAccent,
        child: Text('LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _facebookLogin() async {
    var userName, email, pic, id;
    FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result =
    await facebookSignIn.logInWithReadPermissions(['email']);
    //,publish_actions,manage_pages,publish_pages,user_status,user_videos,user_work_history

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        accessToken.permissions;

        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,picture,last_name,email&access_token=${accessToken.token}');
        Map<String,dynamic> user = json.decode(graphResponse.body);
        Map<String,dynamic> picture = user['picture'];
        Map<String,dynamic> data = picture['data'];
        userName = user['name'];
        email = user['email'];
        pic = data['url'];
        id = user['id'];
        // var graphResponseFeed = await http.get('https://graph.facebook.com/v2.12/me/feed?fields=message&access_token=${accessToken.token}');
        // var profile = json.decode(graphResponseFeed.body);
      // print(data1);

      // me?fields=id,name,feed{message,attachments}
        // var graphResponseFeed1 = await http.get('https://graph.facebook.com/v2.12/me?fields=id,name,feed{attachments,message}&access_token=${accessToken.token}');
        // var data1l = json.decode(graphResponseFeed1.body);
        // Map<String,dynamic> root = json.decode(graphResponseFeed1.body);
        // Map <String,dynamic> feed = root['feed'];
        // var fdata = feed['data'];

        User userFromDB = await _userController.getUserWithFacebook(email);

        if (userFromDB == null) {
          userFromDB = User(id: id, name: userName, email: email, picture: pic, provider: "facebook");
          await _userController.insert(userFromDB)
          .then((value) {
            print("DEBUG name is : ${userFromDB.name}");
            print("Your account is created successfully!");
            }, onError: (e) {
            print("Sign up with Google failed");
            print("error $e");
            }
          );
        }
        // await setUserId(id);
        // await setUserEmail(email);
        // await setUserName(userName);

        Dataset.currentUser.value = userFromDB;
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);

        // for (var i = 0; i < fdata.length; i++) {
        //   var qq = fdata[i];
        // // var pp = qq['attachments'];
        //   if(qq['attachments']==null){
        //     i++;
        //   }else{
        //     Map <String,dynamic> pp = qq['attachments'];
        //     var nn = pp['data'];
        //     for(var j =0; j< nn.length; j++){
        //       var mm = nn[j];
        //       var jj = mm['media'];
        //       var img = jj['image'];
        //       var src = img['src'];
        //       print(src);
        //       // Util.descriptionList.add(mm['description']);
        //       // Util.mediaList.add(img['src']);
        //     // Util.listItems.add(new ListItem(mm['description'], img['src']));
        //     }
        //   }
        //   // NavigationRouter.switchToHome(context);
        // }

        
        break;
      case FacebookLoginStatus.cancelledByUser:
        // _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        // _showMessage('Something went wrong with the login process.\n'
        //     'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Widget _loginWithGoogleButton() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 3,
      height: 40,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45))),
        // color: Color(0xffd62d20),
        color: Colors.white,
        onPressed: _loginWithGoogle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                "assets/logos/google.svg",
              ),
            ),
            SizedBox(width: 5,),
            Text('GOOGLE', style: TextStyle(color: Color(0xFF7D7D7D), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _loginWithFacebookButton() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 3,
      height: 40,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45))),
        color: Color(0xff3b5998),
        onPressed: _facebookLogin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                "assets/logos/facebook.svg",
              ),
            ),
            Text('FACEBOOK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5,
      child: TextFormField(
        focusNode: emailNode,
        controller: emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        validator: (email) => isEmail(email) ? null : "Invalid",
        autofocus: false,
        onFieldSubmitted: (term) {
          emailNode.unfocus();
          FocusScope.of(context).requestFocus(passwordNode);
        },
        decoration: InputDecoration(
          labelText: "EMAIL",
          labelStyle: TextStyle(fontWeight: FontWeight.bold)
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
        textInputAction: TextInputAction.done,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "PASSWORD",
          labelStyle: TextStyle(fontWeight: FontWeight.bold)
        )),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF82E0FF),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: screen.width * 2 / 3,
                    child: Container(
                      // TODO Put logo in here
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      _buildEmailInput(),
                      _buildPasswordInput(),
                      SizedBox(height: screen.height * 0.05,),
                      _buildLoginButton(),
                      SizedBox(height: screen.height * 0.025,),
                      Container(
                        child: Text("OR CONNECT WITH"),
                      ),
                      SizedBox(height: screen.height * 0.025,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _loginWithFacebookButton(),
                          SizedBox(width: 10,),
                          _loginWithGoogleButton(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("New to Your Occasions? "),
                SizedBox(
                  child: CupertinoButton(
                    padding: EdgeInsets.all(0),
                    pressedOpacity: 0.5,
                    onPressed: () {
                      _formKey.currentState.reset();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpWithEmailScreen()),);
                    },
                    child: Text("SIGN UP", 
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            )
          ]
        ),
      )
    );
  }


}
