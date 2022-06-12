import 'package:assignment4/history.dart';
import 'package:assignment4/historyview_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise.dart';
import 'profile.dart';
import 'gameover.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => HistoryModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const MyHomePage(title: 'Hands Back')
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(saveName);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future<void> saveName() async {
    final saveName = await SharedPreferences.getInstance();
    saveName.setString("userName", nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hands Back'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Welcome!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            // Container(
            //   child: TextField(
            //     controller: nameController,
            //     decoration: const InputDecoration(
            //       border: OutlineInputBorder()
            //     ),
            //   ),
            // )
            SizedBox(
              height: 16,
            ),
            Text(
              'Today is still a hopeful day!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              width: 230,
              child: ElevatedButton(
                child: const Text(
                  'Exercise',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Exercise(),
                      ))
                },
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              width: 230,
              child: ElevatedButton(
                child: const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryViewTest(),
                      ))
                },
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              width: 230,
              child: ElevatedButton(
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(),
                      ))
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
