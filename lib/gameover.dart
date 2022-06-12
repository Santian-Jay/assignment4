import 'package:assignment4/history.dart';
import 'package:assignment4/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'exercise.dart';

class Gameover extends StatefulWidget {
  final String gameMode;
  final String goalText;
  final int duration;
  final String exercise;
  final List<int> clickedlist;
  final List<String> pressedButtonList;
  final int rightCklickd;
  final bool completed;
  final String endTime;
  final String startTime;
  final int repeated;

  const Gameover(
      {Key? key,
      required this.gameMode,
      required this.goalText,
      required this.duration,
      required this.exercise,
      required this.clickedlist,
      required this.completed,
      required this.pressedButtonList,
      required this.rightCklickd,
      required this.endTime,
      required this.startTime,
      required this.repeated})
      : super(key: key);

  @override
  State<Gameover> createState() => _GameoverState();
}

class _GameoverState extends State<Gameover> {
  late String imagePath = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Game Over'),
        centerTitle: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                      'Start Time: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.startTime,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'End Time: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.endTime,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'Duration: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.duration.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'Repeated: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.repeated.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    const Text(
                      'Completed: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.completed.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    const Text(
                      'Exercise Mode: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.gameMode,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    const Text(
                      'Exercise Choose: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.exercise,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    const Text(
                      'Right Clicked: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.rightCklickd.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Text('Button clicked count',
                  style: TextStyle(fontSize: 20, color: Colors.grey)),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      '1: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.clickedlist[0].toString(),
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    const Text(
                      '2: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.clickedlist[1].toString(),
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    const Text(
                      '3: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.clickedlist[2].toString(),
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    const Text(
                      '4: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.clickedlist[3].toString(),
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    const Text(
                      '5: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.clickedlist[4].toString(),
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const Text('Button clicked sequence',
                  style: TextStyle(fontSize: 20, color: Colors.grey)),
              Container(
                //color: Colors.red,
                width: 500,
                height: 60,
                child: Text(
                  widget.pressedButtonList.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 130,
                //color: Colors.yellow,
                child:
                    imagePath == '' ? Container() : Image.file(File(imagePath)),
              ),
              Container(
                //color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          takePicture(context);
                        },
                        child: const Text('Take a photo')),
                    ElevatedButton(
                        onPressed: () {
                          uploadPicture();
                          print('Upload photo');
                        },
                        child: const Text('Upload Photo')),
                    ElevatedButton(
                        onPressed: () {
                          selectPicture();
                          print('select a photo');
                        },
                        child: const Text('Select a Photo'))
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Exercise()));
                      },
                      child: const Text('Save and Play Again',
                          style: TextStyle(
                            fontSize: 30,
                          )),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(480, 40)),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                      child: const Text('Save and Exit',
                          style: TextStyle(fontSize: 30)),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(480, 40)),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  void takePicture(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    var picture = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: firstCamera)));

    setState(() {
      imagePath = picture;
    });
  }

  void selectPicture() async {
    final picture1 = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (picture1 == null) return;
    setState(() {
      imagePath = picture1.path;
    });
  }

  void uploadPicture() async {
    try {
      imagePath == ''
          ? print('Upload failure')
          : await FirebaseStorage.instance
              .ref('images/${widget.startTime}.jpg')
              .putFile(File(imagePath));
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            print(image.path);
            Navigator.pop(context, image.path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
