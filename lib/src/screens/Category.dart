import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
// ignore: unused_import
import 'package:foodexpress/main.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/Widget/CircularLoadingWidget.dart';
import 'package:foodexpress/src/Widget/FadeAnimation.dart';
import 'package:foodexpress/src/screens/cartpage.dart';
// ignore: unused_import
import 'package:foodexpress/src/screens/loginPage.dart';
import 'package:foodexpress/src/screens/productAll.dart';

import 'package:foodexpress/src/shared/fryo_icons.dart';
import 'package:foodexpress/src/utils/CustomTextStyle.dart';
import 'package:provider/provider.dart';
import '../shared/styles.dart';
//import '../shared/colors.dart';
import './ProductPage.dart';
import '../shared/Product.dart';
import 'dart:async';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  final String shopID;
  final String shopName;
  final CartModel model;
  Category({Key key, @required this.shopID, this.shopName, this.model})
      : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class _CategoryState extends State<Category> {
  TextEditingController editingProductController = TextEditingController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  // ignore: unused_field
  int _selectedIndex = 0;
  // ignore: unused_field
  String _title;
  // ignore: unused_field
  String _sitename;
  var authenticated;

  String api = FoodApi.baseApi;
  List _categories = List();
  List _listProduct = List();
  List<Product> _products = [];
  Map<String, dynamic> shop = {
    "id": '',
    "name": '',
    "delivery_charge": 0.0,
    "opening_time": '',
    "closing_time": '',
    "image": '',
    "description": '',
    "address": ''
  };

  Future<String> getCategories(String shopID) async {
    final url = "$api/shops/$shopID/categories";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _categories = resBody['data']['categories'];
        shop['id'] = resBody['data']['shop']['id'];
        shop['name'] = resBody['data']['shop']['name'];
        shop['description'] = resBody['data']['shop']['description'];
        shop['delivery_charge'] =
            resBody['data']['shop']['delivery_charge'] != null
                ? resBody['data']['shop']['delivery_charge'].toDouble()
                : 0.0;
        shop['opening_time'] = resBody['data']['shop']['opening_time'];
        shop['closing_time'] = resBody['data']['shop']['closing_time'];
        shop['address'] = resBody['data']['shop']['address'];
        shop['image'] = resBody['data']['shop']['image'];
      });
    } else {
      throw Exception('Failed to data');
    }
    return "Sucess";
  }

  Future<String> getProducts(String shopID) async {
    final url = "$api/shops/$shopID/products";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _listProduct = resBody['data']['products'];
        _listProduct.forEach((element) => _products.add(Product(
            name: element['name'],
            stock_count: element['stock_count'],
            in_stock: element['in_stock'],
            id: element['id'],
            imgUrl: element['image'],
            price: element['unit_price'].toDouble())));
      });
    } else {
      throw Exception('Failed to');
    }
    return "Sucess";
  }

  // ignore: non_constant_identifier_names
  void SerchProduct(shop, value) async {
    final url = "$api/search/$shop/shops/$value/products";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _products.clear();
        _listProduct = resBody['data'];
        _listProduct.forEach((element) => _products.add(Product(
            name: element['name'],
            stock_count: element['stock_count'],
            in_stock: element['in_stock'],
            id: element['id'],
            imgUrl: element['image'],
            price: element['unit_price'].toDouble())));
      });
    } else {
      throw Exception('Failed to data');
    }
    return;
  }

  Future<Null> refreshList() async {
    setState(() {
      _products.clear();
      _categories.clear();
      this.getCategories(widget.shopID);
      this.getProducts(widget.shopID);
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: const Text('If you click back, the cart will be clear'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text('ACCEPT'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                        .clearCart();
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    this.getCategories(widget.shopID);
    this.getProducts(widget.shopID);
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AuthProvider>(context).currency;
    authenticated = Provider.of<AuthProvider>(context).status;
    // ignore: unused_local_variable
    final token = Provider.of<AuthProvider>(context).token;
    _sitename = Provider.of<AuthProvider>(context).sitename;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
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
                              backgroundColor: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              expandedHeight: 180,
                              elevation: 0,
                              iconTheme: IconThemeData(
                                  color: Theme.of(context).primaryColor),
                              flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.parallax,
                                background: Hero(
                                  tag: widget.shopID ?? '',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: shop['image'] != null
                                            ? NetworkImage(shop['image'])
                                            : AssetImage('assets/steak.png'),
                                      ),
                                    ),
                                  ),
                                ),
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
                                                  Text(
                                                      shop['name'] != null
                                                          ? shop['name']
                                                          : '',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 22.0)),
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
                                                  Text(
                                                      shop['address'] != null
                                                          ? shop['address']
                                                          : '',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 12.0)),
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
                                                Container(
                                                  child: Text(
                                                    shop['opening_time'] != null
                                                        ? 'Opening Time - ' +
                                                            shop['opening_time']
                                                        : ' ',
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0),
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Container(
                                                  child: Text(
                                                    shop['closing_time'] != null
                                                        ? 'Closing Time - ' +
                                                            shop['closing_time']
                                                        : '',
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0),
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Text(
                                                  'Delivery charge ' +
                                                      '$currency ' +
                                                      shop['delivery_charge']
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Text(
                                                  shop['description'] != null
                                                      ? shop['description']
                                                      : '',
                                                  overflow:
                                                      TextOverflow.visible,
                                                  maxLines: 2,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 14.0))),
                                        ],
                                      ),
                                      Divider(height: 20),
                                      FadeAnimation(
                                          1.2,
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius:
                                                      2.5, // has the effect of softening the shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white,
                                            ),
                                            child: TextField(
                                              textInputAction:
                                                  TextInputAction.search,
                                              onSubmitted: (value) {
                                                SerchProduct(
                                                    shop['id'].toString(),
                                                    value != null
                                                        ? value
                                                        : null);
                                              },
                                              controller:
                                                  editingProductController,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors.black87,
                                                  ),
                                                  hintText:
                                                      "Search for  products",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15)),
                                            ),
                                          )),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ),
                                      _categories.isEmpty
                                          ? Container()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: Container(
                                                child: headerTopCategories(
                                                    context, shop, _categories),
                                              ),
                                            ),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ),
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.49,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: new ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              padding: EdgeInsets.all(8.0),
                                              itemCount: _products.length,
                                              scrollDirection: Axis.vertical,
                                              //      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                                              itemBuilder: (context, index) {
                                                return _buildFoodCard(
                                                    context,
                                                    currency,
                                                    _products[index], () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductPage(
                                                                  currency:
                                                                      currency,
                                                                  productData:
                                                                      _products[
                                                                          index],
                                                                  shop: shop)));
                                                });
                                              })),
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
                ]))));
  }
}

