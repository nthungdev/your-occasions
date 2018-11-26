import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:youroccasions/utilities/secret.dart';

class Presets {
  static String eventCover = "event_header";
  static String profilePicture = "profile_picture";
}

/// Return the url of the image
Future<String> fetch(String path) async {
  try {
    var url = "https://res.cloudinary.com/dm7mijapy/image/upload/$path.jpg";
    var response = await http.get(url);

    if(response.statusCode == 200) {
      print(response.bodyBytes);
      // print(response.body);
      // Map<String, dynamic> image = json.decode(response.body);
      // print(image);
    }
    else {
      print("An error occurs:");
      print(response.statusCode);
      print(response.body);
    }

    // print(response);

  } catch (e) {
    print("An error occurs:");
    print(e);
  }

  return null;

}

String toDataURL({File file}) {
  String prefix = "data:;base64,";
  String encoded = base64Encode(file.readAsBytesSync());
  return prefix + encoded;
}

class Cloudinary {
  final String _apiKey;
  final String _apiSecret;

  Cloudinary(String apiKey, String apiSecret) 
    : this._apiKey = apiKey, 
      this._apiSecret = apiSecret;

  /// path: id/name
  Future<String> upload({@required String path, @required String file, String preset="default"}) async {
    Map<String, String> parameters = {
      "api_key": _apiKey, // Only signed authenticated request requires api_key
      "file": file,
      "upload_preset": preset,
      "public_id": path,
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString().substring(0,10),
    };
    // Only signed authenticated request requires signature
    parameters['signature'] = _generateSignature(parameters);

    try {
      var response = await http.post(UPLOAD_URL, body: parameters);

      if(response.statusCode == 200) {
        Map<String, dynamic> image = json.decode(response.body);
        return(image['secure_url']);
      }
      else {
        print("An error occurs:");
        print(response.statusCode);
        print(response.body);
      }

    } catch (e) {
      print("An error occurs:");
      print(e);
    }
    return null;
  }

  /// Permanantly delete the asset at provided path
  Future<void> destroy(String path) async {
    Map<String, String> parameters = {
      "api_key": _apiKey, // Only signed authenticated request requires api_key
      "public_id": path,
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString().substring(0,10),
    };
    // Only signed authenticated request requires signature
    parameters['signature'] = _generateSignature(parameters);

    try {
      var response = await http.post(DESTROY_URL, body: parameters);

      if(response.statusCode == 200) {
        Map<String, dynamic> image = json.decode(response.body);
        print(image);
      }
      else {
        print("An error occurs:");
        print(response.statusCode);
        print(response.body);
      }

    } catch (e) {
      print("An error occurs:");
      print(e);
    }
  }

  String _generateSignature(Map parameters) {
    List<String> sortedKeys = parameters.keys.where((key) => !["file", "resource_type", "api_key"].contains(key)).toList()
      ..sort();
    String serializedString = "";
    sortedKeys.forEach((item) {
      serializedString += "$item=${parameters[item]}" + (sortedKeys.indexOf(item) != sortedKeys.length - 1 ? "&" : "");
    });
    serializedString += _apiSecret;
    print(serializedString);
    var bytes = utf8.encode(serializedString);
    return sha1.convert(bytes).toString();
  }

  

}

void main() async {
  Cloudinary cl = Cloudinary(CLOUDINARY_API_KEY, API_SECRET);
  File image = File("C:/Users/vuaga/Downloads/42899034_265577847632775_6533329548585467904_n.jpg");

  // cl.destroy("event_header/me2");

  cl.upload(
    file: toDataURL(file: image),
    path: "me3",
    preset: "event_header"
  );

  // fetch("123");


  // test();

}