import 'dart:ffi';
import 'dart:math';
import 'dart:async';
import 'package:assignment4/main.dart';

import 'exercise.dart';
import 'package:assignment4/exercise.dart';
import 'package:assignment4/gameover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise1 extends StatefulWidget {
  final String gameMode;
  final String goalText;
  final int timeOrCount;
  final String exercise;
  final bool isRandom;
  final bool isIndication;
  final int numberOfButtons;
  final int buttonSize;
  const Exercise1(
      {Key? key,
      required this.gameMode,
      required this.goalText,
      required this.timeOrCount,
      required this.exercise,
      required this.isRandom,
      required this.isIndication,
      required this.numberOfButtons,
      required this.buttonSize})
      : super(key: key);

  @override
  State<Exercise1> createState() => _Exercise1State();
}

class _Exercise1State extends State<Exercise1> {
  CollectionReference db = FirebaseFirestore.instance.collection('histories');
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  final GlobalKey palyArea = GlobalKey();
  final random = Random();
  var w = 409;
  var h = 462;
  var startTime = '';
  var endTime = '';
  var playDuration = 0;
  var hasRepeated = 0;
  var timeOrCount = 20;
  var offSet = 50;
  var rightClick = 0;
  late Timer countDownTimer;
  var recordID = '';
  var endGame = false;
  var timeLeft = 0;
  var unit = 'S';
  var hidenProgressBar = false;
  var completed = false;
  var tempString = '';
  double progressBarValue = 1.0;
  var goal = 0;
  List placedButtons = [];
  List<int> clickedlist = [0, 0, 0, 0, 0]; //pressed count
  List<String> pressedButtonList = []; //pressed sequence
  List allPressed = [false, false, false, false, false];
  List buttonColor = [
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue
  ];
  List<int> butTag = [1, 2, 3, 4, 5];
  List<List<int>> xList = [
    [0, 0],
    [100, 100],
    [200, 200],
    [300, 300],
    [300, 200]
  ];
  //List<int> yList = [0, 100, 200, 300, 200];
  List<String> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    w = 409 - widget.buttonSize;
    h = 462 - widget.buttonSize;
    offSet = widget.buttonSize;
    goal = widget.timeOrCount;
    prepareGame();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    countDownTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            stopTimer();
            showAlert();
            //Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                stopTimer();
                showPauseAlert();
              },
              icon: Icon(Icons.pause))
        ],
        title: Text('Exercise 1'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 1.0, right: 1.0, bottom: 1.0),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  const Text(
                    'Start Time: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    startTime,
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  const Text(
                    'Duration: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    playDuration.toString(),
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  const Text(
                    'Repeated Count: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    hasRepeated.toString(),
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const Text(
              'Click the buttons in order.',
              style: TextStyle(fontSize: 24),
            ),
            Container(
              child: Offstage(
                offstage: hidenProgressBar,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: timeLeft / goal,
                        valueColor: AlwaysStoppedAnimation(Colors.yellow),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      timeOrCount.toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              key: palyArea,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey,
                child: Stack(
                  children: [
                    for (int i = 0; i < widget.numberOfButtons; i++)
                      createButtons(xList[i], i)
                    //children: butTag.map((e) => _chip(e, context)).toList(),
                  ],
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Positioned createButtons(List<int> l, int index) {
    return Positioned(
      left: l[0].toDouble(),
      top: l[1].toDouble(),
      child: Offstage(
        offstage: allPressed[index],
        child: ElevatedButton(
          key: Key((index + 1).toString()),
          child: Text(
            (index + 1).toString(),
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            setState(() {
              if (index == 0) {
                allPressed[index] = !allPressed[index];
                rightClick++;
                tempString += (index + 1).toString();
                clickedlist[index] += 1;
                if (widget.isIndication) {
                  buttonColor[index + 1] = Colors.green;
                }
              } else if (index == widget.numberOfButtons - 1) {
                tempString += (index + 1).toString();
                clickedlist[index] += 1;
                if (!endGame && allPressed[widget.numberOfButtons - 2]) {
                  allPressed[index] = !allPressed[index];
                  hasRepeated++;
                  rightClick++;
                  if (widget.gameMode != 'free') {
                    if (widget.goalText == 'repeat') {
                      timeOrCount--;
                      timeLeft--;
                      if (hasRepeated == widget.timeOrCount) {
                        endGame = true;
                        completed = true;
                        countDownTimer.cancel;
                        gameOver();
                      }
                    }
                  }
                  if (widget.isRandom) {
                    setRandomPosition();
                  } else {
                    showButtons();
                  }
                }
              } else {
                tempString += (index + 1).toString();
                clickedlist[index] += 1;
                if (allPressed[index - 1]) {
                  allPressed[index] = !allPressed[index];
                  rightClick++;
                  if (widget.isIndication) {
                    buttonColor[index + 1] = Colors.green;
                  }
                }
              }
            });
          },
          style: ElevatedButton.styleFrom(
            //primary: isIndication ? Colors.green : Colors.blue,
            primary: widget.isIndication && index == 0
                ? Colors.green
                : buttonColor[index],
            minimumSize: Size(
                widget.buttonSize.toDouble(), widget.buttonSize.toDouble()),
          ),
        ),
      ),
    );
  }

  void setRandomPosition() {
    List<List<int>> currentList = [];
    var newString = tempString;
    if (tempString != '') {
      pressedButtonList.add(newString);
    }
    tempString = '';
    print(pressedButtonList);
    print(clickedlist);
    print(rightClick);
    setState(() {
      buttonColor = [
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue
      ];
      for (var i = 0; i < widget.numberOfButtons; i++) {
        if (i == 0) {
          xList[i][0] = random.nextInt(w);
          xList[i][1] = random.nextInt(h);

          allPressed[i] = false;
          currentList.add([xList[i][0], xList[i][1]]);
          if (widget.isIndication) {
            buttonColor[i] = Colors.green;
          } else {
            buttonColor[i] = Colors.blue;
          }
        } else {
          allPressed[i] = false;
          var overlaping = false;
          do {
            xList[i][0] = random.nextInt(w);
            xList[i][1] = random.nextInt(h);

            for (var data in currentList) {
              overlaping = isOverlaping(data, [xList[i][0], xList[i][1]]);
              if (overlaping) {
                break;
              }
            }
          } while (overlaping);
          currentList.add([xList[i][0], xList[i][1]]);
        }
      }
    });
  }

  bool isOverlaping(List<int> l1, List<int> l2) {
    var isoverlap = false;
    var isOverlap1 = l1[0] + offSet >= l2[0] &&
        l1[0] <= l2[0] + offSet &&
        l1[1] + offSet >= l2[1] &&
        l1[1] <= l2[1] + offSet;
    var isOverlap2 = l2[0] + offSet >= l1[0] &&
        l2[0] <= l1[0] + offSet &&
        l2[1] + offSet >= l1[1] &&
        l2[1] <= l1[1] + offSet;
    if (isOverlap1 && isOverlap2) {
      isoverlap = true;
    }
    return isoverlap;
  }

  void showButtons() {
    var newString = tempString;
    if (tempString != '') {
      pressedButtonList.add(newString);
    }
    tempString = '';
    print(pressedButtonList);
    print(clickedlist);
    print(rightClick);
    setState(() {
      buttonColor = [
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue
      ];
      for (var i = 0; i < widget.numberOfButtons; i++) {
        allPressed[i] = false;
      }
    });
  }

  void prepareGame() {
    //dateFormat = DateTime.now() as DateFormat;
    recordID = dateFormat.format(DateTime.now());
    startTime = recordID;
    timeLeft = widget.timeOrCount;
    timeOrCount = widget.timeOrCount;
    createHistoryRecord();
    if (widget.gameMode != 'free') {
      switch (widget.goalText) {
        case 'time':
          unit = ' S left';
          break;
        default:
          unit = ' T left';
        //timeLeft = 24 * 60 * 60 * 1000;
      }
    } else {
      hidenProgressBar = true;
      timeLeft = 24 * 60 * 60 * 1000;
    }
    startTimer();
    print(recordID);
    setRandomPosition();
  }

  void createHistoryRecord() {
    db
        .doc(recordID)
        .set({
          'startTime': startTime,
          'endTime': endTime,
          'duration': playDuration,
          'gameMode': widget.gameMode,
          'exercise': widget.exercise,
          'repeat': hasRepeated,
          'completed': completed,
          'rightClick': rightClick,
          'clickedButtons': pressedButtonList,
          'clickCountList': clickedlist
        })
        .then((value) => print('Creating record successfully!'))
        .catchError((onError) => print('Creating record error $onError!'));
  }

  void startTimer() {
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.exercise != 'free') {
          if (timeLeft > 0) {
            if (widget.goalText == 'time') {
              timeLeft--;
              timeOrCount--;
            }
            endGame = false;
            playDuration++;
          } else {
            countDownTimer.cancel();
            endGame = true;
            completed = true;
            gameOver();
          }
        } else {
          playDuration++;
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      countDownTimer.cancel();
    });
  }

  void gameOver() {
    endTime = dateFormat.format(DateTime.now());
    db
        .doc(recordID)
        .update({
          'endTime': endTime,
          'duration': playDuration,
          'repeat': hasRepeated,
          'completed': completed,
          'rightClick': rightClick,
          'clickedButtons': pressedButtonList,
          'clickCountList': clickedlist
        })
        .then((value) => print('Update record successfully!'))
        .catchError((onError) => print('Update record error $onError!'));
    print("game over");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Gameover(
                  gameMode: widget.gameMode,
                  goalText: widget.goalText,
                  duration: playDuration,
                  exercise: widget.exercise,
                  clickedlist: clickedlist,
                  completed: completed,
                  pressedButtonList: pressedButtonList,
                  rightCklickd: rightClick,
                  endTime: endTime,
                  startTime: recordID,
                  repeated: hasRepeated,
                )));
  }

  void showAlert() async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Hi Dear'),
            content: Text('Do you want to exit?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    startTimer();
                  },
                  child: Text('No')),
              FlatButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Exercise())),
                      },
                  child: Text('Yes')),
            ],
          );
        });
    print(result);
  }

  void showPauseAlert() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Hi Dear'),
            content: Text('Do you want to continue?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    gameOver();
                  },
                  child: Text('No')),
              FlatButton(
                  onPressed: () => {Navigator.of(context).pop(), startTimer()},
                  child: Text('Yes')),
            ],
          );
        });
  }
}
