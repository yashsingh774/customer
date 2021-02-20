import 'dart:async';

import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  double height;
  String subtitleText;

  LoadingWidget({Key key, this.height, this.subtitleText}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
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
    return Container(
      child: SizedBox(
        height: animation.value,
        child: new Container(
          alignment: AlignmentDirectional.center,
          decoration: new BoxDecoration(
            color: Colors.white70,
          ),
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.grey[200],
                borderRadius: new BorderRadius.circular(10.0)),
            width: 200.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                    child: Container(
                  width: 100.0,
                  height: 100.0,
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    top: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/icon.png'),
                    ),
                  ),
                )),
                new Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: new Center(
                    child: new Text(
                      "Loading Please wait...",
                      style: new TextStyle(color: Colors.black),
                    ),
                  ),
                ),
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
