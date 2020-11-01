import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
class LiquidSwipeScreen extends StatefulWidget {
  static String tag = '/LiquidSwipeScreen';

  @override
  LiquidSwipeScreenState createState() => LiquidSwipeScreenState();
}

class LiquidSwipeScreenState extends State<LiquidSwipeScreen> {

final pages = [
   Container(
     color: Colors.pink,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisSize: MainAxisSize.max,
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>[
         Image.asset(
           'food_ic_walk1.svg',
           fit: BoxFit.cover,
         ),
         Padding(padding: const EdgeInsets.all(20.0)),
         Column(
           children: <Widget>[
             new Text(
               "Hi",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
             new Text(
               "It's Me",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
             new Text(
               "Sahdeep",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
           ],
         )
       ],
     ),
   ),
   Container(
     color: Colors.deepPurpleAccent,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisSize: MainAxisSize.max,
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>[
         Image.asset(
           'assets/images/food_ic_walk2.svg',
           fit: BoxFit.cover,
         ),
         Padding(padding: const EdgeInsets.all(20.0)),
         Column(
           children: <Widget>[
             new Text(
               "Take a",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
             new Text(
               "look at",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
             new Text(
               "Liquid Swipe",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
           ],
         )
       ],
     ),
   ),
   Container(
     color: Colors.greenAccent,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisSize: MainAxisSize.max,
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>[
         Image.asset(
           'assets/images/food_ic_walk3.svg',
           fit: BoxFit.cover,
         ),
         Padding(padding: const EdgeInsets.all(20.0)),
         Column(
           children: <Widget>[
             new Text(
               "Liked?",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
             new Text(
               "Fork!",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
             new Text(
               "Give Star!",
               style: TextStyle(
                   fontSize: 30,
                   fontFamily: "Billy",
                   fontWeight: FontWeight.w600),
             ),
           ],
         )
       ],
     ),
   ),
 ];

  @override
 Widget build(BuildContext context) {
   return new MaterialApp(
       home: new Scaffold(
           body: LiquidSwipe(
             pages: pages,
            //  fullTransitionValue: 500,
            //  enableSlideIcon: true,
                   enableLoop: false,
                    waveType: WaveType.liquidReveal,

           )));
 }
}