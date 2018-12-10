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
  File _imageFile;
  Image _image;
  String _imageURL;
  
  @override
  initState() {
    super.initState();
    _imageURL = Dataset.currentUser.value.picture;

    
    if (_imageURL != null) {
      _image = Image.network(_imageURL, fit: BoxFit.cover);
    }
  }


  void _getImage(ImageSource source) {
    ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        // _imageFile = image;
        _image = Image.file(image, fit: BoxFit.cover);
      });
    });
  }

  void _saveImage() async {
    String url;
    Cloudinary cl = Cloudinary(CLOUDINARY_API_KEY, API_SECRET);
    UserController uc = UserController();

    url = await cl.upload(
      file: toDataURL(file: _imageFile),
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

    if (_imageURL == null) {
      if (_imageFile == null) {
        _image = Image.asset("assets/images/no-image-avatar.jpg", fit: BoxFit.cover,);
      }
      else {
        _image = Image.file(_imageFile, fit: BoxFit.cover);
      }
    }
    
    return SizedBox(
      width: screen.width,
      height: screen.width,
      // child: Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover,),
      child: _image,
    );

  }

  Widget _buildButtons() {
    var screen = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: screen.width,
          child: Material(
            color: Colors.redAccent,
            child: InkWell(
              onTap: () {
                _getImage(ImageSource.camera);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Center(child: Text("Capture image from camera")),
              ),
            ),
          ),
        ),
        SizedBox(
          width: screen.width,
          child: Material(
            color: Colors.blueAccent,
            child: InkWell(
              onTap: () {
                _getImage(ImageSource.gallery);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Center(child: Text("Select image from gallery")),
              ),
            ),
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
              Expanded(
                child: SizedBox(),
              ),
              _buildButtons(),
            ]
          ),
        ),
      ),
    );
  }
}



