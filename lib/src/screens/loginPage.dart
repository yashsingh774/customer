import 'package:flutter/material.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/screens/CheckOutPage.dart';
import 'package:foodexpress/src/screens/otpPage.dart';

import 'package:foodexpress/src/screens/signupPage.dart';
import 'package:foodexpress/src/utils/validate.dart';
import 'package:foodexpress/src/Widget/notification_text.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        leading: Container(),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: LoginPage(),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  String email;
  String password;
  String message = '';

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      var result = await Provider.of<AuthProvider>(context, listen: false)
          .login(email, password);
      print(result);
      if (result) {
//          Navigator.pop(context);
        var cartData = ScopedModel.of<CartModel>(context, rebuildOnChange: true)
            .totalQunty;
        if (cartData != 0) {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => CheckOutPage()));
        } else {
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => MyHomePage()));
        }
      } else {
        _showAlert(context);
      }
    }
  }

  Future<void> _showAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Login'),
          content: Consumer<AuthProvider>(
            builder: (context, provider, child) =>
                provider.notification ?? NotificationText(''),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
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
                  child: ListView(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 60, left: 10),
                            child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                  ),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, left: 50.0),
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
                                        fontSize: 45,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 50, left: 50, right: 50),
                            child: Container(
                                height: 70,
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
                                top: 20, left: 50, right: 50),
                            child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.lightGreenAccent,
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
                              top: 40, right: 50, left: 200),
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: FlatButton(
                              onPressed: () {
                                submit();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Login',
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
                          padding: const EdgeInsets.only(top: 30, left: 30),
                          child: Container(
                            alignment: Alignment.topRight,
                            //color: Colors.red,
                            height: 20,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Your first time?',
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
                                            builder: (context) =>
                                                SignUpPage()));
                                  },
                                  child: Text(
                                    'Sign up',
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 30),
                          child: Container(
                            alignment: Alignment.topRight,
                            //color: Colors.red,
                            height: 20,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Forgot Password?',
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
                                            builder: (context) => OtpIn()));
                                  },
                                  child: Text(
                                    'Click Here',
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
                  ]))
            ])));  }
}
