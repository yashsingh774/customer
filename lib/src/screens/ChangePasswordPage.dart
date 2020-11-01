import 'package:flutter/material.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/Widget/notification_text.dart';
import 'package:foodexpress/src/Widget/styled_flat_button.dart';
import 'package:foodexpress/src/utils/validate.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key, Null Function() onChanged}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  String password_current;
  String password;
  String passwordConfirm;
  String message = '';
  Map response = new Map();

  Future<void> submit() async {
    final form = _formKey.currentState;
    print(form.validate());
    if (form.validate()) {
      response = await Provider.of<AuthProvider>(context, listen: false)
          .ChangePassword(password_current, password, passwordConfirm);
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
          title: Text('Change Password'),
          content: Consumer<AuthProvider>(
            builder: (context, provider, child) =>
                provider.notification ??
                NotificationText('Password change  Not successful.'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                if (bool) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: 'Profile',
                                tabsIndex: 3,
                              )));
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
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                backgroundColor: Colors.white,
                titlePadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _formKey,
                          child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(    
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            obscureText: true,
                            decoration: getInputDecoration(
                                hintText: 'Current', labelText: 'Current'),
                            validator: (value) {
                              password_current = value.trim();
                              return Validate.requiredField(
                                  value, 'Current Password is required.');
                            }),
                        TextFormField(
                            obscureText: true,
                            decoration: getInputDecoration(
                                hintText: 'Password', labelText: 'Password'),
                            validator: (value) {
                              password = value.trim();
                              return Validate.requiredField(
                                  value, 'Password is required.');
                            }),
                        TextFormField(
                            obscureText: true,
                            decoration: getInputDecoration(
                                hintText: 'Password confirm',
                                labelText: 'Password'),
                            validator: (value) {
                              passwordConfirm = value.trim();
                              return Validate.requiredField(
                                  value, 'Password confirm is required.');
                            }),
                      ],
                    ),
        )
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      MaterialButton(
                        onPressed: submit,
                        child: Text(
                          'Save',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              );
            });
      },
      child: Text(
        'Change',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }
}
