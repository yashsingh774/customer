import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:foodexpress/src/screens/loginPage.dart';
import 'package:foodexpress/src/utils/CustomTextStyle.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';
import 'dart:io' show Platform;

import 'package:scoped_model/scoped_model.dart';

class PaymentPaytm extends StatefulWidget {
  String OrderID;
  String amount;
  String customerToken;
  PaymentPaytm({Key key, this.amount, this.OrderID, this.customerToken})
      : super(key: key);
  @override
  _PaymentPaytmState createState() => _PaymentPaytmState();
}

class _PaymentPaytmState extends State<PaymentPaytm> {
  String payment_response = null;
  String currency;
  static String api = FoodApi.baseApi;

  // String mid = "gjaJRh46023394480259";
  // String PAYTM_MERCHANT_KEY = "eCb&j_Tmyg#cHH4Z";
  String mid = "MrECHO44772381378639";
  String PAYTM_MERCHANT_KEY = "LXtNiLMmgrDHpK_k";
  String website = "DEFAULT";
  bool testing = false;

  double amount ;
  bool loading = false;

  String os = Platform.operatingSystem; //in your code
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content:
                  const Text('If you Dont Complete Payment, Your Order will be Deleted'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                        .clearCart();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyHomePage(tabsIndex: 0),
                    ));
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
      debugShowCheckedModeBanner: false;
      return WillPopScope(
        onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
        //  title: Text(platform == TargetPlatform.iOS ? 'iOS' : 'Android'),
          backgroundColor: Colors.green,
          title: const Text('Payment Page'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    // leading: Icon(
                    //   Icons.monetization_on,
                    //   color: Theme.of(context).hintColor,
                    // ),
                    title: Text(
                      'Total Amount ${widget.amount}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle.textFormFieldMedium.copyWith(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: new ExactAssetImage('assets/images/paymentlogo.jpg'),
                          fit: BoxFit.contain,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                payment_response != null ? Text('\n') : Container(),
                loading
                    ? Center(
                        child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()),
                      )
                    : Container(),
                RaisedButton(
                    onPressed: () {
                      //Firstly Generate CheckSum bcoz Paytm Require this
                      generateTxnToken(0);
                    },
                    color: Color(0xFFF17532),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: Container(
                          width: MediaQuery.of(context).size.width - 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0)),
                          //   color: Color(0xFFF17532)),
                          child: Center(
                              child: Text('Payment',
                                  style: TextStyle(
                                      fontFamily: 'nunito',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)))),
                    ))
              ],
            ),
          ),
        ),
      ),
      );
  }

  void generateTxnToken(int mode) async {
    setState(() {
      loading = true;
    });
    String orderId = this.widget.OrderID.toString();

    String callBackUrl = (testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    //callBackUrl = 'https://mrecho.in/paytm/callback';
    String mid = "MrECHO44772381378639";
    String PAYTM_MERCHANT_KEY = "LXtNiLMmgrDHpK_k";
    // String mid = "gjaJRh46023394480259";
    // String PAYTM_MERCHANT_KEY = "eCb&j_Tmyg#cHH4Z";
    String website = "DEFAULT";
    final url = "$api/orders/$orderId/get-txn-token";
    var body = json.encode({
      "mid": mid,
      "key_secret": PAYTM_MERCHANT_KEY,
      "website": website,
      "orderId": orderId,
      "amount": amount.toString(),
      "callbackUrl": callBackUrl,
      "custId": "1",
      "mode": mode.toString(),
      "testing": testing ? 0 : 1
    });
    try {
      //var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer ${widget.customerToken}'});
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.customerToken}'
      });
      // final response = await http.get(
      //   url,
      //   headers: {'Content-type': "application/json"},
      // );

      // print("Response is");
      // print(response.body);
      var resBody = json.decode(response.body);
      var txnToken = resBody['body']['txnToken'];
      setState(() {
        payment_response = resBody['body']['txnToken'];
      });
      var paytmResponse = Paytm.payWithPaytm(
          mid, orderId, txnToken, widget.amount, callBackUrl, testing);

      paytmResponse.then((value) {
        print(value);
        setState(() async {
          loading = false;
          payment_response = value.toString();
          if (value['RESPMSG'] == 'Txn Success') {
            final url = "$api/orders/payment";
            Map<String, String> body = {
              'order_id': widget.OrderID,
              'amount': widget.amount,
              'payment_method': '20',
              'payment_transaction_id': value['TXNID'],
            };

            final responseBody = await http.post(url, body: body, headers: {
              HttpHeaders.authorizationHeader: 'Bearer ${widget.customerToken}'
            });
            if (responseBody.statusCode == 200) {
              _showDialog("SUCCESSFUL", "assets/success_logo.png");

              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => MyHomePage(title:'My Order',tabsIndex: 1,)));
            }
            // else if (value['response']['STATUS'] == 'TXN_SUCCESS') {

            // }
            else {
              _showDialog("UNSUCCESSFUL", "assets/unsuccess_logo.png");
            }
          } else if (value['response']['STATUS'] == 'TXN_SUCCESS') {
            final url = "$api/orders/payment";
            Map<String, String> body = {
              'order_id': widget.OrderID,
              'amount': widget.amount,
              'payment_method': '20',
              'payment_transaction_id': value['response']['TXNID'],
            };

            final responseBody = await http.post(url, body: body, headers: {
              HttpHeaders.authorizationHeader: 'Bearer ${widget.customerToken}'
            });
            if (responseBody.statusCode == 200) {
//              _showDialog("SUCCESSFUL", "assets/success_logo.png");
              _showDialog("Check Your Order", "assets/icons/ic_thank_you.png");
              // Navigator.push(;
              //     context, MaterialPageRoute(builder: (context) => MyHomePage(title:'My Order',tabsIndex: 1,)));
            }
            // else if (value['response']['STATUS'] == 'TXN_SUCCESS') {

            // }
          } else if (value['error'] == false) {
            final url = "$api/orders/payment";
            Map<String, String> body = {
              'order_id': widget.OrderID,
              'amount': widget.amount,
              'payment_method': '20',
              'payment_transaction_id': value['TXNID'],
            };
            _showDialog("Check Your Order", "assets/icons/ic_thank_you.png");
          } else {
            _showDialog("UNSUCCESSFUL", "assets/unsuccess_logo.png");
          }
        });
      });
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: 'My Order',
                    tabsIndex: 3,
                  )));
    }
  }

  void _showDialog(String message, String logo) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child: new Text("Payment Status")),
          content: new Container(
            height: 300.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  "$logo",
                  width: 300.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new Text(
                    "$message",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("My order"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: 'My Order',
                              tabsIndex: 3,
                            )));
              },
            ),
          ],
        );
      },
    );
  }
}
