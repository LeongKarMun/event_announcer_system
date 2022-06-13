import 'dart:convert';
import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ViewParticipate extends StatefulWidget {
  final User user;
  final Event event;
  const ViewParticipate({Key? key, required this.event, required this.user})
      : super(key: key);

  @override
  State<ViewParticipate> createState() => _ViewParticipateState();
}

class _ViewParticipateState extends State<ViewParticipate> {
  String _titlecenter = "Loading participate...";
  List _participateList = [];
  int index = 0;

    @override
  void initState() {
    super.initState();
    _loadParticipate(widget.event.evid!.toString());
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
          if (_participateList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 4.5 / 1,
                  children: List.generate(_participateList.length, (index) {
                    return Card(
                        color: const Color.fromARGB(255, 198, 218, 252),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(
                              _participateList[index]['name'],
                              style: const TextStyle(
                                  fontSize: 20, fontFamily: 'Calibri'),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                children:<TextSpan>[
                                  // TextSpan(text:_participateList[index]['name']+"\n",style: const TextStyle(fontSize: 16, color:Color.fromARGB(255, 60, 39, 250))),
                                  TextSpan(text:_participateList[index]['matric']+"\n",style: const TextStyle(fontSize: 16, color:Color.fromARGB(255, 60, 39, 250))),
                                  // TextSpan(text:_participateList[index]['phone']+"\n",style: const TextStyle(fontSize: 16, color:Color.fromARGB(255, 60, 39, 250))),
                                ]
                              )),
                              trailing:Text(
                              _participateList[index]['phone'],
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'Calibri'),
                            ),
                          ),
                        ));
                  }));
            }))
        ])));
  }

  _loadParticipate(String evid) {
    print(evid);
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/load_participate.php"),
        body: {
          "evid": evid,
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no account to show";
        _participateList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        _participateList = jsondata["participate"];
        setState(() {});
        print(_participateList);
      }
    });
  }
}