import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history.dart';

class Profile extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String imagePath = "";
  String name = "";
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
    _controller.addListener(set);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void get() async {
    final share = await SharedPreferences.getInstance();
    name = share.getString("userName") ?? 'name';
    _controller.text = name;
  }

  void set() async {
    final share = await SharedPreferences.getInstance();
    share.setString('userName', _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, HistoryModel historyModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'enter your name',
                  labelText: '',
                  //border: OutlineInputBorder()
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    width: 260,
                    height: 170,
                    child: imagePath == ''
                        ? Container()
                        : Image.file(File(imagePath)),
                  ),
                  IconButton(
                    onPressed: () async {
                      takePicture(context);
                    },
                    icon: Icon(Icons.camera_alt),
                    iconSize: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      selectPicture();
                    },
                    icon: Icon(Icons.photo_library),
                    iconSize: 50,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Total exercise count',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(historyModel.totalGameCount.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  const Text(
                    'Total exercise time',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(historyModel.totalGameTime.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  const Text(
                    'Total repeat',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(historyModel.totalRepeated.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  const Text(
                    'Total finished',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(historyModel.totalFinished.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  const Text(
                    'Total Unfinished',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(historyModel.totalUnfinished.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  const Text(
                    'Total right clicked',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(historyModel.totalRightClicked.toString(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ))

            // Container(
            //   child: Column(
            //     children: [
            //       const Text(
            //         'Total exercise count',
            //         style: TextStyle(fontSize: 20, color: Colors.grey),
            //       ),
            //       Text(historyModel.totalGameCount.toString(),
            //           style: const TextStyle(
            //               fontSize: 30,
            //               color: Colors.red,
            //               fontWeight: FontWeight.bold)),
            //       const Text(
            //         'Total exercise time',
            //         style: TextStyle(fontSize: 20, color: Colors.grey),
            //       ),
            //       Text(historyModel.totalGameTime.toString(),
            //           style: const TextStyle(
            //               fontSize: 30,
            //               color: Colors.red,
            //               fontWeight: FontWeight.bold)),
            //       const Text(
            //         'Total repeat',
            //         style: TextStyle(fontSize: 20, color: Colors.grey),
            //       ),
            //       Text(historyModel.totalRepeated.toString(),
            //           style: const TextStyle(
            //               fontSize: 30,
            //               color: Colors.red,
            //               fontWeight: FontWeight.bold)),
            //       const Text(
            //         'Total finished',
            //         style: TextStyle(fontSize: 20, color: Colors.grey),
            //       ),
            //       Text(historyModel.totalFinished.toString(),
            //           style: const TextStyle(
            //               fontSize: 30,
            //               color: Colors.red,
            //               fontWeight: FontWeight.bold)),
            //       const Text(
            //         'Total Unfinished',
            //         style: TextStyle(fontSize: 20, color: Colors.grey),
            //       ),
            //       Text(historyModel.totalUnfinished.toString(),
            //           style: const TextStyle(
            //               fontSize: 30,
            //               color: Colors.red,
            //               fontWeight: FontWeight.bold)),
            //       const Text(
            //         'Total right clicked',
            //         style: TextStyle(fontSize: 20, color: Colors.grey),
            //       ),
            //       Text(historyModel.totalRightClicked.toString(),
            //           style: const TextStyle(
            //               fontSize: 30,
            //               color: Colors.red,
            //               fontWeight: FontWeight.bold)),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Profile'),
  //       centerTitle: true,
  //     ),
  //     body: Container(
  //       padding: EdgeInsets.all(4.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //               child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Jay',
  //                 style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
  //               )
  //             ],
  //           )),
  //           Container(
  //             width: MediaQuery.of(context).size.width,
  //             child: Row(
  //               children: [
  //                 Container(
  //                   width: 260,
  //                   height: 160,
  //                   child: imagePath == ''
  //                       ? Container()
  //                       : Image.file(File(imagePath)),
  //                 ),
  //                 IconButton(
  //                   onPressed: () async {
  //                     takePicture(context);
  //                   },
  //                   icon: Icon(Icons.camera_alt),
  //                   iconSize: 50,
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 IconButton(
  //                   onPressed: () async {
  //                     selectPicture();
  //                   },
  //                   icon: Icon(Icons.photo_library),
  //                   iconSize: 50,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const Text(
  //             'Total exercise count',
  //             style: TextStyle(fontSize: 20, color: Colors.grey),
  //           ),
  //           Text(historyModel.totalGameCount.toString(),
  //               style: const TextStyle(
  //                   fontSize: 30,
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold)),
  //           const Text(
  //             'Total exercise time',
  //             style: TextStyle(fontSize: 20, color: Colors.grey),
  //           ),
  //           Text(historyModel.totalGameTime.toString(),
  //               style: const TextStyle(
  //                   fontSize: 30,
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold)),
  //           const Text(
  //             'Total repeat',
  //             style: TextStyle(fontSize: 20, color: Colors.grey),
  //           ),
  //           Text(historyModel.totalRepeated.toString(),
  //               style: const TextStyle(
  //                   fontSize: 30,
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold)),
  //           const Text(
  //             'Total finished',
  //             style: TextStyle(fontSize: 20, color: Colors.grey),
  //           ),
  //           Text(historyModel.totalFinished.toString(),
  //               style: const TextStyle(
  //                   fontSize: 30,
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold)),
  //           const Text(
  //             'Total Unfinished',
  //             style: TextStyle(fontSize: 20, color: Colors.grey),
  //           ),
  //           Text(historyModel.totalUnfinished.toString(),
  //               style: const TextStyle(
  //                   fontSize: 30,
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold)),
  //           const Text(
  //             'Total right clicked',
  //             style: TextStyle(fontSize: 20, color: Colors.grey),
  //           ),
  //           Text(historyModel.totalRightClicked.toString(),
  //               style: const TextStyle(
  //                   fontSize: 30,
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.bold)),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void takePicture(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    var picture = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: firstCamera)));

    setState(() {
      imagePath = picture;
      name = dateFormat.format(DateTime.now());
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
              .ref('images/$name.jpg')
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
