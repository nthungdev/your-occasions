import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:youroccasions/utilities/secret.dart';

class PlaceSearch {
  static final PlaceSearch instance = PlaceSearch._();

  PlaceSearch._();

  Future<PlaceData> search(String address) async {
    String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$address&inputtype=textquery&fields=photos,formatted_address,name,geometry,place_id&key=$GOOGLE_MAP_PLACE_API_KEY";

    try {
      var response = await http.get(url);

      if(response.statusCode == 200) {
        var resJson = json.decode(response.body);
        List<dynamic> _candidate = resJson["candidates"];
        if (_candidate.isEmpty) {
          print("not found");
          return null;
        }
        else {
          print(json.decode(response.body)["candidates"][0]["place_id"]);
          return PlaceData.fromJson(json.decode(response.body));
        }
        
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

}

main() {
  PlaceSearch ps = PlaceSearch.instance;
  // ps.search("Kent Hall, Plattsburgh");
  ps.search("fdsfsdfsdf");




}


class PlaceData {
  String placeId;
  
  PlaceData.fromJson(Map json) {
    placeId = json["candidates"][0]["place_id"];
  }
}