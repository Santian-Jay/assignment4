import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String id = '';
  String startTime = '';
  String endTime = '';
  String gameMode = '';
  int duration = 0;
  String exercise = '';
  int repeat = 0;
  List<int> clickCountList = [];
  List<String> clickedButtons = [];
  bool completed = false;
  int rightCklick = 0;
  History();

  History.fromJson(Map<String, dynamic> json, String _id)
      : id = _id,
        startTime = json['startTime'],
        endTime = json['endTime'],
        gameMode = json['gameMode'],
        duration = json['duration'],
        exercise = json['exercise'],
        repeat = json['repeat'],
        completed = json['completed'],
        rightCklick = json['rightClick'] {
    clickCountList = [];
    (json['clickCountList']).forEach((element) {
      clickCountList.add(element);
    });

    clickedButtons = [];
    (json['clickedButtons']).forEach((element) {
      clickedButtons.add(element);
    });
  }
  // clickCountList = json['clickCountList'],
  //clickedButtons = json['clickedButtons'];

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
        'gameMode': gameMode,
        'duration': duration,
        'exercise': exercise,
        'repeat': repeat,
        'completed': completed,
        'rightClick': rightCklick,
        'clickCountList': clickCountList,
        'clickedButtons': clickedButtons
      };

  String ShareRecord(History history) {
    var str = '';
    str = 'Start at ${history.startTime}' +
        ' lasted ${history.duration}' +
        'seconds, game is ${history.gameMode}' +
        ', ${history.repeat} rounds completed ' +
        ', finally ${history.completed ? 'finished' : 'not finished'}' +
        ' exercise';

    return str;
  }
}

class HistoryModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<History> histories = [];
  final List<History> fHistories = [];
  final List<History> unFHistories = [];

  int totalGameCount = 0;
  int totalGameTime = 0;
  int totalFinished = 0;
  int totalUnfinished = 0;
  int totalRepeated = 0;
  int totalRightClicked = 0;
  //added this
  CollectionReference historyCollection =
      FirebaseFirestore.instance.collection('histories');

  //added this
  bool loading = false;

  //replaced this
  HistoryModel() {
    fetch();
  }

  Future fetch() async {
    print('1');
    //clear any existing data we have gotten previously, to avoid duplicate data
    histories.clear();

    //indicate that we are loading
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on
    print('2');
    //get all movies
    //var querySnapshot = await historyCollection.orderBy("startTime").get();
    var querySnapshot = await historyCollection.get();
    print('3');
    //iterate over the movies and add them to the list
    querySnapshot.docs.forEach((doc) {
      print('12');
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var history =
          History.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      if (history.completed) {
        totalFinished++;
      } else {
        totalUnfinished++;
      }
      totalGameCount++;
      totalGameTime += history.duration;
      totalRightClicked += history.rightCklick;
      totalRepeated += history.repeat;
      histories.add(history);
    });
    print('4');

    //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    //comment this out when the delay becomes annoying
    await Future.delayed(Duration(seconds: 1));
    print('5');
    //we're done, no longer loading
    loading = false;
    update();
  }

  //finished history
  Future fetchFinished() async {
    histories.clear();
    loading = true;

    notifyListeners();

    var querySnapshot = await historyCollection.get();

    querySnapshot.docs.forEach((doc) {
      var history =
          History.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      if (history.completed) {
        histories.add(history);
      }
    });

    await Future.delayed(Duration(seconds: 1));

    loading = false;
    update();
  }

  //Unfinished history
  Future fetchUnFinished() async {
    histories.clear();
    loading = true;

    notifyListeners();

    var querySnapshot = await historyCollection.get();

    querySnapshot.docs.forEach((doc) {
      var history =
          History.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      if (history.completed == false) {
        histories.add(history);
      }
    });

    await Future.delayed(Duration(seconds: 1));

    loading = false;
    update();
  }

  Future add(History item) async {
    print('6');
    loading = true;
    update();

    await historyCollection.add(item.toJson());
    print('7');
    //refresh the db
    await fetch();
  }

  Future updateItem(String id, History item) async {
    print('8');
    loading = true;
    update();

    await historyCollection.doc(id).set(item.toJson());

    //refresh the db
    await fetch();
  }

  Future delete(String id) async {
    print('9');
    loading = true;
    update();

    await historyCollection.doc(id).delete();

    //refresh the db
    await fetch();
  }

  // This call tells the widgets that are listening to this model to rebuild.
  void update() {
    print('10');
    notifyListeners();
  }

  History? get(String? id) {
    print('11');
    if (id == null) return null;
    return histories.firstWhere((history) => history.id == id);
  }
}
