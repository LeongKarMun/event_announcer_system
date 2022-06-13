import 'dart:io';
import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late double screenHeight, screenWidth;
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phoneNo = TextEditingController();
  bool _isEnable = false;
  late File _image;

  @override
  void initState() {
    super.initState();
    _userName.text = widget.user.username!;
    _phoneNo.text = widget.user.phoneno!;
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY ACCOUNT'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 370,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => {_onPictureSelectionDialog()},
                      child: Container(
                         height: screenHeight / 3,
                          width: screenWidth / 1,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/profile.jpg'),
                              fit: BoxFit.scaleDown,
                            ),
                          )),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Click the icon to add photo',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shadowColor: Colors.red.shade900,
                      elevation: 10,
                      child: Column(
                        children: [
                          TextButton(onPressed: () {  print(widget.user.user_email!);},
                          child: const Text("email"),),
                          // Container(
                          //   padding:  const EdgeInsets.fromLTRB(50, 10, 20, 5),
                          //   child: Text(
                          //     'Email: ' + widget.user.user_email!,
                          //     style:  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 60,
                                    child: TextField(
                                      controller: _userName,
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          labelText: 'Username: ',
                                          enabled: _isEnable,
                                          icon: Icon(Icons.account_circle,
                                              color: Colors.blue.shade900)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: IconButton(
                                        alignment: Alignment.topRight,
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          setState(() {
                                            _isEnable = true;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 60,
                                    child: TextField(
                                      controller: _phoneNo,
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          labelText: 'Phone Number: ',
                                          enabled: _isEnable,
                                          icon: Icon(
                                              Icons.phone_android_rounded,
                                              color: Colors.blue.shade900)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: IconButton(
                                        alignment: Alignment.topRight,
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          setState(() {
                                            _isEnable = true;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: TextButton(
                          onPressed: () {
                            _done();
                          },
                          child: const Text('Done')),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _done() {
    String username = _userName.text.toString();
    String phoneno = _phoneNo.text.toString();
    print(username);
    print(phoneno);
    http.post(
        Uri.parse(
            "https://hubbuddies.com/s269926/event_announce_system/php/account.php"),
        body: {
          "email": widget.user.user_email,
          "username": username,
          "phoneno": phoneno,
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Updated!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          widget.user.username = _userName.text.toString();
          widget.user.phoneno = _phoneNo.text.toString();
        });
      }
    });
  }

  _onPictureSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(20))),
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
                      "Add photo from ",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      minWidth: 100,
                      height: 100,
                      child: const Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      elevation: 10,
                      onPressed: () =>
                          {Navigator.pop(context), _camera(), _cropImage()},
                    )),
                    const SizedBox(width: 10),
                    Flexible(
                        child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      minWidth: 100,
                      height: 100,
                      child: const Text(
                        'Album',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      elevation: 10,
                      onPressed: () => {Navigator.pop(context), _album()},
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _camera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }

    _cropImage();
  }

  _album() async {
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
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop your Image',
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

}