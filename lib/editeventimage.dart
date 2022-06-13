import 'dart:convert';
import 'dart:io';

import 'package:event_announcer_system/event.dart';
import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class EditEventImage extends StatefulWidget {
  final Event event;
  final User user;
  const EditEventImage({Key? key, required this.event, required this.user})
      : super(key: key);

  @override
  State<EditEventImage> createState() => _EditEventImageState();
}

class _EditEventImageState extends State<EditEventImage> {
  // late ProgressDialog pr;
  late double screenHeight, screenWidth;
  String pathAsset = 'assets/images/camera.png';
  var _image;
  final bool _visible = true;
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
    // _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event Image'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  const Text("Edit Image",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => {_editImage()},
                    // _onPictureSelectionDialog()
                    child: _image == null
                        ? Image.network(
                            "http://hubbuddies.com/s269926/event_announce_system/images/event/${widget.event.evid}.png",
                            width: double.infinity,
                            height: screenHeight / 3.5,
                          )
                        : Image.file(
                            _image!,
                            width: double.infinity,
                            height: screenHeight / 3.5,
                          ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                      "Click image to take your picture either camera or gallery",
                      style: TextStyle(fontSize: 10.0, color: Colors.black)),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _editEventImage();
                        },
                        child: Text("Edit Image",
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
                        color: Theme.of(context).colorScheme.secondary,
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
                        color: Theme.of(context).colorScheme.secondary,
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
      setState(() {});
    } else {
      print('No image selected.');
    }
    // _cropImage();
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
      setState(() {});
    } else {
      print('No image selected.');
    }
    // _cropImage();
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

  void _editImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Do you want to edit this image?"),
            actions: [
              TextButton(
                child: const Text('Edit'),
                onPressed: () {
                  // _editEventImage();
                  Navigator.of(context).pop();
                  _onPictureSelectionDialog();
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

  void _editEventImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Edit the event image??"),
            content: const Text("Are your sure to edit?"),
            actions: [
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _postEditImage();
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

  void _postEditImage() {
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String evtitle = _evtitle.text.toString();
    String evdate = _evdate.text.toString();
    String evtime = _evtime.text.toString();
    String evvenue = _evvenue.text.toString();
    String evdescription = _evdescription.text.toString();
    String evparticipate = _evparticipate.text.toString();
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/edit_event_image.php"),
        body: {
          "email": widget.user.user_email!,
          "evid": widget.event.evid,
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
