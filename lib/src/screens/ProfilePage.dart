import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/main.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/Widget/CircularLoadingWidget.dart';
import 'package:foodexpress/src/screens/ChangePasswordPage.dart';
import 'package:foodexpress/src/screens/EditProfilePage.dart';
import 'package:foodexpress/src/utils/CustomTextStyle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key key,
  }) : super(key: key);
  @override
  _ProfilePageState createState() {
    return new _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  String api = FoodApi.baseApi;
  Map<String, dynamic> result = {
    "name": ' ',
    "email": ' ',
    "image": '',
    "username": '',
    "phone": ' ',
    "address": ' '
  };
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

  Future<String> getmyProfile(token) async {
    final url = "$api/me";
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
    });
    var resBody = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        result['name'] = resBody['data']['name'];
        result['email'] = resBody['data']['email'];
        result['username'] = resBody['data']['username'];
        result['phone'] = resBody['data']['phone'];
        result['address'] = resBody['data']['address'];
        result['image'] = resBody['data']['image'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  Future<Null> refreshList(String token) async {
    setState(() {
      getmyProfile(token);
    });
  }

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    getmyProfile(token);
    deviceTokenUpdate(token);
  }

  Future<void> submit() async {
    var result =
        await Provider.of<AuthProvider>(context, listen: false).logOut();
    if (result) {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        resizeToAvoidBottomPadding: true,
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await refreshList(token);
          },
          child: result['name'] == ''
              ? CircularLoadingWidget(
                  height: 500,
                  subtitleText: 'profile not found',
                )
              : Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    result['name'] != null
                                        ? result['name']
                                        : 'name',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    result['email'] != null
                                        ? result['email']
                                        : 'email',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(
                                width: 55,
                                height: 55,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(300),
                                  onTap: () {
                                    // Navigator.of(context).pushNamed('/Profile');
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: result['image'] != null
                                        ? NetworkImage(result['image'])
                                        : AssetImage('assets/steak.png'),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white.withOpacity(0.15),
                                    offset: Offset(0, 3),
                                    blurRadius: 10)
                              ],
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: <Widget>[
                                ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(
                                      'Profile Settings',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    trailing: ButtonTheme(
                                      padding: EdgeInsets.all(0),
                                      minWidth: 50.0,
                                      height: 25.0,
                                      child: EditProfilePage(
                                        userdata: result,
                                        onChanged: () {},
                                      ),
                                    )),
                                ListTile(
                                  onTap: () {},
                                  dense: true,
                                  title: Text(
                                    'Full Name',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  trailing: Text(
                                    result['name'] != null
                                        ? result['name']
                                        : 'name',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  dense: true,
                                  title: Text(
                                    'username',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  trailing: Text(
                                    result['username'] != null
                                        ? result['username']
                                        : 'username',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  dense: true,
                                  title: Text(
                                    'Email',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  trailing: Text(
                                    result['email'] != null
                                        ? result['email']
                                        : 'email',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  dense: true,
                                  title: Text(
                                    'Phone',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  trailing: Text(
                                    result['phone'] != null
                                        ? result['phone']
                                        : 'phone',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  dense: true,
                                  title: Text(
                                    'Address',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  trailing: Text(
                                    result['address'] != null
                                        ? result['address']
                                        : 'address',
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                                leading: Icon(Icons.vpn_key),
                                title: Text(
                                  'Change Password',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                trailing: ButtonTheme(
                                  padding: EdgeInsets.all(0),
                                  minWidth: 50.0,
                                  height: 25.0,
                                  child: ChangePasswordPage(
                                    onChanged: () {},
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return createListViewItem();
      },
      itemCount: 1,
    );
  }

  createListViewItem() {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Colors.teal.shade200,
        onTap: () => submit(),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 12, bottom: 12),
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/ic_logout.png'),
                width: 20,
                height: 20,
                color: Colors.grey.shade500,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Logout',
                style: CustomTextStyle.textFormFieldBold
                    .copyWith(color: Colors.grey.shade500),
              ),
              Spacer(
                flex: 1,
              ),
              Icon(
                Icons.navigate_next,
                color: Colors.grey.shade500,
              )
            ],
          ),
        ),
      );
    });
  }
}
