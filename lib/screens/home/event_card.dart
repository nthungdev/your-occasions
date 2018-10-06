import 'package:flutter/material.dart';




class SmallEventCard extends StatefulWidget {
  @override
  _SmallEventCardState createState() => _SmallEventCardState();
}

class _SmallEventCardState extends State<SmallEventCard> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: ListTile(
          leading: Container(
            height: 60.0,
            child: Image.network("https://img.cutenesscdn.com/640/cme/cuteness_data/s3fs-public/diy_blog/Information-on-the-Corgi-Dog-Breed.jpg",
              fit: BoxFit.fill,
              alignment: Alignment.centerLeft,
            ),
          ),
          title: Text("Corgi dog event"),
          subtitle: Text("It would be fun"),
        ),
      ),
    );
  }




}
