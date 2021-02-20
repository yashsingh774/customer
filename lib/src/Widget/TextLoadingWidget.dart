import 'dart:async';

import 'package:flutter/material.dart';

class TextLoadingWidget extends StatefulWidget {
  double height;
  String subtitleText;

  TextLoadingWidget({Key key, this.height, this.subtitleText})
      : super(key: key);

  @override
  _TextLoadingWidgetState createState() => _TextLoadingWidgetState();
}

class _TextLoadingWidgetState extends State<TextLoadingWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  bool loding = false;
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween<double>(begin: widget.height, end: 0).animate(curve)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    Timer(Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          loding = true;
        });
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    loding = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: SizedBox(
        height: animation.value,
        child: new Container(
          alignment: AlignmentDirectional.center,
          decoration: new BoxDecoration(
            color: Colors.white70,
          ),
          child: new Flexible(
            // decoration: new BoxDecoration(
            //     color: Colors.grey[200],
            //     borderRadius: new BorderRadius.circular(10.0)),
            // width: 200.0,
            // height: 200.0,
            // alignment: AlignmentDirectional.center,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'No Shop found ',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Currently working on this Shop Category',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                // new Container(
                //   margin: const EdgeInsets.only(top: 15.0),
                //   child: new Center(
                //     child: new Text(
                //       "Loading Please wait...",
                //       style: new TextStyle(color: Colors.black),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        //         new Center(
        //     child: Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(5)),
        //     image: DecorationImage(
        //       fit: BoxFit.cover,

        //       image: AssetImage('assets/mr echo.png'),
        //     ),
        //   ),
        // )),
      ),
    );
  }
}
