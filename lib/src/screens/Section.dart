import 'dart:core';
import 'package:foodexpress/src/Widget/SearchBarWidget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/src/screens/cartpage.dart';
import 'package:foodexpress/src/Widget/CircularLoadingWidget.dart';
import 'package:foodexpress/src/Widget/FadeAnimation.dart';
import 'package:foodexpress/src/screens/Category.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ProductPage.dart';

class SectionCard extends StatefulWidget {
  final String getShopsByCategory;
  String sectionID;

  SectionCard({
    Key key,
    @required this.getShopsByCategory,
  }) : super(key: key);
  _SectionCardState createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  String api = FoodApi.baseApi;
  // List _shops = List();
  // List sections = List();
  Map<String, dynamic> sections = {
    "id": '',
    "name": '',
    "image": '',
    "description": '',
  };

  // List sections = [List()];
  Map<String, dynamic> _shops = {
    "id": '',
    "name": '',
    "image": '',
    "description": '',
  };

  //GlobalKey<RefreshIndicatorState> refreshKey;
  Position _currentPosition;

  Future<String> getShopsByCategory(String sectionId) async {
    final url =
        sectionId ="$api/sections?id=$sectionId";
    var response = await http.get(url, headers: {"Accept": "application/json"});

    // if (latitude != null && longitude != null) {
    //   response = await http.get(url, headers: {
    //     "X-FOOD-LAT": "$latitude",
    //     "X-FOOD-LONG": "$longitude",
    //     "Accept": "application/json"
    //   });
    // } else {
    //   response = await http.get(url, headers: {"Accept": "application/json"});
    // }
    var resBody = json.decode(response.body);
    print(resBody);
    if (response.statusCode == 200) {
      setState(() {
        _shops.clear();
        _shops = resBody['data'];
        sections['id'] = resBody['data']['id'];
        sections['name'] = resBody['data']['shop']['name'];
        sections['description'] = resBody['data']['shop']['description'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  Future<Null> refreshList() async {
    setState(() {
      _shops.clear();
      //  getShopsByCategory(widget.sectionId);
    });
  }

  @override
  void initState() {
    // getSection(widget.sectionID);
    getShopsByCategory(widget.sectionID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          centerTitle: true,
          // title: Text(
          //   sections['name'] != null ? sections['name'] : '',
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline6
          //       .merge(TextStyle(letterSpacing: 1.3)),
          // ),
          actions: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                height: 150.0,
                width: 30.0,
                child: new GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartPage()));
                  },
                  child: Stack(
                    children: <Widget>[
                      new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage()));
                          }),
                      new Positioned(
                          right: -2,
                          top: -2,
                          child: new Stack(
                            children: <Widget>[
                              new Icon(Icons.brightness_1,
                                  size: 15.0, color: Colors.orange.shade500),
                              new Positioned(
                                  top: 2.0,
                                  right: 5.2,
                                  child: new Center(
                                    child: new Text(
                                      ScopedModel.of<CartModel>(context,
                                              rebuildOnChange: true)
                                          .totalQunty
                                          .toString(),
                                      style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await refreshList();
            },
            child: Stack(fit: StackFit.expand, children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 0.0),
                  padding: EdgeInsets.only(bottom: 15),
                  child: CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.9),
                          expandedHeight: 180,
                          elevation: 0,
                          iconTheme: IconThemeData(
                              color: Theme.of(context).primaryColor),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            // background: Hero(
                            //   // tag: widget.sectionID ?? '',
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(5)),
                            //       image: DecorationImage(
                            //         fit: BoxFit.cover,
                            //         image: sections['image'] != null
                            //             ? NetworkImage(sections['image'])
                            //             : AssetImage('assets/steak.png'),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),
                        SliverToBoxAdapter(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Wrap(runSpacing: 8, children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(children: [
                                              SizedBox(height: 2.0),
                                              // Text(
                                              //     shop['name'] != null
                                              //         ? shop['name']
                                              //         : '',
                                              //     overflow:
                                              //         TextOverflow.ellipsis,
                                              //     maxLines: 2,
                                              //     style: TextStyle(
                                              //         fontFamily:
                                              //             'Montserrat',
                                              //         fontSize: 22.0)),
                                            ]),
                                            SizedBox(height: 5.0),
                                            Row(children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14.0,
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(1),
                                              ),
                                              SizedBox(height: 2.0),
                                              // Text(
                                              //     shop['address'] != null
                                              //         ? shop['address']
                                              //         : '',
                                              //     overflow:
                                              //         TextOverflow.ellipsis,
                                              //     maxLines: 2,
                                              //     style: TextStyle(
                                              //         fontFamily:
                                              //             'Montserrat',
                                              //         fontSize: 12.0)),
                                            ]),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            // Container(
                                            //   child: Text(
                                            //     shop['opening_time'] != null
                                            //         ? 'Opening Time - ' +
                                            //             shop['opening_time']
                                            //         : ' ',
                                            //     style: TextStyle(
                                            //         color: Colors.black
                                            //             .withOpacity(0.8),
                                            //         fontFamily:
                                            //             'Montserrat',
                                            //         fontSize: 10.0),
                                            //   ),
                                            // ),
                                            SizedBox(height: 5.0),
                                            // Container(
                                            //   child: Text(
                                            //     shop['closing_time'] != null
                                            //         ? 'Closing Time - ' +
                                            //             shop['closing_time']
                                            //         : '',
                                            //     style: TextStyle(
                                            //         color: Colors.black
                                            //             .withOpacity(0.8),
                                            //         fontFamily:
                                            //             'Montserrat',
                                            //         fontSize: 10.0),
                                            //   ),
                                            // ),
                                            SizedBox(height: 5.0),
                                            // Text(
                                            //   'Delivery charge ' +
                                            //       '$currency ' +
                                            //       shop['delivery_charge']
                                            //           .toString(),
                                            //   style: TextStyle(
                                            //       color: Colors.black
                                            //           .withOpacity(0.8),
                                            //       fontFamily: 'Montserrat',
                                            //       fontSize: 10.0),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: <Widget>[
                                  //     Expanded(
                                  //         child: Text(
                                  //             shop['description'] != null
                                  //                 ? shop['description']
                                  //                 : '',
                                  //             overflow:
                                  //                 TextOverflow.visible,
                                  //             maxLines: 2,
                                  //             softWrap: false,
                                  //             style: TextStyle(
                                  //                 fontFamily: 'Montserrat',
                                  //                 fontSize: 14.0))),
                                  //   ],
                                  // ),
                                  Divider(height: 20),
                                  // FadeAnimation(
                                  //     1.2,
                                  //     Container(
                                  //       padding: EdgeInsets.symmetric(
                                  //           vertical: 5),
                                  //       margin: EdgeInsets.symmetric(
                                  //           horizontal: 20),
                                  //       height: 50,
                                  //       decoration: BoxDecoration(
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             color: Colors.grey,
                                  //             blurRadius:
                                  //                 2.5, // has the effect of softening the shadow
                                  //           ),
                                  //         ],
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //         color: Colors.white,
                                  //       ),
                                  //       child: TextField(
                                  //         textInputAction:
                                  //             TextInputAction.search,
                                  //         onSubmitted: (value) {
                                  //           SerchProduct(
                                  //               shop['id'].toString(),
                                  //               value != null
                                  //                   ? value
                                  //                   : null);
                                  //         },
                                  //         controller:
                                  //             editingProductController,
                                  //         decoration: InputDecoration(
                                  //             border: InputBorder.none,
                                  //             prefixIcon: Icon(
                                  //               Icons.search,
                                  //               color: Colors.black87,
                                  //             ),
                                  //             hintText:
                                  //                 "Search for  products",
                                  //             hintStyle: TextStyle(
                                  //                 color: Colors.grey,
                                  //                 fontSize: 15)),
                                  //       ),
                                  //     )),
                                  ListTile(
                                    dense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: -5),
                                    leading: Icon(
                                      Icons.category,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      'Product Categories',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                  _shops.isEmpty
                                      ? Container()
                                      : ListView(children: <Widget>[
                                          // Container(
                                          //     height: MediaQuery.of(context)
                                          //         .size
                                          //         .height,
                                          //     width: MediaQuery.of(context).size.width /2,
                                          //     child: new GridView.count(
                                          //       crossAxisCount: 3,
                                          //       shrinkWrap: true,
                                          //       primary: true,
                                          //       scrollDirection: Axis.vertical,
                                          //       children:
                                          //           getShopsByCategory.map((_getShops) {
                                          //         return _buildShopCard(
                                          //             _getShops['name'],
                                          //             _getShops['image'],
                                          //             _getShops['id']);
                                          //       }).toList(),
                                          //     ))
                                        ]),
                                  ListTile(
                                    dense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: -5),
                                    leading: Icon(
                                      Icons.category,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      'Product ',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ])))
                      ])),
              // Positioned(
              //   top: 32,
              //   right: 20,
              //   child: ShoppingCartFloatButtonWidget(
              //           iconColor: Colors.white,
              //           labelColor: Colors.green,
              //           //  routeArgument: RouteArgument(param: '/Product', id: _con.product.id),
              //         ),
              // ),
            ])));
  }

  _buildShopCard(String name, String image, String id) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.white,
      child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.05),
                    offset: Offset(0, 5),
                    blurRadius: 5)
              ]),
          child: Stack(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                // Text(
                //   food.name != null ? food.name : '',
                //   style: TextStyle(
                //       fontFamily: 'Montserrat',
                //       color: Color(0xFF440206),
                //       fontSize: 15.0),
                //   softWrap: false,
                //   maxLines: 1,
                //   overflow: TextOverflow.fade,
                // ),
                SizedBox(height: 4),
                // Text(
                //   '$currency' + food.price.toString(),
                //   style: TextStyle(
                //       fontFamily: 'Montserrat',
                //       color: Color(0xFFF75A4C),
                //       fontSize: 14.0),
                //   softWrap: false,
                //   maxLines: 1,
                //   overflow: TextOverflow.fade,
                // ),
                SizedBox(height: 17),
              ],
            ),
          ])),
    );
  }
}
