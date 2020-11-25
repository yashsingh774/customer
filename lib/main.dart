import 'dart:ffi';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/screens/Category.dart';
import 'package:foodexpress/src/screens/Help.dart';
import 'package:foodexpress/src/screens/ProfilePage.dart';
import 'package:foodexpress/src/screens/Transaction.dart';
import 'package:foodexpress/src/screens/cartpage.dart';
import 'package:foodexpress/src/screens/cat.dart';
import 'package:foodexpress/src/screens/loginPage.dart';
import 'package:foodexpress/src/screens/orderhistory.dart';
import 'package:foodexpress/src/screens/signupPage.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api.dart';
import 'package:foodexpress/src/shared/drawer.dart';
import 'src/screens/ShopPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AuthProvider _auth = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: _auth),
      ],
      child: ScopedModel(
          model: CartModel(),
          child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            routes: {
              '/': (BuildContext context) => MyHomePage(),
              '/home': (BuildContext context) => MyHomePage(),
              '/category': (BuildContext context) => Category(
                    shopID: '1',
                  ),
              '/cart': (BuildContext context) => CartPage(),
              '/register': (BuildContext context) => Register(),
              '/login': (BuildContext context) => LoginPage(),
            '/Help': (BuildContext context) => HelpPage(),
        //      '/Ordernow': (BuildContext context) => OrderNowPage(),
              // '/Goout': (BuildContext context) => ShopPage()
              '/Shop': (BuildContext context) => ShopPage()
            },
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String title;
  int tabsIndex;
  MyHomePage({Key key, this.title, this.tabsIndex}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.authenticated);
  @override
  int _selectedIndex = 0;
  String _title;
  String _sitename;
  var authenticated;
  String token;
  String deviceId;
  String api = FoodApi.baseApi;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.device; // unique ID on Android
    }
  }

  @override
  void initState() {
    super.initState();
    token = Provider.of<AuthProvider>(context, listen: false).token;
    
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  update(String token) async {
    deviceId = await _getId();
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('deviceToken', token);
    await storage.setString('deviceId', deviceId);
    print(token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    authenticated = Provider.of<AuthProvider>(context).status;
    token = Provider.of<AuthProvider>(context, listen: false).token;
    _sitename = Provider.of<AuthProvider>(context).sitename;

    final _tabs = [
      // OrderNowPage(),
     // GooutPage(),
     ShopPage(),
      Transaction(),
      ProfilePage(),
      OrderPage(),
      CartPage(),
      LoginPage(),
      HelpPage(),
      SampleApp(),
      // ShopPage(),
      // GooutPage(),
    ];

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
                _sitename != null ? _sitename : '',
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            ),
        actions: <Widget>[
        //  authenticated == Status.Authenticated
         //     ?
               Text('Echo'),
              // : IconButton(
              //     padding: EdgeInsets.all(0),
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => ShopPage()));
              //     },
              //     iconSize: 25,
              //     icon: Icon(Icons.search, color: Color(0xff44c662)),
              //   ),
          // IconButton(
          //   padding: EdgeInsets.all(0),
          //   iconSize: 25,
          //   icon: Icon(Icons.shopping_cart, color: Color(0xff44c662)),
          // ),
        ],
      ),
      body: SafeArea(
          child: _tabs[
              widget.tabsIndex != null ? widget.tabsIndex : _selectedIndex]),
    );
  }
}

//+17738255394