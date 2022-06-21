import 'package:event_announcer_system/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'loginscreen.dart';

class RegistrationScreen extends StatefulWidget {
  
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordControllerA = TextEditingController();
  final TextEditingController _passwordControllerB = TextEditingController();
  bool _obscureText = true;
  bool _isChecked = false;
  int? userType = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Announcer System',
      home: Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(70, 0, 70, 10),
                child: Image.asset('assets/images/EAS.png', scale: 0.5)),
            const SizedBox(height: 5),
            Card(
              margin: const EdgeInsets.fromLTRB(30, 5, 30, 15),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  children: [
                    const Text('Registration',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        )),
                    const SizedBox(height: 5),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('General User'),
                          leading: Radio(
                            value: 1,
                            groupValue: userType,
                            onChanged: (value) {
                              setState(() {
                                userType = value as int?;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Event Organizer'),
                          leading: Radio(
                            value: 2,
                            groupValue: userType,
                            onChanged: (value) {
                              setState(() {
                                userType = value as int?;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    ),
                    TextField(
                      controller: _passwordControllerA,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: const Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: _togglePass,
                          child: const Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                    TextField(
                      controller: _passwordControllerB,
                      decoration: InputDecoration(
                        labelText: 'Enter Password Again',
                        icon: const Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: _togglePass,
                          child: const Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              _onChange(value!);
                            },
                          ),
                          GestureDetector(
                            onTap: _showEULA,
                            child: const Text('I Agree to Terms  ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ]),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minWidth: 100,
                        height: 40,
                        child: const Text('Register',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: _onRegister,
                        color: Colors.blue),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: const Text("Already Register?",
                  style: TextStyle(fontSize: 16)),
              onTap: _alreadyRegister,
            ),
            const SizedBox(height: 5),
          ],
        ))),
      ),
    );
  }

  void _onChange(bool value) {
    print(value);
    setState(() {
      _isChecked = value;
    });
  }

  void _alreadyRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _onRegister() {
    String _email = _emailController.text.toString();
    String _passwordA = _passwordControllerA.text.toString();
    String _passwordB = _passwordControllerB.text.toString();
    String? type;

    if (_email.isEmpty || _passwordA.isEmpty || _passwordB.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/Password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!validateEmail(_email)) {
      Fluttertoast.showToast(
          msg: "Check your email format",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (_passwordA != _passwordB) {
      Fluttertoast.showToast(
          msg: "Please use the same password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (_passwordA.length < 5) {
      Fluttertoast.showToast(
          msg: "Password should atleast 5 characters long ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!validatePassword(_passwordA)) {
      Fluttertoast.showToast(
          msg:
              "Password should contain atleast contain capital letter, small letter and number ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept terms",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      if (userType == 1) {
        type = 'General User';
        print(type);
      } else if (userType == 2) {
        type = 'Event Organizer';
        print(type);
      } else {
        type = 'Admin';
      }
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Register new user"),
            content: const Text("Are you sure?"),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // _registerUser(_email, _passwordA, userType);
                  http.post(
                      Uri.parse(
                          "http://hubbuddies.com/s269926/event_announce_system/php/register_user.php"),
                      body: {
                        "_email": _email,
                        "_passwordA": _passwordA,
                        "type": type
                      }).then((response) {
                    print(response.body);
                    if (response.body == "register_success") {
                      Fluttertoast.showToast(
                          msg:
                              "Register as general user success. Please refer your email to verify the new account.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor:
                              const Color.fromRGBO(191, 30, 46, 50),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (response.body == "request_success") {
                      Fluttertoast.showToast(
                          msg:
                              "Register as event organizer success. Please wait admin to approve around 1-2 days and check your email to verify the new account.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor:
                              const Color.fromRGBO(191, 30, 46, 50),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (response.body == "duplicate") {
                      Fluttertoast.showToast(
                          msg:
                              "The email is already registered !!!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor:
                              const Color.fromRGBO(191, 30, 46, 50),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Registration/Request Failed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor:
                              const Color.fromRGBO(191, 30, 46, 50),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => const LoginScreen()));
                  });
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

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("EULA"),
          content: Container(
            height: 180,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and Javathree99. This EULA agreement governs your acquisition and use of our ALL-OUT GROCERICES software (Software) directly from Javathree99 or indirectly through a Javathree99 authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the ALL-OUT GROCERIES software. It provides a license to use the ALL-OUT GROCERIES software and contains warranty information and liability disclaimers. If you register for a free trial of the ALL-OUT GROCERIES software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the ALL-OUT GROCERIES software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Javathree99 herewith regardless of whether other software is referred to or described herein. The terms also apply to any Javathree99 updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for ALL-OUT GROCERIES. Javathree99 shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Javathree99. Javathree99 reserves the right to grant licences to use the Software to third parties")),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$';
    RegExp regExp = RegExp(pattern);
    print(regExp.hasMatch(value));
    return regExp.hasMatch(value);
  }

  String titleCase(str) {
    var retStr = "";
    List userdata = str.toLowerCase().split(' ');
    print(userdata[0].toString());
    for (int i = 0; i < userdata.length; i++) {
      retStr += userdata[i].charAt(0).toUpperCase + " ";
    }
    print(retStr);
    return retStr;
  }

  void _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
