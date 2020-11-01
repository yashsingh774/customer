import 'package:flutter/material.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:provider/provider.dart';
import 'loginPage.dart';
import 'package:foodexpress/src/utils/validate.dart';
import 'package:foodexpress/src/Widget/notification_text.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: SignUpPage(),
          ),
        ),
      ),
    ));
  }
}

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // ignore: unused_element
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name;
  String email;
  String phone;
  String password;
  String passwordConfirm;
  String message = '';
  String address;
  Map response = new Map();

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      response = await Provider.of<AuthProvider>(context, listen: false)
          .register(name, email, phone, password, passwordConfirm, address);
      if (response['success']) {
        message = response['message'];
        _showAlert(context, true);
      } else {
        message = response['message'];
        _showAlert(context, false);
      }
    }
  }

  Future<void> _showAlert(BuildContext context, bool) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Signup'),
          content: Consumer<AuthProvider>(
            builder: (context, provider, child) =>
                provider.notification ??
                NotificationText('Registration Not successful.'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                if (bool) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _sitename = Provider.of<AuthProvider>(context).sitename;
    // ignore: unused_element
    void _showToast(BuildContext context) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Added to cart'),
          action: SnackBarAction(
              label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.white, Colors.lightGreenAccent]),
            ),
            child: Stack(children: <Widget>[
              Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 60, left: 10),
                              child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(
                                    'Signup',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30.0, left: 75.0),
                              child: Container(
                                //color: Colors.green,
                                height: 200,
                                width: 200,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 60,
                                    ),
                                    Center(
                                      child: Text(
                                        _sitename != null ? _sitename : '',
                                        style: TextStyle(
                                          fontSize: 55,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 50, right: 50),
                            child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.lightBlueAccent,
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (value) {
                                      name = value.trim();
                                      return Validate.requiredField(
                                          value, 'Name is required.');
                                    }))),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 50, right: 50),
                            child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.lightBlueAccent,
                                      labelText: 'Phone',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      phone = value.trim();
                                      return Validate.requiredField(
                                          value, 'Phone is required.');
                                    }))),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 50, right: 50),
                            child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.lightBlueAccent,
                                      labelText: 'E-mail',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (value) {
                                      email = value.trim();
                                      return Validate.requiredField(
                                          value, 'Email is required.');
                                    }))),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 50, right: 50),
                            child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.lightBlueAccent,
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (value) {
                                      password = value.trim();
                                      return Validate.requiredField(
                                          value, 'Password is required.');
                                    }))),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 50, right: 50),
                            child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.lightBlueAccent,
                                      labelText: 'Password Confirm',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (value) {
                                      passwordConfirm = value.trim();
                                      return Validate.requiredField(value,
                                          'Password confirm is required.');
                                    }))),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 50, right: 50),
                            child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.lightBlueAccent,
                                      labelText: 'Address',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    validator: (value) {
                                      address = value.trim();
                                      return Validate.requiredField(
                                          value, 'Address is required.');
                                    }))),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, right: 50, left: 200),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green[300],
                                    blurRadius:
                                        10.0, // has the effect of softening the shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: FlatButton(
                              onPressed: () {
                                submit();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25, left: 30),
                          child: Container(
                            alignment: Alignment.topRight,
                            //color: Colors.red,
                            height: 20,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Have we met before?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    'Sing In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ])));
  }
}
