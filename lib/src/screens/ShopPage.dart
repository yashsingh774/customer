import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/screens/Category.dart';
import 'package:foodexpress/src/utils/CustomTextStyle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:progressive_image/progressive_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
              title: 'Mr. Echo',
              theme: ThemeData(
                backgroundColor: Color(0xff44c662),
              ),
            )));
  }
}

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() {
    return new _ShopPageState();
  }
}

class _ShopPageState extends State<ShopPage> {
  bool buildBannerCard = false;
  bool buildSectionCard = false;
  TextEditingController editingController = TextEditingController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  Position _currentPosition;
  Geolocator _geolocator = Geolocator();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  String api = FoodApi.baseApi;
  String _selectedLocation = '1';
  String _selectedArea = '1';
  List _locations = List();
  List _areas = List();
  List _sections = List();
  List _banners = List();
  List _shops = List();
  String _currentAddress;

  Future<void> setting() async {
    await Provider.of<AuthProvider>(context, listen: false).setting();
  }

  Future<String> getSections() async {
    final url = "$api/sections";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _sections = resBody['data'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  Future<String> getBanners() async {
    final url = "$api/banners";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _banners = resBody['data'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  Future<String> getLocations(latitude, longitude) async {
    final url = "$api/locations";
    var response = await http.get(url, headers: {
      "X-FOOD-LAT": "$latitude",
      "X-FOOD-LONG": "$longitude",
      "Accept": "application/json"
    });
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _locations = resBody['data'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  Future<String> getArea(String locationID, latitude, longitude) async {
    final url = "$api/locations/$locationID/areas";
    var response = await http.get(url, headers: {
      "X-FOOD-LAT": "$latitude",
      "X-FOOD-LONG": "$longitude",
      "Accept": "application/json"
    });
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _areas = resBody['data'];
      });
    } else {
      throw Exception('Failed to');
    }

    return "Sucess";
  }

  Future<String> getShops(String areaID, latitude, longitude) async {
    final url = areaID != null ? "$api/areas?id=$areaID" : '$api/areas';
    var response = await http.get(url, headers: {
      "X-FOOD-LAT": "$latitude",
      "X-FOOD-LONG": "$longitude",
      "Accept": "application/json"
    });
    var resBody = json.decode(response.body);
    print(resBody);
    if (response.statusCode == 200) {
      setState(() {
        _shops.clear();
        _shops = resBody['data'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  Future<String> getShopsByCategory(
      String sectionId, latitude, longitude) async {
    final url =
        sectionId != null ? "$api/sections?id=$sectionId" : '$api/areas';
    var response;
    if (latitude != null && longitude != null) {
      response = await http.get(url, headers: {
        "X-FOOD-LAT": "$latitude",
        "X-FOOD-LONG": "$longitude",
        "Accept": "application/json"
      });
    } else {
      response = await http.get(url, headers: {"Accept": "application/json"});
    }
    var resBody = json.decode(response.body);
    print(resBody);
    if (response.statusCode == 200) {
      setState(() {
        _shops.clear();
        _shops = resBody['data'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  void SerchShop(value, latitude, longitude) async {
    final url = "$api/search/$value/shops";
    var response = await http.get(url, headers: {
      "X-FOOD-LAT": "$latitude",
      "X-FOOD-LONG": "$longitude",
      "Accept": "application/json"
    });
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _shops.clear();
        _shops = resBody['data'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return;
  }

  Future<Null> refreshList(area) async {
    setState(() {
      _shops.clear();
      this.setting();
      this.getShops(
          area,
          _currentPosition != null ? _currentPosition.latitude : '',
          _currentPosition != null ? _currentPosition.longitude : '');
      this.getLocations(
          _currentPosition != null ? _currentPosition.latitude : '',
          _currentPosition != null ? _currentPosition.longitude : '');
      _getCurrentLocation();
    });
  }

  initAuthProvider(context) async {
    Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
  }

  @override
  void initState() {
    getSections();
    getBanners();
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        buildBannerCard = true;
        buildSectionCard = true;
      });
    });
    super.initState();
    _getCurrentLocation();
    checkPermission();
    this.setting();
    initAuthProvider(context);
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _selectedArea = null;
        _selectedLocation = null;
        _currentPosition = position;
        this.getLocations(
            _currentPosition != null ? _currentPosition.latitude : '',
            _currentPosition != null ? _currentPosition.longitude : '');
        this.getArea(
            _selectedLocation,
            _currentPosition != null ? _currentPosition.latitude : '',
            _currentPosition != null ? _currentPosition.longitude : '');
        this.getShops(
            _selectedArea,
            _currentPosition != null ? _currentPosition.latitude : '',
            _currentPosition != null ? _currentPosition.longitude : '');
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
      this.getLocations(
          _currentPosition != null ? _currentPosition.latitude : '',
          _currentPosition != null ? _currentPosition.longitude : '');
      this.getArea(
          _selectedLocation,
          _currentPosition != null ? _currentPosition.latitude : '',
          _currentPosition != null ? _currentPosition.longitude : '');
      this.getShops(
          _selectedArea,
          _currentPosition != null ? _currentPosition.latitude : '',
          _currentPosition != null ? _currentPosition.longitude : '');
      checkPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget image_carousel = new Container(
    //  padding: EdgeInsets.only( left: 5.0, right: 5.0),
    //   height: 150.0,
    //   child: new Carousel(

    //     boxFit: BoxFit.cover,
    //     images: [
    //       AssetImage('assets/images/1.jpg'),
    //       AssetImage('assets/images/2.jpg'),
    //       AssetImage('assets/images/3.jpg'),
    //       AssetImage('assets/images/4.jpg'),
    //     ],
    //     autoplay: true,
    //     dotSize: 4.0,
    //     indicatorBgPadding: 8,
    //   ),
    // );
    return Scaffold(
        backgroundColor: Color(000),
        body: SafeArea(
            child: RefreshIndicator(
                key: refreshKey,
                onRefresh: () async {
                  await refreshList(_selectedArea);
                },
                child: new LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              )),
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              SerchShop(
                                  value != null ? value : null,
                                  _currentPosition != null
                                      ? _currentPosition.latitude
                                      : '',
                                  _currentPosition != null
                                      ? _currentPosition.longitude
                                      : '');
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              hintText: 'Search for shops',
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 14.0),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      buildBannerCard
                          ? Container(
                              padding: EdgeInsets.only(
                                  top: 2.0, left: 2.0, right: 2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    )),
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 220,
                              child: Shimmer.fromColors(
                                child: Card(
                                  color: Colors.grey,
                                ),
                                baseColor: Colors.white70,
                                highlightColor: Colors.grey[500],
                                direction: ShimmerDirection.ltr,
                              ),
                            ),
                      Container(
                        height: 220,
                        padding:
                            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _banners.map((banner) {
                              return _buildBannerCard(banner['name'],
                                  banner['image'], banner['id']);
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                          // height: 150.0,
                          // width: 300.0,
                          child: Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Shop Categories',
                              style: CustomTextStyle.textFormFieldBold
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      )),
                      buildSectionCard
                          ? Container(
                              height: 140,
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _sections.map((section) {
                                  return _buildSectionCard(section['name'],
                                      section['image'], section['id']);
                                }).toList(),
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              child: Shimmer.fromColors(
                                child: Card(
                                  color: Colors.grey,
                                ),
                                baseColor: Colors.white70,
                                highlightColor: Colors.grey[500],
                                direction: ShimmerDirection.ltr,
                              ),
                            ),
                      Container(
                          padding: EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 20.0),
                          height: 800,
                          child: new GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: false,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            children: _shops.map((shop) {
                              return _buildCard(shop['name'], shop['image'],
                                  shop['address'], shop['id']);
                            }).toList(),
                          )),
                    ],
                  ));
                }))));
  }

  Widget _buildSectionCard(String name, String imgPath, int sectionpID) {
    return InkWell(
      highlightColor: Colors.grey,
      splashColor: Colors.grey,
      onTap: () {
        getShopsByCategory(
            '$sectionpID',
            _currentPosition != null ? _currentPosition.latitude : '',
            _currentPosition != null ? _currentPosition.longitude : '');
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                // child: Image.network(
                //   imgPath,
                //   fit: BoxFit.contain,
                //   height: 50,
                //   width: 90,
                // ),
                child: ProgressiveImage(
                  //imgPath,
                  placeholder: AssetImage('assets/placeholder.jpg'),
                  // size: 1.87KB
                  thumbnail: NetworkImage(imgPath),
                  // size: 1.29MB
                  image: NetworkImage(imgPath),
                  fit: BoxFit.contain,
                  height: 50,
                  width: 90,
                ),
              ),
            ),
            Text(
              name != null ? name : '',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Varela', fontSize: 15.0),
              softWrap: false,
              maxLines: 3,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String name, String imgPath, String address, int shopID) {
    return InkWell(
      highlightColor: Colors.grey,
      splashColor: Colors.grey,
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => Category(shopID: '$shopID', shopName: name),
        // ));
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: Category(shopID: '$shopID', shopName: name)));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                // child: Image.network(
                //   imgPath,
                //   fit: BoxFit.contain,
                //   height: 60,
                //   width: 80,
                // ),

                child: ProgressiveImage(
                  //imgPath,
                  placeholder: AssetImage('assets/placeholder.jpg'),
                  // size: 1.87KB
                  thumbnail: NetworkImage(imgPath),
                  // size: 1.29MB
                  image: NetworkImage(imgPath),
                  fit: BoxFit.contain,
                  height: 60,
                  width: 80,
                ),
              ),
            ),
            Text(
              name != null ? name : '',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Varela', fontSize: 15.0),
              softWrap: false,
              maxLines: 3,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(String name, String imgPath, int bannerpID) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(0),
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ProgressiveImage(
                //imgPath,
                placeholder: AssetImage('assets/placeholder.jpg'),
                // size: 1.87KB
                thumbnail: NetworkImage('https://i.imgur.com/7XL923M.jpg'),
                // size: 1.29MB
                image: NetworkImage(imgPath),
                fit: BoxFit.fitWidth,
                height: 180,
                width: 430,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
