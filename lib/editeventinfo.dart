
import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class EditEventInfo extends StatefulWidget {
  final Event event;
  final User user;
  const EditEventInfo({Key? key, required this.event, required this.user})
      : super(key: key);

  @override
  State<EditEventInfo> createState() => _EditEventInfoState();
}

class _EditEventInfoState extends State<EditEventInfo> {
  late double screenHeight, screenWidth;
  String pathAsset = 'assets/images/camera.png';
  // var _image;
  // final bool _visible = true;
  List editInfoList = [];
  final TextEditingController _evtitle = TextEditingController();
  final TextEditingController _evdate = TextEditingController();
  final TextEditingController _evtime = TextEditingController();
  final TextEditingController _evvenue = TextEditingController();
  final TextEditingController _evdescription = TextEditingController();
  final TextEditingController _evparticipate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _evtitle.text = widget.event.evtitle!;
    _evdate.text = widget.event.evdate!;
    _evtime.text = widget.event.evtime!;
    _evvenue.text = widget.event.evvenue!;
    _evdescription.text = widget.event.evdescription!;
    _evparticipate.text = widget.event.evparticipate!;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event Information'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  const Text("Edit Information",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _evtitle,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _evdate,
                    decoration: const InputDecoration(labelText: 'Date'),
                  ),
                  TextField(
                    controller: _evtime,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                    ),
                  ),
                  TextField(
                    controller: _evvenue,
                    decoration: const InputDecoration(labelText: 'Venue'),
                  ),
                  TextField(
                    controller: _evdescription,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: _evparticipate,
                    decoration: const InputDecoration(labelText: 'Participate'),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _editEventInfo();
                        },
                        child: Text("Edit Infomation",
                            style: TextStyle(
                                fontSize: 20, color: Colors.blue[600])),
                      ),
                    ],
                  ),
                ],
              ))),
        ),
      ),
    );
  }

  void _editEventInfo() {
    if (_evtitle.text.toString() == "" ||
        _evdate.text.toString() == "" ||
        _evtime.text.toString() == "" ||
        _evdescription.text.toString() == "" ||
        _evparticipate.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Don't empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_evtitle.text.toString() == "" ||
        _evdate.text.toString() == "" ||
        _evtime.text.toString() == "" ||
        _evdescription.text.toString() == "" ||
        _evparticipate.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Don't empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text("Edit the event information??"),
              content: const Text("Are your sure to edit?"),
              actions: [
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _posteditEvent();
                  },
                ),
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });
    }
  }

  Future<void> _posteditEvent() async {
    String evtitle = _evtitle.text.toString();
    String evdate = _evdate.text.toString();
    String evtime = _evtime.text.toString();
    String evvenue = _evvenue.text.toString();
    String evdescription = _evdescription.text.toString();
    String evparticipate = _evparticipate.text.toString();
    print(evtitle);
    print(evdate);
    print(evtime);
    print(evvenue);
    print(evdescription);
    print(evparticipate);
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/edit_event.php"),
        body: {
          "email": widget.user.user_email!,
          "evid": widget.event.evid,
          "evtitle": evtitle,
          "evdate": evdate,
          "evtime": evtime,
          "evvenue": evvenue,
          "evdescription": evdescription,
          "evparticipate": evparticipate,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepOrange,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          widget.event.evtitle = _evtitle.text.toString();
          widget.event.evdate = _evdate.text.toString();
          widget.event.evtime = _evtime.text.toString();
          widget.event.evvenue = _evvenue.text.toString();
          widget.event.evdescription = _evdescription.text.toString();
          widget.event.evparticipate = _evparticipate.text.toString();
        });
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepOrange,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
