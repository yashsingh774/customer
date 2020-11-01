import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:foodexpress/src/screens/toast.dart';

class GoogleSignInScreen extends StatefulWidget {
  static String tag = '/GoogleSignInScreen';

  @override
  GoogleSignInScreenState createState() => GoogleSignInScreenState();
}

class GoogleSignInScreenState extends State<GoogleSignInScreen> {
  var isSuccess = false;
  var name = 'UserName';
  var email = 'Email id';
  var photoUrl = '';

  void onSignInTap() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
    ]);
    await googleSignIn.signIn().then((res) async {
      await res.authentication.then((accessToken) async {
        setState(() {
          isSuccess = true;
          name = res.displayName;
          email = res.email;
          photoUrl = res.photoUrl;
        });

        print('Access Token: ${accessToken.accessToken.toString()}');
      }).catchError((error) {
        isSuccess = false;
        toast(error.toString());
        setState(() {});
        throw (error.toString());
      });
    }).catchError((error) {
      isSuccess = false;
      toast(error.toString());
      setState(() {});
      throw (error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.deepOrange);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  padding: EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundImage: Image.network(photoUrl).image,
                    radius: 50,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      text(name, fontSize: 12, textColor: isSuccess ? Colors.red : Theme.of(context).secondaryHeaderColor),
                      text(email, fontSize: 12, textColor: isSuccess ? Colors.blue : Theme.of(context).secondaryHeaderColor),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
              onTap: () => onSignInTap(),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(24),
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.red,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        "images/integrations/icons/ic_google.png",
                        width: 30,
                        color: Colors.black,
                      ),
                      Center(child: text('Sign In with google', textColor: Colors.black, isCentered: true,  fontSize: 12)),
                    ],
                  )))
        ],
      ),
    );
  }
}

toast(String value,
    {ToastGravity gravity = ToastGravity.BOTTOM,
    length = Toast.LENGTH_SHORT,
    Color bgColor,
    Color textColor}) {
  Fluttertoast.showToast(
      msg: value,
      gravity: gravity,
      toastLength: length,
      backgroundColor: bgColor,
      textColor: textColor);
}
changeStatusColor(Color color, {bool isWhite = false}) async {
  /*try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(useWhiteForeground(color));
  } on Exception catch (e) {
    print(e);
  }*/
}

Widget text(
  var text, {
  var fontSize = 12,
  textColor = "",

  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.2,
  var isLongText = false,
  var isJustify = false,
}) {
  return Text(
    text,
    textAlign: isCentered
        ? TextAlign.center
        : isJustify ? TextAlign.justify : TextAlign.start,
    maxLines: isLongText ? 20 : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontSize: double.parse(fontSize.toString()).toDouble(),
        height: 1.5,
        color: textColor.toString().isNotEmpty ? textColor : null,
        letterSpacing: latterSpacing),
  );
}









