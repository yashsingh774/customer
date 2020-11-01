// import 'package:flutter/material.dart';
// import 'package:foodexpress/main.dart';
// import 'package:foodexpress/src/screens/cartpage.dart';
// //import 'package:foodexpress/src/screens/helpSupportPage.dart';
// import 'package:foodexpress/src/screens/loginPage.dart';
// import 'package:provider/provider.dart';
// import 'package:foodexpress/providers/auth.dart';
// import 'dart:async';


// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authenticated = Provider.of<AuthProvider>(context).status;

//     Future<void> loginLogout(authenticatedStatus) async {
//         Navigator.of(context).pop();
//         if (authenticatedStatus == Status.Authenticated) {
//           var result = await Provider.of<AuthProvider>(context,listen: false).logOut();
//           if (result) {
//             Navigator.of(context).push(new MaterialPageRoute(
//                 builder: (context) => MyHomePage())) ;
//           }
//         } else {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => LoginPage()));
//         }
//     }

//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           _createHeader(),
//           _createDrawerItem(icon: Icons.home,text: 'Home',
//             onTap: () {
//               Navigator.of(context).pop();
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => MyHomePage(tabsIndex:0),));
//             },
//           ),
//           Divider(),
//           _createDrawerItem(icon: Icons.shopping_cart, text: 'Orders',
//             onTap: () {
//               Navigator.of(context).pop();
//               if (authenticated == Status.Authenticated) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => MyHomePage(title: 'Orders', tabsIndex: 3)));
//               } else {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => LoginPage()));
//               }
//             },
//           ),
//           _createDrawerItem(icon: Icons.payment, text: 'Transactions',
//             onTap: () {
//               Navigator.of(context).pop();
//               if (authenticated == Status.Authenticated) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => MyHomePage(title: 'Transactions', tabsIndex: 1)));
//               } else {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => LoginPage()));
//               }
//             },
//           ),
//           _createDrawerItem(icon: Icons.shopping_cart, text: 'Cart',
//             onTap: () {
//               Navigator.of(context).pop();
//               if (authenticated == Status.Authenticated) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => MyHomePage(title: 'Cart', tabsIndex: 4)));
//               } else {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => LoginPage()));
//               }
//             },
//           ),
//           Divider(),
//           _createDrawerItem(icon: Icons.account_box, text: 'Profile',
//             onTap: () {
//               Navigator.of(context).pop();
//               if (authenticated == Status.Authenticated) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => MyHomePage(title: 'Profile', tabsIndex: 2)));
//               } else {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => LoginPage()));
//               }
//             },
//           ),
//           Divider(),
//           _createDrawerItem(icon: Icons.account_box, text: 'Shop Now',
//             onTap: () {
//               Navigator.of(context).pop();
//               if (authenticated == Status.Authenticated) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => MyHomePage(title: 'Shop Now', tabsIndex: 0)));
//               } else {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => LoginPage()));
//               }
//             },
//           ),
//           Divider(),
//           _createDrawerItem(icon: Icons.exit_to_app, text: (authenticated == Status.Authenticated) ? 'Logout' : 'Login',
//             onTap: () =>loginLogout(authenticated)
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget _createHeader() {
//   return DrawerHeader(
//       margin: EdgeInsets.zero,
//       padding: EdgeInsets.zero,
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               fit: BoxFit.contain,
//               image: AssetImage('assets/images/header_background.png'))),
//       child: Stack(children: <Widget>[
//         Positioned(
//             bottom: 5.0,
//             left: 16.0,
//             child: Text("Welcome",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20.0,
//                     fontFamily: 'Montserrat',
//                     fontWeight: FontWeight.w500))),
//       ]));
// }

// Widget _createDrawerItem(
//     {IconData icon, String text, GestureTapCallback onTap}) {
//   return ListTile(
//     title: Row(
//       children: <Widget>[
//         Icon(icon),
//         Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Text(text),
//         )
//       ],
//     ),
//     onTap: onTap,
//   );
// }




import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/main.dart';
// ignore: unused_import
import 'package:foodexpress/src/screens/cartpage.dart';
//import 'package:foodexpress/src/screens/helpSupportPage.dart';
import 'package:foodexpress/src/screens/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:foodexpress/providers/auth.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() {
    return new _AppDrawerState();
  }
}

class _AppDrawerState extends State<AppDrawer> {
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

  Widget build(BuildContext context) {
    final authenticated = Provider.of<AuthProvider>(context).status;

    Future<void> loginLogout(authenticatedStatus) async {
      Navigator.of(context).pop();
      if (authenticatedStatus == Status.Authenticated) {
        var result =
            await Provider.of<AuthProvider>(context, listen: false).logOut();
        if (result) {
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => MyHomePage()));
        }
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()));
      }
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
          result['image'] = resBody['data']['image'];
        });
      } else {
        throw Exception('Failed to data');
      }
      return "Sucess";
    }

    @override
    void initState() {
      super.initState();
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      getmyProfile(token);
      deviceTokenUpdate(token);
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/images/header_background.png'))),
              child: Stack(children: <Widget>[
                Row(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width: 55,
                          height: 55,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(300),
                            onTap: () {
                              // Navigator.of(context).pushNamed('/Profile');
                            },
                            // child: CircleAvatar(
                            //   backgroundImage: result['image'] != null
                            //       ? NetworkImage(result['image'])
                            //       : AssetImage('assets/steak.png'),
                            // ),
                          )),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              result['name'] != null ? result['name'] : 'name',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 45,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              result['email'] != null
                                  ? result['email']
                                  : 'email',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ])),

          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyHomePage(tabsIndex: 0),
              ));
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
                 ListTile(
            onTap: () {
              Navigator.of(context).pop();
              if (authenticated == Status.Authenticated) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(title: 'Profile', tabsIndex: 2)));
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            leading: Icon(
              Icons.account_box,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              if (authenticated == Status.Authenticated) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(title: 'Orders', tabsIndex: 3)));
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            leading: Icon(
              Icons.local_mall,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'My Orders',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
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
            leading: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'My Cart',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              if (authenticated == Status.Authenticated) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(title: 'Transactions', tabsIndex: 1)));
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            leading: Icon(
              Icons.payment,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Transaction',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              ' Application Preferences',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
         
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(title: 'Help', tabsIndex: 6)));
              },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Help & Support',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     if (currentUser.value.apiToken != null) {
          //       Navigator.of(context).pushNamed('/Settings');
          //     } else {
          //       Navigator.of(context).pushReplacementNamed('/Login');
          //     }
          //   },
          //   leading: Icon(
          //     Icons.settings,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).settings,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Languages');
          //   },
          //   leading: Icon(
          //     Icons.translate,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).languages,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     if (Theme.of(context).brightness == Brightness.dark) {
          //       setBrightness(Brightness.light);
          //       setting.value.brightness.value = Brightness.light;
          //     } else {
          //       setting.value.brightness.value = Brightness.dark;
          //       setBrightness(Brightness.dark);
          //     }
          //     setting.notifyListeners();
          //   },
          //   leading: Icon(
          //     Icons.brightness_6,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text:
                  (authenticated == Status.Authenticated) ? 'Logout' : 'Login',
              onTap: () => loginLogout(authenticated)),
          SizedBox(),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
