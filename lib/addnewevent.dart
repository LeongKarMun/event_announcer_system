import 'dart:convert';
import 'dart:io';

import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddNewEvent extends StatefulWidget {
  final User user;
  const AddNewEvent({Key? key, required this.user}) : super(key: key);

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  late double screenHeight, screenWidth;
  String pathAsset = 'assets/images/camera.png';
  File? _image;
  final bool _visible = true;
  final TextEditingController _evtitle = TextEditingController();
  final TextEditingController _evvenue = TextEditingController();
  final TextEditingController _evdescription = TextEditingController();
  final TextEditingController _evparticipate = TextEditingController();
  DateTime dateTime = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Event"),
      ),
      floatingActionButton: Visibility(
          visible: _visible,
          child: FloatingActionButton.extended(
            label: const Text('New'),
            onPressed: () {
              _addNewEvent();
            },
            icon: const Icon(Icons.add),
            backgroundColor: Colors.blue,
          )),
      body: Center(
        child: Container(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  const Text("Add New Event Status",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => {_onPictureSelectionDialog()},
                    child: Container(
                        height: screenHeight / 3.5,
                        width: screenWidth / 1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset) as ImageProvider
                                : FileImage(_image!),
                            fit: BoxFit.scaleDown,
                          ),
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        )),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                      "Click image to take your picture either camera or gallery",
                      style: TextStyle(fontSize: 10.0, color: Colors.black)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _evtitle,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text("Date"),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                              '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          child: const Text('Select Date'),
                          onPressed: () async {
                            final _evdate = await pickDate();
                            if (_evdate == null) return; //press cancel

                            setState(() => dateTime = _evdate);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text("Time"),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                              '${time.hour}:${time.minute} ${time.period.toString().split('.')[1]}',
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          child: const Text('Select Time'),
                          onPressed: () async {
                            final _evtime = await pickTime();
                            if (_evtime == null) return; //press cancel

                            setState(() => time = _evtime);
                          },
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _evvenue,
                    decoration: const InputDecoration(labelText: 'Venue'),
                  ),
                  TextFormField(
                    minLines: 2,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _evdescription,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Description'),
                  ),
                  TextField(
                    controller: _evparticipate,
                    decoration: const InputDecoration(labelText: 'Participate'),
                  ),
                ],
              ))),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: time,
      );

  void _addNewEvent() {
    if (_image == null ||
        _evtitle.text.toString() == "" ||
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
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Add the new event status??"),
            content: const Text("Are your sure to add?"),
            actions: [
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _postnewEvent(widget.user.user_email!);
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

  _onPictureSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Take picture from:",
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
                        child: const Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: const Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseGallery()},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  Future<void> _postnewEvent(String email) async {
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String evtitle = _evtitle.text.toString();
    String evdate = dateTime.year.toString() +
        "/" +
        dateTime.month.toString() +
        "/" +
        dateTime.day.toString();
    String evtime = time.hour.toString() + ":" + time.minute.toString();
    String evvenue = _evvenue.text.toString();
    String evdescription = _evdescription.text.toString();
    String evparticipate = _evparticipate.text.toString();
    // print(evtitle);
    // print(evdate);
    // print(evtime);
    // print(evvenue);
    // print(evdescription);
    // print(evparticipate);
    print(widget.user.user_email!);
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/add_event.php"),
        body: {
          "email": widget.user.user_email!,
          "evtitle": evtitle,
          "evdate": evdate,
          "evtime": evtime,
          "evvenue": evvenue,
          "evdescription": evdescription,
          "evparticipate": evparticipate,
          "encoded_string": base64Image
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
          _image = null;
          _evtitle.text = "";
          _evvenue.text = "";
          _evdescription.text = "";
          _evparticipate.text = "";
        });
      } else if (response.body == "noRecord") {
        Fluttertoast.showToast(
            msg: "no record",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
