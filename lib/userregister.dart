import 'dart:convert';

import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/eventdetails.dart';
import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRegister extends StatefulWidget {
  final User user;
  const UserRegister({Key? key, required this.user}) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  String _titlecenter = "Loading your register event...";
  List _regList = [];

  @override
  void initState() {
    super.initState();
    _loadUserEvent(widget.user.user_email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Register'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(children: [
          if (_regList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 2.5 / 1,
                  children: List.generate(_regList.length, (index) {
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
                                  // padding: EdgeInsets.all(1),
                                  // height: orientation == Orientation.portrait
                                  //     ? 50
                                  //     : 100,
                                  // width: orientation == Orientation.portrait
                                  //     ? 50
                                  //     : 100,
                                  child: Image.network(
                                    "https://hubbuddies.com/s269926/event_announce_system/images/event/${_regList[index]['evid']}.png",
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_regList[index]['evtitle'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      
                                      

                                          Text(
                                          _regList[index]['evdate'] +
                                              '   ' +
                                              _regList[index]['evtime'],
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )))),
                    );
                  }));
            }))
        ])));
  }

  void _descrip(index) {
    Event event = Event(
      evid: _regList[index]['evid'],
      evtitle: _regList[index]['evtitle'],
      evdate: _regList[index]['evdate'],
      evtime: _regList[index]['evtime'],
      evvenue: _regList[index]['evvenue'],
      evdescription: _regList[index]['evdescription'],
      evparticipate: _regList[index]['evparticipate'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) =>
                EventDetails(event: event, user: widget.user)));
  }


  _loadUserEvent(String email) {
    print(email);
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/load_register_event.php"),
        body: {
          "email": email,
        }).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "Sorry no event";
        _regList = [];
        return;
      } else {
        setState(() {
          var jsondata = json.decode(response.body);
          _regList = jsondata["reg"];
        });
        print(_regList);
      }
    });
  }
}
