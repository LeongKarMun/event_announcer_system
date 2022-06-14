import 'dart:async';
import 'dart:convert';

import 'package:event_announcer_system/addnewevent.dart';
import 'package:event_announcer_system/editeventimage.dart';
import 'package:event_announcer_system/editeventinfo.dart';
import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/eventstatus.dart';
import 'package:event_announcer_system/eventview.dart';
import 'package:event_announcer_system/loginscreen.dart';
import 'package:event_announcer_system/profile.dart';
import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class EventMainPage extends StatefulWidget {
  final User user;
  const EventMainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EventMainPage> createState() => _EventMainPageState();
}

class _EventMainPageState extends State<EventMainPage> {
  String _titlecenter = "Loading your event status...";
  List _ownList = [];
  final bool _visible = true;

  @override
  void initState() {
    super.initState();
    _loadNewEvent(widget.user.user_email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Events Status'),
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
            child: ListView(children: [
          DrawerHeader(
            child: const Text("MENU",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            decoration: BoxDecoration(color: Colors.blueGrey[400]),
          ),
          ListTile(
            title: const Text("Discover Event", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => EventView(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text("My Account", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (content) => Profile(user: widget.user)));
            },
          ),
          ListTile(
              title: const Text("Logout", style: TextStyle(fontSize: 16)),
              onTap: _logout),
        ])),
        floatingActionButton: Visibility(
            visible: _visible,
            child: FloatingActionButton.extended(
              label: const Text('New'),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                AddNewEvent(user: widget.user)))
                    .then((value) => _loadNewEvent(widget.user.user_email!));
              },
              icon: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            )),
        body: Center(
            child: Column(children: [
          if (_ownList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 2.5 / 1,
                  children: List.generate(_ownList.length, (index) {
                    return GestureDetector(
                        onTap: () => _descrip(index),
                        child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Container(
                                child: Card(
                                    child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    child: Image.network(
                                      "https://hubbuddies.com/s269926/event_announce_system/images/event/${_ownList[index]['evid']}.png",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 100,
                                    child: const VerticalDivider(
                                        color: Colors.grey)),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_ownList[index]['evtitle'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                                Text(
                                              descpSub(_ownList[index]['evdescription']),
                                              style: const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _selectedit(index);
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
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteEventDialog(index);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )))));
                  }));
            }))
        ])));
  }

  void _deleteEventDialog(int index) {
    showDialog(
        builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: const Text(
                  'Delete from your list?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteEvent(index);
                    },
                  ),
                  TextButton(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }

  Future<void> _deleteEvent(int index) async {
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/delete_event.php"),
        body: {
          "email": widget.user.user_email,
          "evid": _ownList[index]['evid']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Delete Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadNewEvent(widget.user.user_email!);
      } else {
        Fluttertoast.showToast(
            msg: "Delete Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  _loadNewEvent(String email) {
    print(email);
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/load_add_event.php"),
        body: {
          "email": email,
        }).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "Sorry no event";
        _ownList = [];
        return;
      } else {
        setState(() {
          var jsondata = json.decode(response.body);
          _ownList = jsondata["view"];
        });
        print(_ownList);
      }
    });
  }

  void _editevent(int index) {
    Event event = Event(
      evid: _ownList[index]['evid'],
      evtitle: _ownList[index]['evtitle'],
      evdate: _ownList[index]['evdate'],
      evtime: _ownList[index]['evtime'],
      evvenue: _ownList[index]['evvenue'],
      evdescription: _ownList[index]['evdescription'],
      evparticipate: _ownList[index]['evparticipate'],
    );

    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) =>
                    EditEventInfo(event: event, user: widget.user)))
        .then((value) => _loadNewEvent(widget.user.user_email!));
  }

  void _selectedit(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Select edit part:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: const Text('Information',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _editevent(index)},
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: const Text('Image',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _editimage(index)},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  _editimage(int index) {
    Event event = Event(
      evid: _ownList[index]['evid'],
      evtitle: _ownList[index]['evtitle'],
      evdate: _ownList[index]['evdate'],
      evtime: _ownList[index]['evtime'],
      evvenue: _ownList[index]['evvenue'],
      evdescription: _ownList[index]['evdescription'],
      evparticipate: _ownList[index]['evparticipate'],
    );

    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) =>
                    EditEventImage(event: event, user: widget.user)))
        .then((value) => _loadNewEvent(widget.user.user_email!));
  }

  _descrip(int index) {
    Event event = Event(
      evid: _ownList[index]['evid'],
      evtitle: _ownList[index]['evtitle'],
      evdate: _ownList[index]['evdate'],
      evtime: _ownList[index]['evtime'],
      evvenue: _ownList[index]['evvenue'],
      evdescription: _ownList[index]['evdescription'],
      evparticipate: _ownList[index]['evparticipate'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) =>
                EventStatus(event: event, user: widget.user)));
  }
    String descpSub(String descp) {
    if (descp.length > 35) {
      return descp.substring(0, 35) + "...";
    } else {
      return descp;
    }
  }

  void _logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
