import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/utilities/cloudinary.dart';
import 'package:youroccasions/utilities/secret.dart';

class UploadAvatarPage extends StatefulWidget {
  final User user;

  UploadAvatarPage(this.user);

  @override
  UploadAvatarPageState createState() => UploadAvatarPageState();
}


class UploadAvatarPageState extends State<UploadAvatarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  List<PopupMenuItem> _selectImageOptions = 
    [
      PopupMenuItem(
        child: Text("Choose from gallery"),
      ),
      PopupMenuItem(
        child: Text("From camera"),
      ),
    ];
  
  @override
  initState() {
    super.initState();
  }


  void _getImage(ImageSource source) {
    ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  void _saveImage() async {
    String url;
    Cloudinary cl = Cloudinary(CLOUDINARY_API_KEY, API_SECRET);
    UserController uc = UserController();

    url = await cl.upload(
      file: toDataURL(file: _image),
      preset: Presets.profilePicture,
      path: "${Dataset.currentUser.value.id}/cover"
    );
    
    await uc.update(Dataset.currentUser.value.id, picture: url);
    User u = await uc.getUserWithEmail(Dataset.currentUser.value.email);
    
    Dataset.currentUser.value = u;
    
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("New profile picture saved"),
        duration: Duration(seconds: 3),
      )
    );

  }

  Widget _buildImageFrame() {
    var screen = MediaQuery.of(context).size;

    Image image;
    if (_image == null) {
      image = Image.asset("assets/images/no-image-avatar.jpg", fit: BoxFit.cover,);
    }
    else {
      image = Image.file(_image, fit: BoxFit.fitWidth,);
    }
    
    return SizedBox(
      height: screen.height * 0.50,
      width: screen.height * 0.50,
      child: image,
    );
  }

  Widget _buildButtons() {
    var screen = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        SizedBox(
          width: screen.width * 0.5,
          child: RaisedButton(
            onPressed: () {
              _getImage(ImageSource.camera);
            },
            child: Text("Select image from camera"),
          ),
        ),
        SizedBox(
          width: screen.width * 0.5,
          child: RaisedButton(
            onPressed: () {
              _getImage(ImageSource.gallery);
            },
            child: Text("Select image from gallery"),
          ),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("UPLOAD AVATAR",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          SizedBox(
            // width: 30,
            height: 10,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: _saveImage,
              child: Text("SAVE"),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screen.height * 0.05,
              ),
              _buildImageFrame(),
              SizedBox(
                height: screen.height * 0.05,
              ),
              _buildButtons(),
            ]
          ),
        ),
      ),
    );
  }
}



