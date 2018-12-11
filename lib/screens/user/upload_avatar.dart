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
  List<PopupMenuItem<ImageSource>> _selectImageOptions;
  
  @override
  initState() {
    super.initState();
    _imageURL = Dataset.currentUser.value.picture;

    
    if (_imageURL != null) {
      _image = Image.network(_imageURL, fit: BoxFit.cover);
    }

    _selectImageOptions = [
      PopupMenuItem<ImageSource>(
        value: ImageSource.gallery,
        child: Text("Choose image from gallery"),
      ),
      PopupMenuItem<ImageSource>(
        value: ImageSource.camera,
        child: Text("Take photo from camera"),
      ),
    ];
  }


  void _getImage(ImageSource source) {
    ImagePicker.pickImage(source: source).then((image) {
      if (image != null) {
        setState(() {
          _image = Image.file(image, fit: BoxFit.cover);
          _imageFile = image;
        });
      }
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
              child: Text("SAVE", style: TextStyle(fontSize: 18, color: Colors.blue),),
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
              // Expanded(
              //   child: SizedBox(),
              // ),
              Expanded(
                flex: 3,
                child: _buildImageFrame(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      color: Colors.blue,
                      onPressed: () {},
                      child: PopupMenuButton<ImageSource>(
                        onSelected: (item) {
                          _getImage(item);
                        },
                        child: Text("EDIT", style: TextStyle(color: Colors.white,)),
                        itemBuilder: (context) => _selectImageOptions,
                      ),
                    ),
                  ],
                )
              ),
            ]
          ),
        ),
      ),
    );
  }
}



