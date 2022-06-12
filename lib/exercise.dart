import 'dart:math';
import 'package:assignment4/main.dart';
import 'package:flutter/material.dart';
import 'exercise1.dart';
import 'exercise2.dart';

class Exercise extends StatefulWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  var gameMode = 'free';
  var goal = 'time';
  var exercise = 'exercise1';
  var isRandom = false;
  var isIndication = false;
  var numberOfButton = 3;
  //var buttonSize = 'small';
  var groupValue = 1;
  var goalNumber = 20;
  var buttonSize = 50;
  var unit = 'S';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
        title: Text('Exercise Mode'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Choose your exercise mode',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Container(
              color: Colors.grey,
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'free',
                    groupValue: gameMode,
                    onChanged: (value) {
                      setState(() {
                        gameMode = value.toString();
                        print(gameMode);
                      });
                    },
                  ),
                  const Text(
                    'Free',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Radio(
                    value: 'target',
                    groupValue: gameMode,
                    onChanged: (value) {
                      setState(() {
                        gameMode = value.toString();
                        print(gameMode);
                      });
                    },
                  ),
                  const Text(
                    'Target',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            (gameMode.contains('free'))
                ? Container()
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Set goal',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          color: Colors.grey,
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 'time',
                                groupValue: goal,
                                onChanged: (value) {
                                  setState(() {
                                    goal = value.toString();
                                    unit = 'S';
                                    print(goal);
                                  });
                                },
                              ),
                              const Text(
                                'Time',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Radio(
                                value: 'repeat',
                                groupValue: goal,
                                onChanged: (value) {
                                  setState(() {
                                    goal = value.toString();
                                    unit = 'T';
                                    print(goal);
                                  });
                                },
                              ),
                              const Text(
                                'Repeat',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                width: 260,
                                child: Slider(
                                    min: 20,
                                    max: 300,
                                    value: goalNumber.toDouble(),
                                    onChanged: (value) => setState(() {
                                          goalNumber = value.toInt();
                                        })),
                              ),
                              const Text(
                                'Play',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                goalNumber.toString(),
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                              Text(
                                unit,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (goalNumber < 300) {
                                          goalNumber += 10;
                                          if (goalNumber > 300) {
                                            goalNumber = 300;
                                          }
                                        }
                                        print(goalNumber);
                                      });
                                    },
                                    child: Text('+ 10$unit')),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (goalNumber < 300) {
                                          goalNumber += 30;
                                          if (goalNumber > 300) {
                                            goalNumber = 300;
                                          }
                                        }
                                        print(goalNumber);
                                      });
                                    },
                                    child: Text('+ 30$unit')),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (goalNumber < 300) {
                                          goalNumber += 60;
                                          if (goalNumber > 300) {
                                            goalNumber = 300;
                                          }
                                        }
                                        print(goalNumber);
                                      });
                                    },
                                    child: Text('+ 60$unit')),
                              ]),
                        ),
                      ],
                    ),
                  ),
            const Text(
              'Choose your exercise',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Container(
              color: Colors.grey,
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'exercise1',
                    groupValue: exercise,
                    onChanged: (value) {
                      setState(() {
                        exercise = value.toString();
                        print(exercise);
                      });
                    },
                  ),
                  Text(
                    'Exercise 1',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Radio(
                    value: 'exercise2',
                    groupValue: exercise,
                    onChanged: (value) {
                      setState(() {
                        exercise = value.toString();
                        print(exercise);
                      });
                    },
                  ),
                  Text(
                    'Exercise2',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const Text(
              'Customization',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Container(
              color: Colors.grey,
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: isRandom,
                      onChanged: (value) {
                        setState(() {
                          isRandom = value!;
                          print(isRandom);
                        });
                      }),
                  const Text(
                    'Random order',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Checkbox(
                      value: isIndication,
                      onChanged: (value) {
                        setState(() {
                          isIndication = value!;
                          print(isIndication);
                        });
                      }),
                  const Text(
                    'Indication',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Text('Set ', style: TextStyle(fontSize: 20)),
                  Text(
                    numberOfButton.toString(),
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  Text(' Buttons', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (numberOfButton > 3) {
                              numberOfButton--;
                            }
                          });
                        },
                        child: Icon(Icons.minimize)),
                    const SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      width: 260,
                      child: Slider(
                          min: 3,
                          max: 5,
                          value: numberOfButton.toDouble(),
                          onChanged: (value) => setState(() {
                                numberOfButton = value.toInt();
                              })),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (numberOfButton < 5) {
                              numberOfButton++;
                            }
                          });
                        },
                        child: Icon(Icons.add)),
                  ],
                ),
              ),
            ),
            const Text(
              'Button size',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        buttonSize = 50;
                        print(buttonSize);
                      },
                      child: const Text(
                        'S',
                        style: TextStyle(fontSize: 30),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 50)),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonSize = 60;
                          print(buttonSize);
                        });
                      },
                      child: const Text(
                        'M',
                        style: TextStyle(fontSize: 30),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 60)),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonSize = 70;
                          print(buttonSize);
                        });
                      },
                      child: const Text(
                        'L',
                        style: TextStyle(fontSize: 30),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(70, 70)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2, //90
            ),
            ElevatedButton(
              onPressed: () => {
                if (exercise == 'exercise1')
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Exercise1(
                                gameMode: gameMode,
                                goalText: goal,
                                timeOrCount: goalNumber.toInt(),
                                exercise: exercise,
                                isRandom: isRandom,
                                isIndication: isIndication,
                                numberOfButtons: numberOfButton,
                                buttonSize: buttonSize)))
                  }
                else if (exercise == 'exercise2')
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Exercise2(
                                gameMode: gameMode,
                                goalText: goal,
                                timeOrCount: goalNumber.toInt(),
                                exercise: exercise,
                                isRandom: isRandom,
                                isIndication: isIndication,
                                numberOfButtons: numberOfButton,
                                buttonSize: buttonSize)))
                  }
              },
              child: const Text(
                'START',
                style: TextStyle(fontSize: 30),
              ),
              style: ElevatedButton.styleFrom(minimumSize: const Size(390, 60)),
            )
          ],
        ),
      ),
    );
  }
}
