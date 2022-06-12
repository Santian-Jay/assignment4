import 'package:assignment4/historyview_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'history.dart';

class HistoryDetail extends StatefulWidget {
  final String id;
  final int index;
  const HistoryDetail({Key? key, required this.id, required this.index})
      : super(key: key);

  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  @override
  Widget build(BuildContext context) {
    var histories = Provider.of<HistoryModel>(context, listen: false).histories;
    var history = histories[widget.index];
    var historyModel = HistoryModel();
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text('History Detail'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 4.0, right: 4.0),
        child: Column(
          children: [
            Container(
              //color: Colors.yellow,
              child: SizedBox(
                width: 200,
                height: 140,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: [
                  Text(
                    'Staer Time: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //widget.endTime,
                    history.startTime,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //widget.endTime,
                    history.endTime,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //widget.endTime,
                    history.duration.toString(),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //widget.endTime,
                    history.repeat.toString(),
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
                    'Completed: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //widget.endTime,
                    history.completed ? 'Done' : 'Undone',
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
                    'Exercise Mode: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //widget.endTime,
                    history.gameMode,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //widget.endTime,
                    history.exercise,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    history.rightCklick.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Button clicked sequence',
                style: TextStyle(fontSize: 20, color: Colors.grey)),
            Container(
              //color: Colors.blue,
              width: 500,
              height: 100,
              child: Text(
                history.clickedButtons.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Container(
            //child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // children: [
            ElevatedButton(
              onPressed: () {
                shareRecord(history);
              },
              child: const Text(
                'Share Record',
                style: TextStyle(fontSize: 30),
              ),
              style: ElevatedButton.styleFrom(minimumSize: const Size(480, 50)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                showDeleteAlert(historyModel, history);
              },
              child: const Text(
                'Delete Record',
                style: TextStyle(fontSize: 30),
              ),
              style: ElevatedButton.styleFrom(minimumSize: const Size(480, 50)),
            ),
            //],
            //),
            ///)
          ],
        ),
      ),
    );
  }

  void showDeleteAlert(HistoryModel historyModel, History history) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Hi Dear'),
            content: Text('Do you want to delete this record?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No')),
              FlatButton(
                  onPressed: () => {
                        setState(() {
                          historyModel.delete(history.id);
                        }),
                        Navigator.of(context).pop(),
                        //Navigator.of(context).pop(),
                        historyModel.update(),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryViewTest())),
                      },
                  child: Text('Yes')),
            ],
          );
        });
  }

  void shareRecord(History history) async {
    await Share.share(history.ShareRecord(history));
  }
}
