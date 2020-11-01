import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/Widget/notification_text.dart';
import 'package:foodexpress/src/Widget/styled_flat_button.dart';
import 'package:foodexpress/src/utils/validate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final userdata;

  EditProfilePage({Key key, @required this.userdata, Null Function() onChanged})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String email;
  String phone;
  String address;
  String username;
  File _image;
  String base64Image;
  String fileName;
  String message = '';
  Map response = new Map();

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      response = await Provider.of<AuthProvider>(context, listen: false)
          .ProfileUpdate(
              name, email, phone, username, address, fileName, base64Image);
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
          title: Text('User Profile '),
          content: Consumer<AuthProvider>(
            builder: (context, provider, child) =>
                provider.notification ??
                NotificationText('Profile Updated Not successful.'),
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
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        base64Image = base64Encode(_image.readAsBytesSync());
        fileName = _image.path.split("/").last;
      });
    }

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
                      'profile_settings',
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
                        Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xff476cfb),
                                    child: ClipOval(
                                      child: new SizedBox(
                                        width: 140.0,
                                        height: 140.0,
                                        child: (_image != null)
                                            ? Image.file(
                                                _image,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                widget.userdata['image'],
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 50.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.camera,
                                      size: 30.0,
                                    ),
                                    onPressed: () {
                                      getImage();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextFormField(
                            obscureText: false,
                            initialValue: widget.userdata['name'],
                            decoration: getInputDecoration(
                                hintText: 'Name', labelText: 'Name'),
                            validator: (value) {
                              name = value.trim();
                              return Validate.requiredField(
                                  value, 'Name is required.');
                            }),
                        TextFormField(
                            obscureText: false,
                            initialValue: widget.userdata['username'],
                            decoration: getInputDecoration(
                                hintText: 'Username', labelText: 'Username'),
                            validator: (value) {
                              username = value.trim();
                              return Validate.requiredField(
                                  value, 'username is required.');
                            }),
                        TextFormField(
                            obscureText: false,
                            initialValue: widget.userdata['email'],
                            decoration: getInputDecoration(
                                hintText: 'Email', labelText: 'Email'),
                            validator: (value) {
                              email = value.trim();
                              return Validate.requiredField(
                                  value, 'Email is required.');
                            }),
                        TextFormField(
                            initialValue: widget.userdata['phone'],
                            obscureText: false,
                            decoration: getInputDecoration(
                                hintText: 'Phone', labelText: 'Phone'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              phone = value.trim();
                              return Validate.requiredField(
                                  value, 'Phone is required.');
                            }),
                        TextFormField(
                            obscureText: false,
                            initialValue: widget.userdata['address'] != null
                                ? widget.userdata['address']
                                : '',
                            decoration: getInputDecoration(
                                hintText: 'Address', labelText: 'Address'),
                            onSaved: (value) {
                              print(value);
                            },
                            validator: (value) {
                              address = value.trim();
                              return Validate.NorequiredField();
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
        'Edit',
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
