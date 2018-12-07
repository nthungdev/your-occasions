import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Data<T> {
  T _value;
  DateTime _lastModified;

  T get value => _value;
  DateTime get lastModified => _lastModified;

  set value(T value) {
    _value = value;
    _lastModified = DateTime.now();
  }

}

class Dataset {
  // static List<Event> _allEvents;
  static Data<User> currentUser = Data();
  static Data<FirebaseUser> firebaseUser = Data();
  static Data allEventCategories = Data();
  static Data<List<User>> allUsers = Data<List<User>>();
  static Data allUserInterestedEvents = Data();
  
  static Data trendingEvents = Data();
  static Data allEvents = Data();
  static Data userId = Data();
}

class FeedDataset {
  static Data<List<Event>> pastEvents = Data();
  static Data<List<Event>> trendingEvents = Data();
  static Data<List<Event>> upcomingEvents = Data();

  static void clearData() {
    pastEvents = Data();
    trendingEvents = Data();
    upcomingEvents = Data();
  }
}

class FollowDataset {

  static Data<List<User>> following = Data();
  
}

class LeaderboardDataset {
  // values of topHost is a List of 5 hosts with highest total views from their events
  static Data<List<User>> topHost = Data<List<User>>();
  /// Pair of id,views
  static Data<Map<String,int>> topHostTotalEventViews = Data();
  // values of topHost is a List of 5 hosts with highest total followers
  static Data<List<User>> mostFollowedUsers = Data<List<User>>();
  /// Pair of id,followers
  static Data<Map<String,int>> mostFollowedUsersMap = Data();
}

void main() {
  // Dataset.
  // Dataset.allUsers.value = [User()];
  // List<User> id = Dataset.allUsers.value;
  // id.clear();
  // print(Dataset.allUsers.value);
  // print(id);

}