Widget _buildFoodCard(context, currency, Product food, onTapped) {
  return InkWell(
    splashColor: Theme.of(context).accentColor,
    focusColor: Theme.of(context).accentColor,
    highlightColor: Theme.of(context).primaryColor,
    onTap: onTapped,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.15),
                offset: Offset(0, -2),
                blurRadius: 5.0)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                    image: NetworkImage(food.imgUrl), fit: BoxFit.fitHeight),
              ),
            ),
          ),
          SizedBox(width: 15),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        food.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        // ignore: deprecated_member_use
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      // Text(
                      //   'Quantity - '+food.quantity.toString(),
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 2,
                      //   style: Theme.of(context).textTheme.caption,
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '$currency' + food.price.toString(),
                  style: CustomTextStyle.textFormFieldMedium.copyWith(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle, style: h4),
      ),
    ],
  );
}

// wrap the horizontal listview inside a sizedBox..
Widget headerTopCategories(context, shop, List _categories) {
  return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.15),
                    offset: Offset(0, -2),
                    blurRadius: 5.0)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              sectionHeader('All Categories', onViewMore: () {}),
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: _categories.map((f) {
                    return headerCategoryItem(
                        context, f['name'], f['image'], f['id'], shop);
                  }).toList(),
                ),
              )
            ],
          )));
}

Widget headerCategoryItem(context, String name, String icon, int id, shop) {
  return Container(
    width: 70,
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 70,
            height: 70,
            child: FlatButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductAllPage(
                      category: name, categoryID: '$id', shop: shop),
                ));
              },
              child: Image(
                image: icon != null
                    ? NetworkImage(icon)
                    : AssetImage('assets/steak.png'),
                fit: BoxFit.contain,
                width: 150,
                height: 150,
              ),
            )),
        Text(
          name,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
          style: categoryText,
        )
      ],
    ),
  );
}
