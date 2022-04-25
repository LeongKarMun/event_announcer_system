import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_announcer_system/addnewevent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class ManageEvent extends StatefulWidget {
  const ManageEvent({Key? key}) : super(key: key);

  @override
  State<ManageEvent> createState() => _ManageEventState();
}

class _ManageEventState extends State<ManageEvent> {
  String _titlecenter = "Loading your event status...";
  List _eventList = [];
  int quantity = 0;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _loadNewEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Events Status'),
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: Visibility(
            visible: _visible,
            child: FloatingActionButton.extended(
              label: Text('New'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => AddNewEvent()));
              },
              icon: Icon(Icons.add),
              backgroundColor: Colors.blue,
            )),
        body: Center(
            child: Column(children: [
          if (_eventList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 2.5 / 1,
                  children: List.generate(_eventList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                            child: Card(
                                child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                height: orientation == Orientation.portrait
                                    ? 50
                                    : 100,
                                width: orientation == Orientation.portrait
                                    ? 50
                                    : 100,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://javathree99.com/s269926/event_announce_system/images/event/${_eventList[index]['evid']}.jpg",
                                ),
                              ),
                            ),
                            Container(
                                height: 100,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_eventList[index]['evtitle'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _deleteEventDialog(index);
                                    },
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteEventDialog(index);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ))));
                  }));
            }))
        ])));
  }

  void _deleteEventDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Delete from your list?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteCart(index);
                    },
                  ),
                  TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }
  Future<void> _deleteCart(int index) async {
    // ProgressDialog progressDialog = ProgressDialog(context,
    //     message: Text("Delete from cart"), title: Text("Progress..."));
    // progressDialog.show();
    // await Future.delayed(Duration(seconds: 1));
    // http.post(Uri.parse("https://javathree99.com/s269926/alloutgroceries/php/delete_usercart.php"),
    //     body: {
    //       "email": widget.email,
    //       "prid": _eventList[index]['prid']
    //     }).then((response) {
    //   print(response.body);
    //   if (response.body == "success") {
    //     Fluttertoast.showToast(
    //         msg: "Success",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //     _loadMyCart();
    //   } else {
    //     Fluttertoast.showToast(
    //         msg: "Failed",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //   }
    //   progressDialog.dismiss();
    // });
  }

  _loadNewEvent() {
    http.post(
        Uri.parse(
            "http://javathree99.com/s269926/event_announce_system/php/load_event.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "Sorry no event";
        _eventList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        _eventList = jsondata["events"];
        setState(() {});
        print(_eventList);
      }
    });
  }
}
