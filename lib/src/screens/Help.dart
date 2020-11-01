import 'package:flutter/material.dart';
import 'package:foodexpress/src/screens/RefundPolicy.dart';
import 'package:foodexpress/src/screens/Aboutus.dart';
import 'package:foodexpress/src/screens/Contact.dart';
import 'package:foodexpress/src/screens/GUpage.dart';
import 'package:foodexpress/src/screens/T&C.dart';
// ignore: unused_import
import 'package:foodexpress/src/screens/cartpage.dart';

import 'Privacy.dart';

//import 'package:foodexpress/src/screens/helpSupportPage.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() {
    return new _HelpPageState();
  }
}

class _HelpPageState extends State<HelpPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomPadding: true,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 10)
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.vpn_key),
                      title: Text(
                        'About Us',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: ButtonTheme(
                        padding: EdgeInsets.all(0),
                        minWidth: 50.0,
                        height: 25.0,
                        child: AboutusPage(
                          onChanged: () {},
                        ),
                      )),
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(6),
            //     boxShadow: [
            //       BoxShadow(
            //           color: Theme.of(context).hintColor.withOpacity(0.15),
            //           offset: Offset(0, 3),
            //           blurRadius: 10)
            //     ],
            //   ),
            //   child: ListView(
            //     shrinkWrap: true,
            //     primary: false,
            //     children: <Widget>[
            //       ListTile(
            //           leading: Icon(Icons.vpn_key),
            //           title: Text(
            //             'User Guide',
            //             style: Theme.of(context).textTheme.bodyText1,
            //           ),
            //           trailing: ButtonTheme(
            //             padding: EdgeInsets.all(0),
            //             minWidth: 50.0,
            //             height: 25.0,
            //             child: GUPage(
            //               onChanged: () {},
            //             ),
            //           )),
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 10)
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.vpn_key),
                      title: Text(
                        'Privacy Policy',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: ButtonTheme(
                        padding: EdgeInsets.all(0),
                        minWidth: 50.0,
                        height: 25.0,
                        child: PrivacyPage(
                          onChanged: () {},
                        ),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 10)
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.vpn_key),
                      title: Text(
                        'Terms & Condition (T&C)',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: ButtonTheme(
                        padding: EdgeInsets.all(0),
                        minWidth: 50.0,
                        height: 25.0,
                        child: TCPage(
                          onChanged: () {},
                        ),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 10)
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.text_format),
                      title: Text(
                        'Refund and Cancellation Policy',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: ButtonTheme(
                        padding: EdgeInsets.all(0),
                        minWidth: 50.0,
                        height: 25.0,
                        child: RefundPolicyPage(
                          onChanged: () {},
                        ),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 10)
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.text_format),
                      title: Text(
                        'Contact Us',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: ButtonTheme(
                        padding: EdgeInsets.all(0),
                        minWidth: 50.0,
                        height: 25.0,
                        child: ContactPage(
                          onChanged: () {},
                        ),
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 140,
                height: 30,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 15, top: 280, bottom: 10),
                child: Text(
                  'Mr. Echo '
                  'all right reserved',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
