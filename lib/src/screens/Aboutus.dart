import 'package:flutter/material.dart';

class AboutusPage extends StatefulWidget {
  AboutusPage({Key key, Null Function() onChanged}) : super(key: key);

  @override
  _AboutusPageState createState() => _AboutusPageState();
}

class _AboutusPageState extends State<AboutusPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      'About Us',
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
                              Text(
                                'To stay safe and to stay healthy is and should be the utmost priority to all!' 
                                'Whether because of the pandemic or without it, we all strive for convenience and ease in our daily chores. So here we have for you a one-stop-shop for all your needs exclusively for your campus!'
                                'From food to groceries we have all your needs covered.'
                                'Safe & hygienic - this delivery system strictly follows all the norms and guidelines laid by the Central Government & thus provides you the best of service & quality, helping you run errands & saving your time. ',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                        )),
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              );
            });
      },
      child: Text(
        'View',
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
