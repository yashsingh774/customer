import 'package:flutter/material.dart';

class RefundPolicyPage extends StatefulWidget {
  RefundPolicyPage({Key key, Null Function() onChanged}) : super(key: key);

  @override
  _RefundPolicyPageState createState() => _RefundPolicyPageState();
}

class _RefundPolicyPageState extends State<RefundPolicyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                backgroundColor: Colors.white,
                titlePadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      'Refund and Cancellation Policy',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Container(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Our focus is complete customer satisfaction. In the event, if you are displeased with the services provided, we will refund back the money, provided the reasons are genuine and proved after investigation. Please read the fine prints of each deal before buying it, it provides all the details about the services or the product you purchase.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'In case of dissatisfaction from our services, clients have the liberty to cancel their projects and request a refund from us. Our Policy for the cancellation and refund will be as follows:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(' Cancellation Policy'),
                              SizedBox(height: 2),
                              Text(
                                'For Cancellations please note that you can cancel your order till it is in process after that it will not be cancelled '
                                'Requests received later than 4 to 5 business days prior to the end of the current service period will be treated as cancellation of services for the next service period.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Refund Policy',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'we will try our best to create the suitable design concepts for our clients.'
                                'In case any client is not completely satisfied with our products we can provide a refund. '
                                'If paid by credit card, refunds will be issued to the original credit card provided at the time of purchase and in case of payment gateway name payments refund will be made to the same account.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              );
            });
      },
      child: Text(
        'View',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }
}
