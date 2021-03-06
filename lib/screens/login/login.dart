import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

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
final FacebookLogin facebookSignIn = new FacebookLogin();

const double _bigFont = 18;
const double _smallFont = 14;

class LoginWithEmailScreen extends StatefulWidget {
  @override
  _LoginWithEmailScreen createState() => _LoginWithEmailScreen();
}


class _LoginWithEmailScreen extends State<LoginWithEmailScreen> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
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
      
      Dataset.firebaseUser.value = userFirebase;
      await setUserId(userFirebase.uid);
      await setIsLogin(true);
      await setUserEmail(userFirebase.email);
      await setUserName(userFirebase.displayName);
      await setUserPassword(passwordController.text);
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
      User userFromDB = await _userController.getUserWithEmail(googleUser.email);
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
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        elevation: 3,
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45))),
          color: Colors.deepPurpleAccent,
          onPressed: _loginWithEmail,
          // color: Colors.lightBlueAccent,
          child: Text('LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();
    HttpServer server =
        await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.HTML.mimeType)
        ..write("<html><h1>You can now close this window</h1></html>");
      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });
    return onCode.stream;
  }

  void _facebookLogin() async {

    // Stream<String> onCode = await _server();
    // String url =
    //     "https://www.facebook.com/dialog/oauth?client_id=$appId&redirect_uri=http://localhost:8080/&scope=public_profile";
    // await launch(url);
    // final String code = await onCode.first;
    // final http.Response response = await http.get(
    //     "https://graph.facebook.com/v2.2/oauth/access_token?client_id=$appId&redirect_uri=http://localhost:8080/&client_secret=$appSecret&code=$code");
    // Map<String,dynamic> user = json.decode(response.body);
    // print(user);


    var userName, email, pic, id;
    FacebookLoginResult result = await facebookSignIn.logInWithReadPermissions(['email','public_profile']);
    // print(result.accessToken);
    //,publish_actions,manage_pages,publish_pages,user_status,user_videos,user_work_history

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var accessToken = result.accessToken;
        print(
          '''LoggedIn
          Token: ${accessToken.token}
          User id: ${accessToken.userId}
          '''
        );
        
        // accessToken.permissions;

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

        User userFromDB = await _userController.getUserWithEmail(email);

        if (userFromDB != null && userFromDB.provider != "facebook") { 
          showSnackbar("Email is used");
          print("Email is used");
          print(email);
          return;
        }

        if (userFromDB == null) {
          userFromDB = User(id: id, name: userName, email: email, picture: pic, provider: "facebook");
          await _userController.insert(userFromDB)
          .then((value) {
            print("DEBUG name is : ${userFromDB.name}");
            print("Your account is created successfully!");
            }, onError: (e) {
            print("Sign up with Facebook failed");
            print("error $e");
            }
          );
        }
        // await setUserId(id);
        // await setUserEmail(email);
        // await setUserName(userName);

        Dataset.currentUser.value = userFromDB;
        await setUserId(id);
        await setUserEmail(email);
        await setUserName(userName);
        // print(1);
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
        print(2);
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
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        elevation: 3,
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45))),
          color: Colors.white54,
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
              Text('GOOGLE', 
                style: TextStyle(
                  color: Colors.black54, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 12,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginWithFacebookButton() {
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 3,
      height: 40,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
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
              Text('FACEBOOK', 
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ), 
                overflow: TextOverflow.clip,
              ),
            ],
          ),
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
        style: TextStyle(
          color: Colors.white
        ),
        decoration: InputDecoration(
          labelText: "EMAIL",
          labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white
            )
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white
            )
          ),
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
        style: TextStyle(
          color: Colors.white
        ),
        decoration: InputDecoration(
          labelText: "PASSWORD",
          labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white
            )
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white
            )
          ),
        )),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    var linearGradient = BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: <Color>[
          // Colors.blue[200],
          // Colors.white,
          // Colors.blue,
          Colors.white,
          // Colors.indigoAccent,
          Colors.deepPurpleAccent,
          Colors.black87,
          Colors.black,
          // Colors.black
        ],
      ),
    );

    return new Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.black,
      body: Container(
        decoration: linearGradient,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: screen.height * 0.4,
                      width: screen.width * 2 / 3,
                      child: Center(
                        child: SizedBox(
                          height: screen.width * 0.5,
                          width: screen.width * 0.5,
                          child: Image.asset("assets/logos/logo-no-background.png"),
                        ),
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
                          child: Text("OR CONNECT WITH", 
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                        ),),
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
                  Text("New to Your Occasions? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
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
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]
          ),
        ),
      )
    );
  }


}
