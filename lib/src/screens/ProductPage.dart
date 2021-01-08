import 'package:flutter/material.dart';
import 'package:foodexpress/config/api.dart';
import 'package:foodexpress/providers/auth.dart';
import 'package:foodexpress/src/Widget/CircularLoadingWidget.dart';
import 'package:foodexpress/src/screens/CheckOutPage.dart';
import 'package:foodexpress/src/screens/ShoppingCartFloatButtonWidget.dart';
import 'package:foodexpress/src/screens/cartpage.dart';
import 'package:foodexpress/src/screens/loginPage.dart';
import 'package:foodexpress/src/utils/CustomTextStyle.dart';
import 'package:provider/provider.dart';
import '../shared/Product.dart';
import '../shared/styles.dart';
//import '../shared/colors.dart';
import '../shared/buttons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:foodexpress/models/cartmodel.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupModelOptions {
  String id;
  String name;
  String price;
  bool checked;
  GroupModelOptions({this.name, this.price, this.id});
}

class GroupModelVariations {
  String id;
  String name;
  String price;
  GroupModelVariations({this.name, this.price, this.id});
}

class ProductPage extends StatefulWidget {
  final String pageTitle;
  final Product productData;
  final shop;
  final String currency;

  ProductPage(
      {Key key, this.pageTitle, this.currency, this.productData, this.shop})
      : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  String api = FoodApi.baseApi;
  List _listImage = List();
  List _variations = List();
  List _options = List();
  List Image;
  // = [AssetImage('assets/images/icon.png')];

  int _quantity = 1;
  int count = 0;

  String _currOption = '1';
  String _currVariation = '1';

  List<GroupModelVariations> _groupVariations = [];
  List<GroupModelOptions> _groupOptions = [];
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

  Map<String, dynamic> ProductShow = {
    "id": '',
    "name": '',
    "Image": '',
    "unit_price": '',
    "stock_count": '',
    "in_stock": '',
    "description": '',
  };

