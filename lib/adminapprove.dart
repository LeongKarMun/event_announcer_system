import 'dart:convert';

import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AdminApprove extends StatefulWidget {
  final User user;
  const AdminApprove({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminApprove> createState() => _AdminApproveState();
}

class _AdminApproveState extends State<AdminApprove> {
  String _titlecenter = "Loading account status...";
  List _requestList = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _testasync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Approve Account'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(children: [
          if (_requestList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 4.5 / 1,
                  children: List.generate(_requestList.length, (index) {
                    return Card(
                        color: const Color.fromARGB(255, 163, 193, 244),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(
                              _requestList[index]['user_email'],
                              style: const TextStyle(
                                  fontSize: 20, fontFamily: 'Calibri'),
                            ),
                            
                            trailing: IconButton(
                                onPressed: () {
                                  _approve(
                                      _requestList[index]['user_email'],
                                      _requestList[index]['password'],
                                      _requestList[index]['type']);
                                },
                                icon: const Icon(
                                  Icons.arrow_circle_right,
                                  color: Color.fromARGB(255, 40, 80, 113),
                                  size: 40,
                                )),
                          ),
                        ));
                  }));
            }))
        ])));
  }

  _loadRequest() {
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/load_request.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        _requestList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        _requestList = jsondata["request"];
        setState(() {});
        print(_requestList);
      }
    });
  }

  Future<void> _testasync() async {
    await _loadRequest();
  }

  void _approve(String email, String password, String type) {
    print(email);
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/approve_user.php"),
        body: {
          "email": email,
          "password": password,
          "type": type
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Approve Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepOrange,
            textColor: Colors.white,
            fontSize: 16.0);
            _loadRequest();
        // setState(() {});
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
