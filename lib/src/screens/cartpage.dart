import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/screens/CheckOutPage.dart';
import 'package:foodexpress/src/screens/EmptyCart.dart';
import 'package:foodexpress/src/screens/loginPage.dart';
import 'package:foodexpress/src/screens/toast.dart';
import 'package:foodexpress/src/utils/CustomTextStyle.dart';
import 'package:foodexpress/src/utils/CustomUtils.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  String api = FoodApi.baseApi;
  DateTime currentBackPressTime;
  initAuthProvider(context) async {
    Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
  }

  // ignore: missing_return
  Future<Void> deviceTokenUpdate(token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var deviceToken = storage.getString('deviceToken');
    final url = "$api/device?device_token=$deviceToken";
    // ignore: unused_local_variable
    final response = await http.put(url, headers: {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tap Again To Leave');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    initAuthProvider(context);
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AuthProvider>(context).currency;
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            bottomNavigationBar: bottombutton(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: Theme.of(context).hintColor,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Cart',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .merge(TextStyle(letterSpacing: 1.3)),
              ),
            ),
            body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                        .cart
                        .length ==
                    0
                ? EmptyCartWidget()
                : Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            'Shopping Cart',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            'Check The Quantity',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: ScopedModel.of<CartModel>(context,
                                  rebuildOnChange: true)
                              .total,
                          itemBuilder: (context, index) {
                            return ScopedModelDescendant<CartModel>(
                              builder: (context, child, model) {
                                return createCartListItem(
                                    currency, model, index);
                              },
                            );
                          },
                        ),
                      ),

                      // SizedBox(
                      //   // width: double.infinity,
                      //   child: bottombutton(),
                      //   // color: Colors.yellow[900],
                      //   // textColor: Colors.white,
                      //   // elevation: 0,
                      //   // child: Text("Ckeck Out"),
                      //   // onPressed: () async {
                      //   //   // ignore: unrelated_type_equality_checks
                      //   //   if (token != null) {
                      //   //     deviceTokenUpdate(token);
                      //   //     Navigator.push(
                      //   //         context,
                      //   //         new MaterialPageRoute(
                      //   //             builder: (context) => CheckOutPage()));
                      //   //   } else {
                      //   //     Navigator.push(
                      //   //         context,
                      //   //         new MaterialPageRoute(
                      //   //             builder: (context) => LoginPage()));
                      //   //   }
                      //   // },
                      // )
                    ]))));
  }

  createCartListItem(currency, model, index) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.15),
                    offset: Offset(-2, -2),
                    blurRadius: 5.0)
              ]),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.green.shade200,
                    image: DecorationImage(
                        image: NetworkImage(model.cart[index].imgUrl))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          model.cart[index].name,
                          maxLines: 2,
                          softWrap: true,
                          style: CustomTextStyle.textFormFieldSemiBold
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      Utils.getSizedBox(height: 6),
                      Text(
                        model.cart[index].qty.toString() +
                            " x " +
                            model.cart[index].price.toString(),
                        style: CustomTextStyle.textFormFieldRegular
                            .copyWith(color: Colors.grey, fontSize: 14),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "$currency" +
                                  (model.cart[index].qty *
                                          model.cart[index].price)
                                      .toString(),
                              style: CustomTextStyle.textFormFieldBlack
                                  .copyWith(color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      model.updateProduct(
                                          model.cart[index].id,
                                          model.cart[index].price,
                                          model.cart[index].qty - 1);
                                      // model.removeProduct(model.cart[index]);
                                    },
                                    iconSize: 30,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    icon: Icon(Icons.remove_circle_outline),
                                    color: Theme.of(context).hintColor,
                                  ),
                                  Text(
                                    (model.cart[index].qty).toString(),
                                    style: CustomTextStyle.textFormFieldBlack,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      model.updateProduct(
                                          model.cart[index].id,
                                          model.cart[index].price,
                                          model.cart[index].qty + 1);
                                      // model.removeProduct(model.cart[index]);
                                    },
                                    iconSize: 30,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    icon: Icon(Icons.add_circle_outline),
                                    color: Theme.of(context).hintColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 15, top: 10, bottom: 20),
            child: IconButton(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                model.removeProduct(model.cart[index].id);
                // model.removeProduct(model.cart[index]);
              },
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.green),
          ),
        )
      ],
    );
  }

  bottombutton({currency, model, index}) {
    final token = Provider.of<AuthProvider>(context).token;
    return ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                .cart
                .length ==
            0
        ? SizedBox(height: 0)
        : Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Subtotal',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(height: 15),
                      createPriceItem(
                        "Rs.",
                        ScopedModel.of<CartModel>(context,
                                    rebuildOnChange: true)
                                .totalCartValue
                                .toString() +
                            "",
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Delivery Fee',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      createPriceItem(
                        "Rs.",
                        '${ScopedModel.of<CartModel>(context, rebuildOnChange: true).deliveryCharge}',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                                    
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: () {
                           Navigator.of(context).pop(true); 
                          },

                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          // ignore: unrelated_type_equality_checks
                          color: Colors.lightBlue,
                          shape: StadiumBorder(),
                          child: Text(
                            'Want To Add More Items',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      ),
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: () {
                            if (token != null) {
                              deviceTokenUpdate(token);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => CheckOutPage()));
                            } else {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            }
                          },

                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          // ignore: unrelated_type_equality_checks
                          color: Colors.green,
                          shape: StadiumBorder(),
                          child: Text(
                            'Checkout',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            "Rs" +
                                '${ScopedModel.of<CartModel>(context, rebuildOnChange: true).totalCartValue + ScopedModel.of<CartModel>(context, rebuildOnChange: true).deliveryCharge}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .merge(TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }

  createPriceItem(String currency, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Text(
          //   key,
          //   style: CustomTextStyle.textFormFieldMedium
          //       .copyWith(color: Colors.grey.shade700, fontSize: 12),
          // ),
          Text(
            '$currency' + value,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: Colors.black, fontSize: 15),
          )
        ],
      ),
    );
  }
}
