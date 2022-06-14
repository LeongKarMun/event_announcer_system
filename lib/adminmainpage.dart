import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_announcer_system/adminapprove.dart';
import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/eventdetails.dart';
import 'package:event_announcer_system/loginscreen.dart';
import 'package:event_announcer_system/user.dart';
import 'package:event_announcer_system/userregister.dart';
import 'package:event_announcer_system/viewacc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminMainPage extends StatefulWidget {
  final User user;
  const AdminMainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  late PageController _pageController;
  // late Timer _timer;
  // List<String> imageList = [
  //   "assets/images/event1.jpg",
  //   "assets/images/event2.jpg",
  //   "assets/images/event3.jpg",
  //   "assets/images/event4.jpg",
  // ];
  // int currentIndex = 1000;
  String _titlecenter = "Loading...";
  List _eventList = [];
  late double screenHeight, screenWidth;
  int eventItem = 0;
  int sortButton = 1;
  late final String title;
  final TextEditingController _srcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _pageController = PageController(initialPage: currentIndex);
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   startTimer();
    // });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _testasync();
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer.cancel();
  // }

  // void startTimer() {
  //   _timer = Timer.periodic(const Duration(milliseconds: 2000), (value) {
  //     print("Timer");
  //     currentIndex++;
  //     _pageController.animateToPage(currentIndex,
  //         duration: const Duration(milliseconds: 200), curve: Curves.ease);
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: const Text("MENU",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.blueGrey[400]),
            ),
            ListTile(
              title:
                  const Text("Manage Account", style: TextStyle(fontSize: 16)),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => AdminApprove(user: widget.user)));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => MainScreen(user: widget.user)));
              },
            ),
            ListTile(
              title: const Text("View Account Status",
                  style: TextStyle(fontSize: 16)),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => ViewAcc(user: widget.user)));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => MainScreen(user: widget.user)));
              },
            ),
            ListTile(
              title: const Text("My Account", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => UserAccount(user: widget.user)));
              },
            ),
            ListTile(
                title: const Text("Logout", style: TextStyle(fontSize: 16)),
                onTap: _logout),
          ],
        ),
      ),
      body: Center(
          child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 45,
                width: screenWidth / 1.2,
                child: TextFormField(
                  style: const TextStyle(fontSize: 15),
                  controller: _srcController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchevent(_srcController.text);
                      },
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
              )
            ],
          ),
        ),
        // Container(
        //   child: buildBanner(),
        // ),
        const SizedBox(height: 10),
        const Text('Discover',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (_eventList.isEmpty)
          Flexible(child: Center(child: Text(_titlecenter)))
        else
          Flexible(
              child: Center(
                  child: GridView.count(
                      crossAxisCount: 1,
                      // childAspectRatio: (screenWidth / screenHeight) / 0.85,
                      childAspectRatio: 2.5 / 1,
                      children: List.generate(_eventList.length, (index) {
                        return GestureDetector(
                            onTap: () => _descrip(index),
                            child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Card(
                                    elevation: 10,
                                    // child: SingleChildScrollView(
                                    child: Row(children: [
                                      Expanded(
                                          flex: 5,
                                          // child: Column(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          child: Container(
                                            height: screenHeight / 5,
                                            width: screenWidth / 1.1,
                                            child: Image.network(
                                              "https://hubbuddies.com/s269926/event_announce_system/images/event/${_eventList[index]['evid']}.png",
                                              //  fit: BoxFit.fitWidth,
                                            ),
                                          )),
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
                                              Text(_eventList[index]['evtitle'],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                                          Text(
                                                  descpSub(_eventList[index]
                                                      ['evdescription']),
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))));
                      }))))
      ])),
    ));
  }

  _loadEvent() {
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/load_event.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
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

  // Widget buildBanner() {
  //   return Container(
  //     height: 250,
  //     width: double.infinity,
  //     child: Stack(
  //       children: [
  //         buildBannerWidget(),
  //         buildTipsWidget(),
  //       ],
  //     ),
  //   );
  // }

  // buildBannerWidget() {
  //   return PageView.builder(
  //     itemBuilder: (BuildContext context, int index) {
  //       return buildPageViewItemWidget(index);
  //     },
  //     controller: _pageController,
  //     itemCount: imageList.length * 10000,
  //     onPageChanged: (int index) {
  //       setState(() {
  //         currentIndex = index;
  //       });
  //     },
  //   );
  // }

  // buildPageViewItemWidget(int index) {
  //   return Image.asset(
  //     imageList[index % imageList.length],
  //     fit: BoxFit.fill,
  //   );
  // }

  // buildTipsWidget() {
  //   return Positioned(
  //     bottom: 20,
  //     right: 20,
  //     child: Container(
  //       padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
  //       decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(10))),
  //       child:
  //           Text("${currentIndex % imageList.length + 1}/${imageList.length}"),
  //     ),
  //   );
  // }



  Future<void> _testasync() async {
    await _loadEvent();
  }

  void _descrip(index) {
    Event event = Event(
      evid: _eventList[index]['evid'],
      evtitle: _eventList[index]['evtitle'],
      evdate: _eventList[index]['evdate'],
      evtime: _eventList[index]['evtime'],
      evvenue: _eventList[index]['evvenue'],
      evdescription: _eventList[index]['evdescription'],
      evparticipate: _eventList[index]['evparticipate'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) =>
                EventDetails(event: event, user: widget.user)));
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

  _searchevent(String evtitle) {
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/load_event.php"),
        body: {"evtitle": evtitle}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        _eventList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _eventList = jsondata["events"];
        _titlecenter = "";
        setState(() {});
      }
    });
  }
}
