import 'package:flutter/material.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/screens/loginPage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ShoppingCartFloatButtonWidget extends StatefulWidget {
  const ShoppingCartFloatButtonWidget({
    this.iconColor,
    this.labelColor,
    // this.routeArgument,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  // final RouteArgument routeArgument;

  @override
  _ShoppingCartFloatButtonWidgetState createState() =>
      _ShoppingCartFloatButtonWidgetState();
}

class _ShoppingCartFloatButtonWidgetState
    extends StateMVC<ShoppingCartFloatButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authenticated = Provider.of<AuthProvider>(context).status;
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        color: Colors.green,
        shape: StadiumBorder(),
        onPressed: () {
          Navigator.of(context).pop();
          if (authenticated == Status.Authenticated) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(title: 'My Cart', tabsIndex: 4)));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30,
            ),
            Container(
              child: Text( ScopedModel.of<CartModel>(context, rebuildOnChange: true).totalQunty.toString(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 12)),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              constraints: BoxConstraints(
                  minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
            ),
          ],
        ),
      ),
    );
//    return FlatButton(
//      onPressed: () {
//        print('to shopping cart');
//      },
//      child:
//      color: Colors.transparent,
//    );
  }
}