  Future<String> getProduct(String shopID, String ProductID) async {
    final url = "$api/shops/$shopID/products/$ProductID";
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      print(resBody);
      setState(() {
        ProductShow['id'] = resBody['data']['id'];
        ProductShow['image'] = resBody['data']['image'] != null
            ? resBody['data']['image'][0]
            : resBody['data']['image'];
        ProductShow['name'] = resBody['data']['name'];
        ProductShow['unit_price'] = resBody['data']['unit_price'].toString();
        ProductShow['stock_count'] = resBody['data']['stock_count'];
        ProductShow['in_stock'] = resBody['data']['in_stock'];
        ProductShow['description'] = resBody['data']['description'];
        _listImage = resBody['data']['image'];
        _variations = resBody['data']['variations'];
        _options = resBody['data']['options'];
        // Image.clear();
        // _listImage.forEach((f)=> Image.add(NetworkImage(f)));
        _variations
            .forEach((variation) => _groupVariations.add(GroupModelVariations(
                  id: variation['id'].toString(),
                  name: variation['name'],
                  price: variation['unit_price'].toString(),
                )));
        _options.forEach((option) => _groupOptions.add(GroupModelOptions(
              id: option['id'].toString(),
              name: option['name'],
              price: option['unit_price'].toString(),
            )));
      });
    } else {
      throw Exception('Failed to');
    }
    return "Sucess";
  }

  List _selecteCategorys = List();
  List selecteOptions = [];

  void _onCategorySelected(bool selected, category_id, options) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);
        selecteOptions.add(options);
        print(selecteOptions.length);
      });
    } else {
      setState(() {
        selecteOptions.removeWhere((item) => item.id == category_id);
        _selecteCategorys.remove(category_id);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProduct(
        widget.shop['id'].toString(), (widget.productData.id).toString());
    widget.productData.qty = _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final authenticated = Provider.of<AuthProvider>(context).status;
    final currency = Provider.of<AuthProvider>(context).currency;

Future<bool> _showalert(){
   return showDialog(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text('Are you sure?'),
              content: const Text(
                  'Added to Cart'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
}


    // void _showToast(BuildContext context) {
    //   final scaffold = Scaffold.of(context);
    //   scaffold.showSnackBar(
    //     SnackBar(
    //       content: const Text('Added to cart'),
    //       action: SnackBarAction(
    //           label: 'Dismiss', onPressed: scaffold.hideCurrentSnackBar),
    //     ),
    //   );
    // }

    void _showToastStock(BuildContext context) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Stock Out'),
          action: SnackBarAction(
              label: 'Dismiss', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    Widget imageCarousel = Container(
      height: 300.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        // images: Image,
        autoplay: false,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 8.0,
        dotColor: Colors.red,
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: widget.productData == null
                ? CircularLoadingWidget(height: 500)
                : ScopedModelDescendant<CartModel>(
                    // ignore: missing_return
                    builder: (context, child, model) {
                    // ignore: unused_label
                    return Stack(fit: StackFit.expand, children: <Widget>[
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
                                  expandedHeight: 300,
                                  elevation: 0,
                                  iconTheme: IconThemeData(
                                      color: Theme.of(context).primaryColor),
                                  flexibleSpace: FlexibleSpaceBar(
                                    collapseMode: CollapseMode.parallax,
                                    background: Hero(
                                      tag: widget.productData.id,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: ProductShow['image'] != null
                                                ? NetworkImage(
                                                    ProductShow['image'])
                                                : AssetImage(
                                                    'assets/images/icon.png'),
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
                                    child: Wrap(
                                      runSpacing: 8,
                                      children: [
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
                                                  Text(
                                                    ProductShow['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    shop['name'] != null
                                                        ? shop['name']
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    'Price ' +
                                                        currency +
                                                        ProductShow[
                                                                'unit_price']
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.lightGreen,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      
                                        Divider(height: 20),
                                        Text(
                                          ProductShow['description'] != null
                                              ? ProductShow['description']
                                              : '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),

// 
                                        _groupVariations.isEmpty
                                            ? Container()
                                            : Column(children: <Widget>[
                                                Container(
                                                  child: ListTile(
                                                    dense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    leading: Icon(
                                                      Icons.add_circle,
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                    ),
                                                    title: Text(
                                                      ' Options',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1,
                                                    ),
                                                    subtitle: Text(
                                                      'Select options to add them on the product',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    child: Container(
                                                  child: Column(
                                                    children: _groupVariations
                                                        .map((t) =>
                                                            RadioListTile(
                                                              value: t.id,
                                                              groupValue:
                                                                  _currVariation,
                                                              title: Text(
                                                                "${t.name}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                style: CustomTextStyle
                                                                    .textFormFieldMedium
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                              ),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _currVariation =
                                                                      val;
                                                                  ProductShow[
                                                                          'unit_price'] =
                                                                      t.price;
                                                                });
                                                              },
                                                              activeColor:
                                                                  Colors.black,
                                                              secondary:
                                                                  OutlineButton(
                                                                child: Text(
                                                                    currency +
                                                                        t.price),
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                            ))
                                                        .toList(),
                                                  ),
                                                )),
                                              ]),
_groupVariations.isEmpty?Container():SizedBox(height: 5,),
                    _groupOptions.isEmpty?Container():Column(children: <Widget>[
                      Container(
                        child:
                        ListTile(title:
                        Text(
                          'Options',
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          maxLines: 2,
                          style:CustomTextStyle.textFormFieldMedium.copyWith(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        ),),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15,),
                          child: Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: _groupOptions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CheckboxListTile(
                                    title: Text(
                                        _groupOptions[index].name,
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                      maxLines: 2,
                                      style:CustomTextStyle.textFormFieldMedium.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    subtitle: Text(
                                        '\$'+ _groupOptions[index].price,
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                      maxLines: 2,
                                      style:CustomTextStyle.textFormFieldMedium.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    value: _selecteCategorys
                                        .contains(_groupOptions[index].id),
                                    onChanged: (bool selected) {
                                      _onCategorySelected(selected,
                                          _groupOptions[index].id, _groupOptions[index]);
                                    },
                                  );
                                }),
                          )),
                    ],)
                                  ],
                                    ),
                                  ),
                                ),
                              ])),
                      Positioned(
                        top: 32,
                        right: 20,
                        child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ShoppingCartFloatButtonWidget(
                              iconColor: Theme.of(context).primaryColor,
                              labelColor: Theme.of(context).hintColor,
                            ) 
                            ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 88,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, -2),
                                    blurRadius: 5.0)
                              ]),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                // Row(
                                //   children: <Widget>[
                                //     Expanded(
                                //       child: Text(
                                //         'Quantity',
                                //         style: Theme.of(context).textTheme.subtitle1,
                                //       ),
                                //     ),

                                //   ],
                                // ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (widget.productData.in_stock) {
                                                if (_quantity == 1) return;
                                                _quantity -= 1;
                                                widget.productData.qty =
                                                    _quantity;
                                              }
                                            });
                                          },
                                          iconSize: 30,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          color: Colors.white,
                                        ),
                                        Text(_quantity.toString(),
                                            style:
                                                TextStyle(color: Colors.black)),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (widget.productData.in_stock) {
                                                if ((widget.productData
                                                            .stock_count -
                                                        _quantity) ==
                                                    0) {
                                                  _showToastStock(context);
                                                } else {
                                                  _quantity += 1;
                                                  widget.productData.qty =
                                                      _quantity;
                                                }
                                              }
                                            });
                                          },
                                          iconSize: 30,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          icon: Icon(Icons.add_circle_outline),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Stack(
                                      fit: StackFit.loose,
                                      alignment: AlignmentDirectional.centerEnd,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              160,
                                          child: FlatButton(
                                            onPressed: () {
                                              if ((ProductShow['stock_count'] -
                                                      _quantity) ==
                                                  0) {
                                                _showToastStock(context);
                                              } else {
                                                _showalert();
                                                int total = 0;
                                                selecteOptions.forEach(
                                                    (element) => total =
                                                        (total +
                                                            int.parse(element
                                                                .price)));
                                                model.addProduct(
                                                    ProductShow['id'],
                                                    ProductShow['name'],
                                                    (total +
                                                            int.parse(ProductShow[
                                                                'unit_price']))
                                                        .toDouble(),
                                                    _quantity,
                                                    widget.productData.imgUrl,
                                                    _currVariation,
                                                    selecteOptions,
                                                    widget.shop);
                                              }
                                            },
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            color: Colors.white,
                                            shape: StadiumBorder(),
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                'Add to Cart',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]);
                    //         return Column(
                    //         children: <Widget>[
                    //           Expanded(
                    //               child:
                    //               Container(
                    //               child:
                    //                 ListView(
                    //                 children: <Widget>[
                    //                       imageCarousel,
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 25),
                    //                     child: Row(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: <Widget>[
                    //                         Expanded(
                    //                           child:
                    //                           Text(
                    //                             ProductShow['name'],
                    //                             overflow: TextOverflow.fade,
                    //                             softWrap: true,
                    //                             maxLines: 2,
                    //                             style:CustomTextStyle.textFormFieldMedium.copyWith(
                    //                                 color: Colors.black54,
                    //                                 fontSize: 22,
                    //                                 fontWeight: FontWeight.bold
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 5),
                    //                     child: Row(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: <Widget>[
                    //                         Expanded(
                    //                           child:
                    //                           Text(
                    //                             'Price '+ currency + ProductShow['unit_price'].toString(),
                    //                             overflow: TextOverflow.fade,
                    //                             softWrap: true,
                    //                             maxLines: 2,
                    //                             style:CustomTextStyle.textFormFieldMedium.copyWith(
                    //                                 color: Colors.white,
                    //                                 fontSize: 18,
                    //                                 fontWeight: FontWeight.bold
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),

                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    //                     child: Text(
                    //                       ProductShow['description'] !=null? ProductShow['description']:'',
                    //                       overflow: TextOverflow.fade,
                    //                       style:CustomTextStyle.textFormFieldMedium.copyWith(
                    //                           color: Colors.black54,
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.bold
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   _groupVariations.isEmpty?Container():Column(children: <Widget>[
                    //                   Container(
                    //                     child:
                    //                   ListTile(title:
                    //                   Text(
                    //                     'Variation',
                    //                     overflow: TextOverflow.fade,
                    //                     softWrap: true,
                    //                     maxLines: 2,
                    //                     style:CustomTextStyle.textFormFieldMedium.copyWith(
                    //                         color: Colors.black,
                    //                         fontSize: 18,
                    //                         fontWeight: FontWeight.bold
                    //                     ),
                    //                   ),
                    //                   ),),
                    //                   Container(
                    //                           child: Container(
                    //                             child: Column(
                    //                               children: _groupVariations
                    //                                   .map((t) =>  RadioListTile(
                    //                                 value: t.id,
                    //                                 groupValue: _currVariation,
                    //                                 title: Text(
                    //                                     "${t.name}",
                    //                                   overflow: TextOverflow.fade,
                    //                                   softWrap: true,
                    //                                   maxLines: 1,
                    //                                   style:CustomTextStyle.textFormFieldMedium.copyWith(
                    //                                       color: Colors.black,
                    //                                       fontSize: 16,
                    //                                       fontWeight: FontWeight.normal
                    //                                   ),
                    //                                 ),
                    //                                 onChanged: (val) {
                    //                                   setState(() {
                    //                                     _currVariation = val;
                    //                                     ProductShow['unit_price'] = t.price;
                    //                                   });
                    //                                 },
                    //                                 activeColor: Colors.red,
                    //                                 secondary: OutlineButton(
                    //                                   child: Text(currency + t.price),
                    //                                   onPressed: () {},
                    //                                 ),
                    //                               )).toList(),
                    //                             ),
                    //                           )),
                    //                   ]),
                    //                   _groupVariations.isEmpty?Container():SizedBox(height: 5,),
                                   
                    //           Expanded(
                    //             child:
                    //             Container(
                    //               width: double.infinity,
                    //               margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    //               child: widget.productData.in_stock == false?Container():
                    //                   Container(
                    //                     child:
                    //                     Row(
                    //                       mainAxisAlignment: MainAxisAlignment.center,
                    //                       crossAxisAlignment: CrossAxisAlignment.center,
                    //                       children: <Widget>[
                    //                         Container(
                    //                           width: 55,
                    //                           height: 40,
                    //                           child: OutlineButton(
                    //                             onPressed: () {
                    //                               setState(() {
                    //                                 if( widget.productData.in_stock){
                    //                                   if(_quantity == 1) return;
                    //                                   _quantity -= 1;
                    //                                   widget.productData.qty =_quantity;
                    //                                 }

                    //                               });
                    //                             },
                    //                             child: Icon(Icons.remove),
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           margin:
                    //                           EdgeInsets.only(left: 20, right: 20),
                    //                           child: Text(_quantity.toString(), style: h3),
                    //                         ),
                    //                         Container(
                    //                           width: 55,
                    //                           height: 40,
                    //                           child: OutlineButton(
                    //                             onPressed: () {
                    //                               setState(() {
                    //                                 if( widget.productData.in_stock) {
                    //                                   if((widget.productData.stock_count -_quantity) == 0){
                    //                                     _showToastStock(context);
                    //                                   }else{
                    //                                     _quantity += 1;
                    //                                     widget.productData.qty = _quantity;
                    //                                   }
                    //                                 }
                    //                               });
                    //                             },
                    //                             child: Icon(Icons.add),
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           width: 180,
                    //                           height: 45,
                    //                           margin:
                    //                           EdgeInsets.only(left: 20,),
                    //                           child: froyoFlatBtn('Add to Cart', (){
                    //                             if((ProductShow['stock_count']-_quantity)== 0){
                    //                               _showToastStock(context);
                    //                             }else{
                    //                               int total=0;
                    //                               selecteOptions.forEach((element) =>  total = (total + int.parse(element.price)));
                    //                               model.addProduct(ProductShow['id'],ProductShow['name'],(total+ int.parse(ProductShow['unit_price'])).toDouble(),_quantity,widget.productData.imgUrl, _currVariation,selecteOptions,widget.shop);
                    //                             }
                    //                           }),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   )
                    //             ),
                    //             flex: 10,
                    //           )
                    //         ],
                    //       );
                    // })
                  })));
  }
}
