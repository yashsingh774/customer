import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/src/Widget/CircularLoadingWidget.dart';
import 'package:foodexpress/src/screens/Category.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  SearchResultWidget({Key key, this.heroTag}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  TextEditingController editingController = TextEditingController();
  bool buildCard = false;
  Position _currentPosition;
  String api = FoodApi.baseApi;
  List _sections = List();
  List _shops = List();

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

  // ignore: non_constant_identifier_names
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Search',
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                'Ordered by nearby first',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onSubmitted: (value) {
                SerchShop(
                    value != null ? value : null,
                    _currentPosition != null ? _currentPosition.latitude : '',
                    _currentPosition != null ? _currentPosition.longitude : '');
              },
              controller: editingController,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Search for markets or products',
                hintStyle: Theme.of(context)
                    .textTheme
                    .caption
                    .merge(TextStyle(fontSize: 14)),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
          buildCard
              ? CircularLoadingWidget(height: 288)
              : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            'Search Result',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: false,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        children: _shops.map((shop) {
                          return _buildCard(shop['name'], shop['image'],
                              shop['address'], shop['id']);
                        }).toList(),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCard(String name, String imgPath, String address, int shopID) {
    return InkWell(
      highlightColor: Colors.grey,
      splashColor: Colors.grey,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Category(shopID: '$shopID', shopName: name),
        ));
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
                child: Image.network(
                  imgPath,
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

  
}
