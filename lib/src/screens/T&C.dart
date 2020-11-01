import 'package:flutter/material.dart';

class TCPage extends StatefulWidget {
  TCPage({Key key, Null Function() onChanged}) : super(key: key);

  @override
  _TCPageState createState() => _TCPageState();
}

class _TCPageState extends State<TCPage> {
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
                      'Terms & Conditions',
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
                                'The terms We, Us, Our, Company” individually and collectively refer to Mr. Echo and the terms Visitor, User refer to the users. ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'This page states the Terms and Conditions of use of Mr. Echo (APP) by the User / Visitor.'
                                ' Please read this page carefully. If you do not accept the Terms and Conditions stated here, we would request you to exit this site. The business, any of its business divisions and / or its subsidiaries, associate companies or subsidiaries to subsidiaries or such other investment companies (in India or abroad) reserve their respective rights to revise these Terms and Conditions at any time by updating this posting. You should visit this page periodically to re-appraise yourself of the Terms and Conditions, because they are binding on all users of this Website.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text('USE OF CONTENT'),
                              SizedBox(height: 2),
                              Text(
                                'All logos, brands, marks headings, labels, names, signatures, numerals, shapes or any combinations thereof, appearing in this site, except as otherwise noted, are properties either owned, or used under license, by the business and / or its associate entities who feature on this Website. The use of these properties or any other content on this site, except as provided in these terms and conditions or in the site content, is strictly prohibited.'
                                'You may not sell or modify the content of this Website  or reproduce, display, publicly perform, distribute, or otherwise use the materials in any way for any public or commercial purpose without the respective organization’s or entity’s written permission.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'ACCEPTABLE WEBSITE USE',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                '(A) Security Rules'
                                'Visitors are prohibited from violating or attempting to violate the security of the App, including, without limitation,'
                                '(1) Accessing data not intended for such user or logging into a server or account which the user is not authorized to access,'
                                '(2) Attempting to probe, scan or test the vulnerability of a system or network or to breach security or authentication measures without proper authorization, '
                                '(3) Attempting to interfere with service to any user, host or network, including, without limitation, via means of submitting a virus or Trojan horse to the Website, overloading, flooding, mail bombing or crashing, or'
                                '(4) Sending unsolicited electronic mail, including promotions and/or advertising of products or services. Violations of system or network security may result in civil or criminal liability. The business and / or its associate entities will have the right to investigate occurrences that they suspect as involving such violations and will have the right to involve, and cooperate with, law enforcement authorities in prosecuting users who are involved in such violations',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 5),
                              Text(
                                '(B) General Rules'
                                'Visitors may not use the App in order to transmit, distribute, store or destroy material '
                                '(a) That could constitute or encourage conduct that would be considered a criminal offence or violate any applicable law or regulation, '
                                '(b) In a manner that will infringe the copyright, trademark, trade secret or other intellectual property rights of others or violate the privacy or publicity of other personal rights of others, or '
                                '(c) that is libelous, defamatory, pornographic, profane, obscene, threatening, abusive or hateful.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'INDEMNITY',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'The User unilaterally agree to indemnify and hold harmless, without objection, the Company, its officers, directors, employees and agents from and against any claims, actions and/or demands and/or liabilities and/or losses and/or damages whatsoever arising from or resulting from their use of Mr. Echo or their breach of the terms . ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'LIABILITY',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'User agrees that neither Company nor its group companies, directors, officers or employee shall be liable for any direct or/and indirect or/and incidental or/and special or/and consequential or/and exemplary damages, resulting from the use or/and the inability to use the service or/and for cost of procurement of substitute goods or/and services or resulting from any goods or/and data or/and information or/and services purchased or/and obtained or/and messages received or/and transactions entered into through or/and from the service or/and resulting from unauthorized access to or/and alteration of users transmissions or/and data or/and arising from any other matter relating to the service, including but not limited to, damages for loss of profits or/and use or/and data or other intangible, even if Company has been advised of the possibility of such damages. '
                                'User further agrees that Company shall not be liable for any damages arising from interruption, suspension or termination of service, including but not limited to director/and indirect or/and incidental or/and special consequential or/and exemplary damages, whether such interruption or/and suspension or/and termination was justified or not, negligent or intentional, inadvertent or advertent. '
                                'User agrees that Company shall not be responsible or liable to user, or anyone, for the statements or conduct of any third party of the service. In sum, in no event shall Companys total liability to the User for all damages or/and losses or/and causes of action exceed the amount paid by the User to Company, if any, that is related to the cause of action.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'DISCLAIMER OF CONSEQUENTIAL DAMAGES',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'In no event shall Company or any parties, organizations or entities associated with the corporate brand name us or otherwise, mentioned at this Website be liable for any damages whatsoever (including, without limitations, incidental and consequential damages, lost profits, or damage to computer hardware or loss of data information or business interruption) resulting from the use or inability to use the Website and the Website material, whether based on warranty, contract, tort, or any other legal theory, and whether or not, such organization or entities were advised of the possibility of such damages.',
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
