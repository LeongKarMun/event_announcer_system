import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_announcer_system/manageevent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'addnewevent.dart';
import 'loginscreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  late Timer _timer;
  List<String> imageList = [
    "assets/images/event1.jpg",
    "assets/images/event2.jpg",
    "assets/images/event3.jpg",
    "assets/images/event4.jpg",
  ];
  int currentIndex = 1000;
  String _titlecenter = "Loading...";
  List _eventList = [];
  late double screenHeight, screenWidth;
  int eventItem = 0;
  int sortButton = 1;
  late final String title;
  TextEditingController _srcController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: currentIndex);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      startTimer();
    });
        WidgetsBinding.instance!.addPostFrameCallback((_) {
      _testasync();
    });
  }


  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    _timer = new Timer.periodic(Duration(milliseconds: 2000), (value) {
      print("Timer");
      currentIndex++;
      _pageController.animateToPage(currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("MENU",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.blueGrey[400]),
            ),
            ListTile(
              title: Text("Manage Event", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => ManageEvent()));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => MainScreen(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("Add New Event", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => AddNewEvent()));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => MainScreen(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("My Account", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => UserAccount(user: widget.user)));
              },
            ),
            ListTile(
                title: Text("Logout", style: TextStyle(fontSize: 16)),
                onTap: _logout),
          ],
        ),
      ),
      body: Center(
          child: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 45,
                width: screenWidth / 1.2,
                child: TextFormField(
                  style: TextStyle(fontSize: 15),
                  controller: _srcController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    // suffixIcon: IconButton(
                    //   onPressed: () => _searchProduct(_srcController.text),
                    //   icon: Icon(Icons.search),
                    // ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          child: buildBanner(),
        ),
        if (_eventList.isEmpty)
          Flexible(child: Center(child: Text(_titlecenter)))
        else
          Flexible(
              child: Center(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (screenWidth / screenHeight) / 0.85,
                      children: List.generate(_eventList.length, (index) {
                        return GestureDetector(
                          onTap: () => _descrip(index),
                        child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Card(
                                elevation: 10,
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Container(
                                        height: screenHeight / 5,
                                        width: screenWidth / 1.1,
                                        child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://javathree99.com/s269926/event_announce_system/images/event/${_eventList[index]['evid']}.jpg",
                                            ),
                                      ),
                                      SizedBox(height:10),
                                      Container(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                titleSub(_eventList[index]
                                                    ['evtitle']),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          // Text(
                                          //     titleSub(_eventList[index]['evdescp']),
                                          //     style: TextStyle(fontSize: 16)),
                                        ],
                                      ))
                                    ])))));
                      }))))
      ])),
    ));
  }

  _loadEvent() {
    http.post(
        Uri.parse(
            "http://javathree99.com/s269926/event_announce_system/php/load_event.php"),
        body: {}).then((response) {
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

  Widget buildBanner() {
    return Container(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          buildBannerWidget(),
          buildTipsWidget(),
        ],
      ),
    );
  }

  buildBannerWidget() {
    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return buildPageViewItemWidget(index);
      },
      controller: _pageController,
      itemCount: imageList.length * 10000,
      onPageChanged: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  buildPageViewItemWidget(int index) {
    return Image.asset(
      imageList[index % imageList.length],
      fit: BoxFit.fill,
    );
  }

  buildTipsWidget() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child:
            Text("${currentIndex % imageList.length + 1}/${imageList.length}"),
      ),
    );
  }

  String titleSub(String title) {
    if (title.length >20) {
      return title.substring(0, 25) + "...";
    } else {
      return title;
    }
  }

  void _logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  Future<void> _testasync() async {
    await
    _loadEvent();

  }
}

void _descrip(index) {}

  
