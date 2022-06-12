import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'history.dart';
import 'historydetail.dart';
import 'main.dart';

class HistoryViewTest extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context,
              snapshot) //this function is called every time the "future" updates
          {
        // Check for errors
        if (snapshot.hasError) {
          return FullScreenText(text: "Something went wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //BEGIN: the old MyApp builder from last week
          return ChangeNotifierProvider(
              create: (context) => HistoryModel(),
              child: MaterialApp(
                  title: 'History',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: MyHomePage1(title: 'History')));
          //END: the old MyApp builder from last week
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return FullScreenText(text: "Loading");
      },
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  MyHomePage1({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePage1State createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  var listIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, HistoryModel historyModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //YOUR UI HERE
            if (historyModel.loading)
              CircularProgressIndicator()
            else
              //Expanded(
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  listIndex = 1;
                                });

                                await historyModel.fetch();
                              },
                              child: const Text(
                                'All',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(136, 40)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  listIndex = 2;
                                });

                                await historyModel.fetchFinished();
                              },
                              child: const Text(
                                'Finished',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(136, 40)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  listIndex = 3;
                                  print(listIndex);
                                });

                                await historyModel.fetchUnFinished();
                              },
                              child: const Text(
                                'Unfinished',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(136, 40)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
                child: Scrollbar(
              isAlwaysShown: true,
              child: ListView.builder(
                  itemBuilder: (_, index) {
                    var history = historyModel.histories[index];
                    //var image = movie.image;
                    return Container(
                      key: ValueKey(history.id),
                      child: ListTile(
                        title: Text(
                            'Start Time: ' +
                                history.id +
                                '\n' +
                                'End Time: ' +
                                history.endTime,
                            style: TextStyle(fontSize: 20)),
                        subtitle: Text(
                          'Duration: ' +
                              history.duration.toString() +
                              " S \n" +
                              'Repeated: ' +
                              history.repeat.toString() +
                              ' times \n' +
                              'Completed: ' +
                              (history.completed ? 'Done' : 'Undone'),
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HistoryDetail(
                              id: history.id,
                              index: index,
                            );
                          }));
                        },
                      ),
                    );
                  },
                  itemCount: historyModel.histories.length),
            )),
            Text(
              'Total ' + historyModel.histories.length.toString() + ' records',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

//A little helper widget to avoid runtime errors -- we can't just display a Text() by itself if not inside a MaterialApp, so this workaround does the job
class FullScreenText extends StatelessWidget {
  final String text;

  const FullScreenText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(children: [Expanded(child: Center(child: Text(text)))]));
  }
}
