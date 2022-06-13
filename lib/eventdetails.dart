import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key, required this.event, required this.user})
      : super(key: key);
  final Event event;
  final User user;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late double screenHeight;
  late double screenWidth;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _matric = TextEditingController();
  final TextEditingController _phone = TextEditingController();

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
                    onPressed: () => {_regEvent()},
                    child: const Text("Register"),
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

  void _regEvent() {
    String name = _name.text.toString();
    String matric = _matric.text.toString();
    String phone = _phone.text.toString();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Register event"),

            // content: const Text("Are you sure?"),
            actions: [
              TextField(
                controller: _name,
                // keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Name', icon: Icon(Icons.people)),
              ),
              TextField(
                controller: _matric,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Matric Number', icon: Icon(Icons.note)),
              ),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Phone Number', icon: Icon(Icons.phone)),
              ),
              TextButton(
                child: const Text('Register'),
                onPressed: () {
                  _addEvent(widget.user.user_email!, widget.event.evid!,
                      widget.event.evtitle!);
                },
              ),
              TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _addEvent(String email, String evid, String evtitle) {
    String name = _name.text.toString();
    String matric = _matric.text.toString();
    String phone = _phone.text.toString();
    print(widget.user.user_email!.toString());
    print(widget.event.evid!.toString());
    http.post(
        Uri.parse(
            "https://hubbuddies.com/s269926/event_announce_system/php/register_event.php"),
        body: {
          "email": widget.user.user_email!.toString(),
          "evid": widget.event.evid!.toString(),
          "name": name,
          "matric": matric,
          "phone": phone,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Register success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
        //               setState(() {
        //   _name.text= "";
        //   _matric.text = "";
        //   _phone.text = "";
        // });

      } else if (response.body == "noRecord") {
        Fluttertoast.showToast(
            msg: "no record",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        //               setState(() {
        //   _name.text= "";
        //   _matric.text = "";
        //   _phone.text = "";
        // });
      } else if (response.body == "duplicate") {
        Fluttertoast.showToast(
            msg: "The id has been store in databse",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Register failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        // _loadRegPage();
      }
    });
  }
}
