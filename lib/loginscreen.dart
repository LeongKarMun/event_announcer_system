import 'package:event_announcer_system/registrationscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'mainscreen.dart';
// import 'registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'mainpage.dart';

// import 'user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum SelectType { generalUser, eventOrganizer }

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  SelectType _type = SelectType.generalUser;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
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
                margin: EdgeInsets.fromLTRB(70, 0, 70, 10),
                child: Image.asset('assets/images/EAS.png')),
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('-Login-',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        )),
                    SizedBox(height: 5),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('General User'),
                          leading: Radio(
                            value: SelectType.generalUser,
                            groupValue: _type,
                            onChanged: (SelectType? value) {
                              setState(() {
                                _type = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Event Organizer'),
                          leading: Radio(
                            value: SelectType.eventOrganizer,
                            groupValue: _type,
                            onChanged: (SelectType? value) {
                              setState(() {
                                _type = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          labelText: 'Username', icon: Icon(Icons.account_box)),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password', icon: Icon(Icons.lock)),
                      obscureText: true,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              _onChange(value!);
                            }),
                        Text("Remember Me")
                      ],
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minWidth: 100,
                      height: 40,
                      child: Text('Login',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: _onLogin,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child:
                  Text("Resigter New Account", style: TextStyle(fontSize: 16)),
              onTap: _registerNewUser,
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text("Forgot Password", style: TextStyle(fontSize: 16)),
              onTap: _forgotPassword,
            )
          ],
        ))),
      ),
    );
  }

  void _onChange(bool value) {
    String _username = _usernameController.text.toString();
    String _password = _passwordController.text.toString();

    if (_username.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Username/Password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      _rememberMe = value;
      storePref(value, _username, _password);
    });
  }

  void _onLogin() {
    String _username = _usernameController.text.toString();
    String _password = _passwordController.text.toString();

    // http.post(
    //     Uri.parse(
    //         "http://javathree99.com/s269926/alloutgroceries/php/login_user.php"),
    //     body: {"email": _email, "password": _password}).then((response) {
    //   print(response.body);
    //   if (response.body == "failed") {
    //     Fluttertoast.showToast(
    //         msg: "Login Failed",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Color.fromRGBO(191, 30, 46, 50),
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //   } else {
    //     List userData = response.body.split(",");
    //     // User user = new User(
    //     //     user_email: _email,
    //     //     username: userData[1],
    //     //     phoneno: userData[2]);
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => MainPage()));
  // }
    // });
  }

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

  void _forgotPassword() {
    TextEditingController _useremailController = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text("Forgot Your Password ?", style: TextStyle(fontSize: 15)),
            content: new Container(
                height: 100,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text("Enter your recovery email: ",
                        style: TextStyle(fontSize: 13)),
                    TextField(
                      controller: _useremailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    )
                  ],
                ))),
            actions: [
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  print(_useremailController.text);
                  _resetPassword(_useremailController.text.toString());
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _resetPassword(String emailreset) {
    // http.post(
    //     Uri.parse(
    //         "http://javathree99.com/s269926/alloutgroceries/php/reset_user.php"),
    //     body: {"email": emailreset}).then((response) {
    //   print(response.body);
    //   if (response.body == "success") {
    //     Fluttertoast.showToast(
    //         msg: "Please check your email.",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Color.fromRGBO(191, 30, 46, 50),
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //   } else {
    //     Fluttertoast.showToast(
    //         msg: "Failed",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Color.fromRGBO(191, 30, 46, 50),
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //   }
    // });
  }

  Future<void> storePref(bool value, String username, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("username", username);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await prefs.setString("username", username);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _usernameController.text = "";
        _passwordController.text = "";
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _username = prefs.getString("username") ?? '';
    String _password = prefs.getString("password") ?? '';
    _rememberMe = prefs.getBool("remember") ?? false;

    setState(() {
      _usernameController.text = _username;
      _passwordController.text = _password;
    });
  }
}
