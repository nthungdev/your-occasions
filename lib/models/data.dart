import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/models/user_attended_event.dart';
import 'package:youroccasions/models/user_interested_event.dart';
import 'package:youroccasions/models/user_shared_event.dart';
import 'package:youroccasions/models/event_category.dart';
import 'package:youroccasions/models/event_review.dart';
import 'package:youroccasions/models/user_shared_event.dart';

import 'package:youroccasions/controllers/event_category_controller.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/controllers/user_shared_event_controller.dart';

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
  static Data allEventCategories = Data();
  static Data<List<User>> allUsers = Data<List<User>>();
  static Data allUserInterestedEvents = Data();
  
  static Data trendingEvents = Data();
  static Data allEvents = Data();
  static Data userId = Data();
}

// void main() async {
//   print(Dataset._allEvents);
//   EventController ec = EventController();
//   Dataset.allEvents = await ec.getEvent();
//   print(Dataset.allEvents);
//   Dataset.allEvents = null;
//   print(Dataset.allEvents);
// }

class LeaderboardDataset {
  // values of topHost is a List of 5 hosts with highest total views from their events
  static Data<List<User>> topHost = Data<List<User>>();
  /// Pair of id,views
  static Data<Map<int,int>> topHostTotalEventViews = Data<Map<int,int>>();
  
  // values of topHost is a List of 5 hosts with highest total followers
  static Data<List<User>> mostFollowedUsers = Data<List<User>>();
  /// Pair of id,followers
  static Data<Map<int,int>> mostFollowedUsersMap = Data<Map<int,int>>();
}

void main() {
  // Dataset.
}

