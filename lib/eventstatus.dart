import 'dart:convert';

import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/user.dart';
import 'package:event_announcer_system/viewparticipate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class EventStatus extends StatefulWidget {
  final Event event;
  final User user;
  const EventStatus({Key? key, required this.event, required this.user})
      : super(key: key);

  @override
  State<EventStatus> createState() => _EventStatusState();
}

class _EventStatusState extends State<EventStatus> {
  late double screenHeight;
  late double screenWidth;
  final List _participateList = [];
  final String _titlecenter = "Loading participate info...";

  // @override
  // void initState() {
  //   super.initState();
  //   _testasync();
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        // backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 0, 30, 0),
                  height: screenHeight / 2.5,
                  child: Image.network(
                    "https://hubbuddies.com/s269926/event_announce_system/images/event/${widget.event.evid}.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                    child: Text(widget.event.evtitle.toString(),
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold))),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                    child: Text("Date: " + widget.event.evdate.toString(),
                        style: const TextStyle(fontSize: 18))),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                    child: Text("Time: " + widget.event.evtime.toString(),
                        style: const TextStyle(fontSize: 18))),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                    child: Text("Venue: " + widget.event.evvenue.toString(),
                        style: const TextStyle(fontSize: 18))),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                    child: Text(
                      "Details: " + widget.event.evdescription.toString(),
                      style: const TextStyle(fontSize: 18),
                    )),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                    child: Text(
                      "Total Participate: " +
                          widget.event.evparticipate.toString(),
                      style: const TextStyle(fontSize: 18),
                    )),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () => {Navigator.push(
        context, MaterialPageRoute(builder: (content) => ViewParticipate(event: widget.event, user: widget.user,)))},
                    child: const Text("View Participate"),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 50),
                        primary: Colors.red[900]),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
