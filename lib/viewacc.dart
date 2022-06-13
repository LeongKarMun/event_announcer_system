import 'dart:convert';

import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ViewAcc extends StatefulWidget {
  final User user;
  const ViewAcc({ Key? key, required this.user }) : super(key: key);

  @override
  State<ViewAcc> createState() => _ViewAccState();
}

class _ViewAccState extends State<ViewAcc> {
 String _titlecenter = "Loading account status...";
  List _accList = [];
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
          title: const Text('View Account Status'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(children: [
          if (_accList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 4.5 / 1,
                  children: List.generate(_accList.length, (index) {
                    return Card(
                        color: const Color.fromARGB(255, 198, 218, 252),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(
                              _accList[index]['user_email'],
                              style: const TextStyle(
                                  fontSize: 20, fontFamily: 'Calibri'),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                children:<TextSpan>[
                                  TextSpan(text: _accList[index]['type']+"\n",style: const TextStyle(fontSize: 16, color:Color.fromARGB(255, 60, 39, 250))),
                                  TextSpan(text:_accList[index]['status']+"\n",style: const TextStyle(fontSize: 16, color:Color.fromARGB(255, 60, 39, 250))),
                                ]
                              )),
                          ),
                        ));
                  }));
            }))
        ])));
  }

  _loadAcc() {
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/load_acc.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no account to show";
        _accList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        _accList = jsondata["acc"];
        setState(() {});
        print(_accList);
      }
    });
  }

  Future<void> _testasync() async {
    await _loadAcc();
  }
}
