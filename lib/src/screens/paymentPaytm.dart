import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/src/utils/CustomTextStyle.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';

class PaymentPaytm extends StatefulWidget {
  String OrderID;
  String amount;
  String customerToken;
  PaymentPaytm({Key key,this.amount,this.OrderID, this.customerToken}) : super(key: key);
  @override
  _PaymentPaytmState createState() => _PaymentPaytmState();
}

class _PaymentPaytmState extends State<PaymentPaytm> {
  String payment_response = null;
  String currency;
    static String api =  FoodApi.baseApi;
  //Live
  // String mid = "MrECHO44772381378639";
  // String PAYTM_MERCHANT_KEY = "LXtNiLMmgrDHpK_k";

  String mid = "gjaJRh46023394480259";
  String PAYTM_MERCHANT_KEY = "eCb&j_Tmyg#cHH4Z";
  String website = "DEFAULT";
  bool testing = true;

  //Testing
  // String mid = "TEST_MID_HERE";
  // String PAYTM_MERCHANT_KEY = "TES_KEY_HERE";
  // String website = "WEBSTAGING";
  // bool testing = true;

  double amount = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Paytm example app'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //     'Test Credentials works only on Android. Also make sure Paytm APP is not installed (For Testing).'),

                // SizedBox(
                //   height: 10,
                // ),

                // TextField(
                //   onChanged: (value) {
                //     mid = value;
                //   },
                //   decoration: InputDecoration(hintText: "Enter MID here"),
                //   keyboardType: TextInputType.text,
                // ),
                // TextField(
                //   onChanged: (value) {
                //     PAYTM_MERCHANT_KEY = value;
                //   },
                //   decoration:
                //       InputDecoration(hintText: "Enter Merchant Key here"),
                //   keyboardType: TextInputType.text,
                // ),
                // TextField(
                //   onChanged: (value) {
                //     website = value;
                //   },
                //   decoration: InputDecoration(
                //       hintText: "Enter Website here (Probably DEFAULT)"),
                //   keyboardType: TextInputType.text,
                // ),
                // TextField(
                //   onChanged: (value) {
                //     try {
                //       amount = double.tryParse(value);
                //     } catch (e) {
                //       print(e);
                //     }
                //   },
                //   decoration: InputDecoration(hintText: "Enter Amount here"),
                //   keyboardType: TextInputType.number,
                // ),
                 Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.monetization_on,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Total Amount $currency ${widget.amount}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:CustomTextStyle.textFormFieldMedium.copyWith(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
                SizedBox(
                  height: 10,
                ),
                payment_response != null
                    ? Text('Response: $payment_response\n')
                    : Container(),
               loading
                   ? Center(
                       child: Container(
                           width: 50,
                           height: 50,
                           child: CircularProgressIndicator()),
                     )
                   : Container(),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(0);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using Wallet",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(1);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using Net Banking",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(2);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using UPI",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(3);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using Credit Card",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
  //  var url = 'https://desolate-anchorage-29312.herokuapp.comf/generateTxnToken';
          // String mid = "MrECHO44772381378639";
          // String PAYTM_MERCHANT_KEY = "LXtNiLMmgrDHpK_k";

//staging
          String mid = "gjaJRh46023394480259";
          String PAYTM_MERCHANT_KEY = "eCb&j_Tmyg#cHH4Z";
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
          final response = await http.get(url,headers: {HttpHeaders.authorizationHeader: 'Bearer ${widget.customerToken}'});
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
          mid, orderId, txnToken, amount.toString(), callBackUrl, testing);
      paytmResponse.then((value) {
      //  print(value);
        setState(() async {
          loading = false;
         payment_response = value.toString();
         if  (value['RESPMSG'] == 'Txn Success') {
           final url = "$api/orders/payment";
    Map<String, String> body = {
      'order_id': widget.OrderID,
      'amount': widget.amount,
      'payment_method': '20',
      'payment_transaction_id': value['TXNID'],
    };

    final responseBody = await http.post(url, body: body,headers: {HttpHeaders.authorizationHeader: 'Bearer ${widget.customerToken}'});
    if(responseBody.statusCode == 200){

      _showDialog("SUCCESSFUL", "assets/success_logo.png");

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => MyHomePage(title:'My Order',tabsIndex: 1,)));
    }
    else {
      _showDialog("UNSUCCESSFUL", "assets/unsuccess_logo.png");
    }
         }
        });
      });
    } catch (e) {
      print(e);
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
            height: 100.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  "$logo",
                  height: 50.0,
                  width: 50.0,
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
                    context, MaterialPageRoute(builder: (context) => MyHomePage(title:'My Order',tabsIndex: 3,)));
                },
            ),
          ],
        );
      },
    );
  }
}

