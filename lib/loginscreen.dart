import 'package:event_announcer_system/adminmainpage.dart';
import 'package:event_announcer_system/eventmainpage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainpage.dart';
import 'registrationscreen.dart';
import 'package:http/http.dart' as http;

import 'package:event_announcer_system/user.dart';

class LoginScreen extends StatefulWidget {
  
  
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectType;
  List<String> items = ['General User', 'Event Organizer', 'Admin'];
  late SharedPreferences prefs;

  @override
  void initState() {
    loadPref();
    super.initState();
  }

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
                      const Text('Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          )),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email)),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: 'Password', icon: Icon(Icons.lock)),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            DropdownButton(
                              hint: Text(
                                'Select Type',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              value: selectType,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 10,
                              underline:
                                  Container(height: 2, color: Colors.grey),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectType = newValue!;
                                });
                              },
                              //  isExpanded: true,
                            ),
                          ])),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                              value: _rememberMe,
                              onChanged: (bool? value) {
                                _onChange(value!);
                              }),
                          const Text("Remember Me")
                        ],
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minWidth: 100,
                        height: 40,
                        child: const Text('Login',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: _onLogin,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )),
            GestureDetector(
              child: const Text("Resigter New Account",
                  style: TextStyle(fontSize: 16)),
              onTap: _registerNewUser,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: const Text("Forgot Password",
                  style: TextStyle(fontSize: 16)),
              onTap: _forgotPassword,
            )
          ],
        ))),
      ),
    );
  }

  void _onChange(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
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
    setState(() {
      _rememberMe = value;
      storePref(value, _email, _password);
    });
  }

  void _onLogin() {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    String? type;

    setState(() {
      if (selectType == 'General User') {
        type = 'General User';
        print(type);
      } else if (selectType == 'Event Organizer') {
        type = 'Event Organizer';
        print(type);
      } else {
        type = 'Admin';
      }
    });

    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/login_user.php"),
        body: {
          "email": _email,
          "password": _password,
           "type": type,
        }).then((response) {
          print(response.body);
          if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        List userData = response.body.split(",");
        User user = User(
            user_email: _email,
            // username: userData[1],
            // phoneno: userData[2]
            );
       if ( type == 'General User') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) =>  MainPage(user: user)));
      } else if (type == 'Event Organizer') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => EventMainPage(user: user)));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => AdminMainPage(user: user)));
      }
      // print(response.body);
      }
    });
  }

  void _registerNewUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _forgotPassword() {
    TextEditingController _useremailController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Forgot Your Password ?",
                style: TextStyle(fontSize: 15)),
            content: Container(
                height: 100,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const Text("Enter your recovery email: ",
                        style: TextStyle(fontSize: 13)),
                    TextField(
                      controller: _useremailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    )
                  ],
                ))),
            actions: [
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  print(_useremailController.text);
                  _resetPassword(_useremailController.text.toString());
                  Navigator.of(context).pop();
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

  void _resetPassword(String emailreset) {
    http.post(
        Uri.parse(
            "http://hubbuddies.com/s269926/event_announce_system/php/reset_user.php"),
        body: {"email": emailreset}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Please check your email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<void> storePref(bool value, String email, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    String? selectType = prefs.getString("type") ?? '';
    _rememberMe = prefs.getBool("remember") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }
}
