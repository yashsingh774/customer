import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  PrivacyPage({Key key, Null Function() onChanged}) : super(key: key);
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
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
                      'Privacy Policy',
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
                                'The terms We, Us, Our, Company individually and collectively refer to Mr. Echo and the terms You, Your, yourself refer to the users. ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'This Privacy Policy is an electronic record in the form of an electronic contract formed under the information Technology Act, 2000 and the rules made there under and the amended provisions pertaining to electronic documents / records in various statutes as amended by the information Technology Act, 2000. This Privacy Policy does not require any physical, electronic or digital signature.'
                                'This Privacy Policy is a legally binding document between you and Mr. Echo. The terms of this Privacy Policy will be effective upon your acceptance of the same (directly or indirectly in electronic form, by clicking on the I accept tab or by use of the website or by other means) and will govern the relationship between you and Mr. Echo. For your use of the website “APP”.'
                                'This document is published and shall be construed in accordance with the provisions of the Information Technology (reasonable security practices and procedures and sensitive personal data of information) rules, 2011 under Information Technology Act, 2000; that require publishing of the Privacy Policy for collection, use, storage and transfer of sensitive personal data or information.'
                                'Please read this Privacy Policy carefully by using the Website, you indicate that you understand, agree and consent to this Privacy Policy. If you do not agree with the terms of this Privacy Policy, please do not use this Website. '
                                'By providing us your Information or by making use of the facilities provided by the Website, You hereby consent to the collection, storage, processing and transfer of any or all of Your Personal Information and Non-Personal Information by us as specified under this Privacy Policy. You further agree that such collection, use, storage and transfer of Your Information shall not cause any loss or wrongful gain to you or any other person.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text('USER INFORMATION '),
                              SizedBox(height: 2),
                              Text(
                                'To avail certain services on our Websites, users are required to provide certain information for the registration process namely: - '
                                'a) Your name, '
                                'b) Email address,'
                                'c) Sex, '
                                'd) Age,'
                                'e) PIN code,'
                                'f) Credit card or debit card details, '
                                'g) Order records and history,'
                                'h) password etc., and / or your occupation, interests, and the like.'
                                'The Information as supplied by the users enables us to improve our sites and provide you the most user-friendly experience.'
                                'All required information is service dependent and we may use the above said user information to, maintain, protect, and improve its services (including advertising services) and for developing new services'
                                'Such information will not be considered as sensitive if it is freely available and accessible in the public domain or is furnished under the Right to Information Act, 2005 or any other law for the time being in force.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'COOKIES',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'To improve the responsiveness of the sites for our users, we may use "cookies", or similar electronic tools to collect information to assign each visitor a unique, random number as a User Identification (User ID) to understand the users individual interests using the Identified Computer. Unless you voluntarily identify yourself (through registration, for example), we will have no way of knowing who you are, even if we assign a cookie to your computer. The only personal information a cookie can contain is information you supply (an example of this is when you ask for our Personalised Horoscope). A cookie cannot read data off your hard drive. Our advertisers may also assign their own cookies to your browser (if you click on their ads), a process that we do not control. '
                                'Our web servers automatically collect limited information about your computers connection to the Internet, including your IP address, when you visit our site. (Your IP address is a number that lets computers attached to the Internet know where to send you data -- such as the web pages you view.) Your IP address does not identify you personally. We use this information to deliver our web pages to you upon request, to tailor our site to the interests of our users, to measure traffic within our site and let advertisers know the geographic locations from where our visitors come. ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'LINKS TO THE OTHER SITES',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Our policy discloses the privacy practices for our own web site only. Our site provides links to other websites also that are beyond our control. We shall in no way be responsible in way for your use of such sites.5. ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'INFORMATION SHARING',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'We shares the sensitive personal information to any third party without obtaining the prior consent of the user in the following limited circumstances:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '(a) When it is requested or required by law or by any court or governmental agency or authority to disclose, for the purpose of verification of identity, or for the prevention, detection, investigation including cyber incidents, or for prosecution and punishment of offences. These disclosures are made in good faith and belief that such disclosure is reasonably necessary for enforcing these Terms; for complying with the applicable laws and regulations. ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '(b) We proposes to share such information within its group companies and officers and employees of such group companies for the purpose of processing personal information on its behalf. We also ensure that these recipients of such information agree to process such information based on our instructions and in compliance with this Privacy Policy and any other appropriate confidentiality and security measures.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'INFORMATION SECURITY',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'We take appropriate security measures to protect against unauthorized access to or unauthorized alteration, disclosure or destruction of data. These include internal reviews of our data collection, storage and processing practices and security measures, including appropriate encryption and physical security measures to guard against unauthorized access to systems where we store personal data.'
                                'All information gathered on our Website is securely stored within our controlled database. The database is stored on servers secured behind a firewall; access to the servers is password-protected and is strictly limited. However, as effective as our security measures are, no security system is impenetrable. We cannot guarantee the security of our database, nor can we guarantee that information you supply will not be intercepted while being transmitted to us over the Internet. And, of course, any information you include in a posting to the discussion areas is available to anyone with Internet access. '
                                'However the internet is an ever evolving medium. We may change our Privacy Policy from time to time to incorporate necessary future changes. Of course, our use of any information we gather will always be consistent with the policy under which the information was collected, regardless of what the new policy may be. ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Grievance Redressal',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Redressal Mechanism: Any complaints, abuse or concerns with regards to content and or comment or breach of these terms shall be immediately informed to  Mr. Echo. ',
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
                        child: Text('Cancel'),
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
