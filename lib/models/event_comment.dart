

import 'package:cloud_firestore/cloud_firestore.dart';
/// Firebase Database Object

class EventComment {
  int eventId;
  String authorId;
  String message;
  DateTime date;
  List<EventComment> replies;
  
  // CONSTRUCTORS //
  EventComment.create();
  EventComment({this.eventId, this.authorId, this.message, this.date});
  EventComment.fromMap(Map<dynamic, dynamic> map){
    this.eventId = map['eventId'];
    this.authorId = map['authorId'];
    this.message = map['message'];
    this.date = map['date'];
    this.replies = _serializeReplies(map['replies']);
  }
  EventComment.fromSnapshot(DocumentSnapshot snapshot) {
    this.eventId = snapshot?.data['eventId'];
    this.authorId = snapshot?.data['authorId'];
    this.message = snapshot?.data['message'];
    this.date = snapshot?.data['date'];
    this.replies = _serializeReplies(snapshot?.data['replies']);
  }


  // METHODS //
  toJson() {
    return {
      "eventId": eventId,
      "authorId": authorId,
      "message": message,
      "date": date,
      "replies": replies,
    };
  }

  List<EventComment> _serializeReplies(List<dynamic> replies) {
    if (replies != null && replies.length != 0) {
      List<EventComment> result = List<EventComment>();
      replies.forEach((item) {
        result.add(EventComment.fromMap(item));
      });
      return result;
    }
    else {
      return List<EventComment>();
    }
  }

}