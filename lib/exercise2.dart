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

class Exercise2 extends StatefulWidget {
  final String gameMode;
  final String goalText;
  final int timeOrCount;
  final String exercise;
  final bool isRandom;
  final bool isIndication;
  final int numberOfButtons;
  final int buttonSize;
  const Exercise2(
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
  State<Exercise2> createState() => _Exercise2State();
}

class _Exercise2State extends State<Exercise2> {
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
  var timeOrCount = 5;
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
  var hint = 'Drag the button to defeat the target';
  var buttonSize = 70;
  // var numberOfButton = 5;
  // var isRandom = false;
  // var isIndication = true;
  // var gameMode = 'target';
  // var exercise = 'exercise2';
  // var goalText = 'repeat';
  List<int> dragButtonsKey = [1, 2, 3, 1, 3];
  List<int> targetButtonsKey = [1, 2, 3, 1, 3];
  //var timeOrCount = 20;
  var targetButtonSize = 70.0;
  List<String> targetImages = [
    'lib/images/rock_s.png',
    'lib/images/scissors_s.png',
    'lib/images/paper_s.png',
    'lib/images/rock_s.png',
    'lib/images/paper_s.png'
  ];
  List<String> dragImages = [
    'lib/images/paper_s.png',
    'lib/images/rock_s.png',
    'lib/images/scissors_s.png',
    'lib/images/paper_s.png',
    'lib/images/scissors_s.png'
  ];
  List placedButtons = [];
  List<int> clickedlist = [0, 0, 0, 0, 0]; //pressed count
  List<String> pressedButtonList = []; //pressed sequence
  List allPressed = [false, false, false, false, false];

  List bColor = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];

  List tbColor = [
    Colors.cyan,
    Colors.cyan,
    Colors.cyan,
    Colors.cyan,
    Colors.cyan
  ];
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

  List<List<int>> yList = [
    [0, 0],
    [86, 0],
    [176, 0],
    [256, 0],
    [340, 0]
  ];
  //List<int> yList = [0, 100, 200, 300, 200];
  //List<String> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    w = 409 - widget.buttonSize;
    h = 462 - widget.buttonSize * 2;
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
        title: Text('Exercise 2'),
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
              'Drag the button to defeat the target.',
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
                      //createButtons(xList[i], i)
                      createExercise2DraggableButtons(xList[i], i),
                    for (int i = 0; i < widget.numberOfButtons; i++)
                      createExercise2TargetButtons(yList[i], i)
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

  Positioned createExercise2TargetButtons(List<int> l, int index) {
    return Positioned(
        left: l[0].toDouble(),
        top: l[1].toDouble(),
        child: DragTarget<int>(builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return Container(
            height: buttonSize.toDouble(),
            width: buttonSize.toDouble(),
            color: bColor[index],
            child: Image.asset(
              targetImages[index],
              width: targetButtonSize,
            ),
          );
        }, onAccept: (int data) {
          setState(() {
            allPressed[index] = true;
            //tempString += (index + 1).toString();
            targetImages[index] = 'lib/images/no.png';
            //clickedlist[index]++;
            bColor[index] = Colors.grey;
            if (widget.isIndication && index < 4) {
              if (allPressed[index]) {
                bColor[index + 1] = Colors.green;
              }
            }
            if (checkPress()) {
              hasRepeated++;
              rightClick++;
              timeOrCount--;
              if (widget.isRandom) {
                setRandomPosition();
              } else {
                showButtons();
              }
            }

            if (widget.goalText == 'repeat') {
              if (hasRepeated == goal) {
                endGame = true;
                gameOver();
              }
            }
          });
        }, onWillAccept: (data) {
          return data == targetButtonsKey[index];
        }));
  }

  Positioned createExercise2DraggableButtons(List<int> l, int index) {
    return Positioned(
        left: l[0].toDouble(),
        top: l[1].toDouble(),
        child: Draggable<int>(
          data: dragButtonsKey[index],
          child: Container(
            color: bColor[index],
            child: Offstage(
              offstage: allPressed[index],
              child: Image.asset(
                dragImages[index],
                width: widget.buttonSize.toDouble(),
                height: widget.buttonSize.toDouble(),
              ),
            ),
            width: widget.buttonSize.toDouble(),
            height: widget.buttonSize.toDouble(),
            alignment: Alignment.center,
          ),
          feedback: Container(
            child: Offstage(
                offstage: allPressed[index],
                child: Image.asset(
                  dragImages[index],
                  width: targetButtonSize,
                )),
            height: widget.buttonSize.toDouble(),
            width: widget.buttonSize.toDouble(),
          ),
          childWhenDragging: Container(),
          onDragStarted: () =>
              {clickedlist[index]++, tempString += (index + 1).toString()},
        ));
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
      if (widget.isIndication) {
        bColor = [
          Colors.green,
          Colors.grey,
          Colors.grey,
          Colors.grey,
          Colors.grey
        ];
      } else {
        bColor = [
          Colors.grey,
          Colors.grey,
          Colors.grey,
          Colors.grey,
          Colors.grey
        ];
      }
      buttonColor = [
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue
      ];
      targetImages = [
        'lib/images/rock_s.png',
        'lib/images/scissors_s.png',
        'lib/images/paper_s.png',
        'lib/images/rock_s.png',
        'lib/images/paper_s.png'
      ];
      for (var i = 0; i < widget.numberOfButtons; i++) {
        if (i == 0) {
          xList[i][0] = random.nextInt(w);
          xList[i][1] = random.nextInt(h) + buttonSize;

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
            xList[i][1] = random.nextInt(h) + buttonSize;

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
      if (widget.isIndication) {
        bColor = [
          Colors.green,
          Colors.grey,
          Colors.grey,
          Colors.grey,
          Colors.grey
        ];
      } else {
        bColor = [
          Colors.grey,
          Colors.grey,
          Colors.grey,
          Colors.grey,
          Colors.grey
        ];
      }
      buttonColor = [
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue,
        Colors.blue
      ];
      targetImages = [
        'lib/images/rock_s.png',
        'lib/images/scissors_s.png',
        'lib/images/paper_s.png',
        'lib/images/rock_s.png',
        'lib/images/paper_s.png'
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
    if (widget.isIndication) {
      bColor[0] = Colors.green;
    }
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

  bool checkPress() {
    var allPress = true;
    for (int i = 0; i < widget.numberOfButtons; i++) {
      if (!allPressed[i]) {
        allPress = false;
        break;
      }
    }
    return allPress;
  }
}
