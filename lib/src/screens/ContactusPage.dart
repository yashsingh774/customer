import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ContactusPage());
}

class ContactusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // bottomNavigationBar: ContactUsBottomAppBar(
        //   companyName: '',
        //   textColor: Colors.black,
        //   backgroundColor: Colors.white,
        //   email: '',
        // ),
        backgroundColor: Colors.white,
        body: ContactUs(
          cardColor: Colors.white,
          textColor: Colors.black,
          logo: AssetImage('assets/images/download.png'),
          email: 'ABC@gmail.com',
          companyName: 'Mr. Echo',
          companyColor: Colors.black,
          phoneNumber: '0123456789',
          website: 'http://www.google.com',
          linkedinURL: '',
          tagLine: '',
          taglineColor: Colors.teal.shade100,
          twitterHandle: '',
          instagram: '',
        ),
      ),
    );
  }
}
