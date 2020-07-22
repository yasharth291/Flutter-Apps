import 'dart:async';
import 'dart:convert' as convert;

import 'package:badges/badges.dart';
import 'package:Demo_app_grocery/util/util.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CartSummaryPage.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';
import 'shared/SingleItem.dart';

class ProductsPage extends StatefulWidget {
  static String tag = "ProductList";

  final categoryId;
  final proCatObject;
  final partnerId;
  final type;

  ProductsPage({
    Key key,
    @required this.categoryId,
    @required this.proCatObject,
    @required this.partnerId,
    @required this.type,
  }) : super(key: key);

  @override
  ProductsPageState createState() => new ProductsPageState();
}

class ProductsPageState extends State<ProductsPage>
    with TickerProviderStateMixin {
  Map data;
  Map data2;
  List userData;
  List productList;
  List<Tab> tabs;
  List<Tab> userTabs;
  int customerId;
  String mobile;
  String dropdownValue = '1 Quantity';
  int quantity = 1;
  int cartCounter = 0;
  int _offerValue = 0;

  TabController _cardController;

  TabPageSelector _tabPageSelector;

  Future<List> getData() async {
    http.Response response;
    http.Response responseSub;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId');
    print("customerId ---- ");
    print(customerId);
    mobile = prefs.getString('mobile');
    cartCounter = prefs.getInt("cartCounter");

    var categoryURL = "";
    if (widget.type == "sub") {
      categoryURL =
          "http://admin.dailyneedapps.com/api/productsubcategory/${widget.categoryId}/${widget.partnerId}";
      print(categoryURL);
      response = await http.get(categoryURL);

      data = convert.jsonDecode(response.body);
      setState(() {
        userData = data['subcategories'];
        //print("User Data is:");
        //print(userData);
        print("Product list Data is:");
        print(productList);

        List<Tab> tabs = new List();
        // Assuming titles and icons have the same length
        for (int i = 0; i < userData.length; i++) {
          tabs.add(Tab(
            text: userData[i]["subcategory_name"],
          ));
        }
        print(tabs);
        userTabs = tabs;
      });
    } else {}
  }

  Future<List> getProducts() async {
    http.Response responseSub;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt("customerId");
    print(customerId);
    var url =
        "http://admin.dailyneedapps.com/api/productlist/${widget.partnerId}/${widget.categoryId}/main/${customerId}";

    print(url);
    responseSub = await http.get(url);

    var productObj = convert.jsonDecode(responseSub.body);
    productList = productObj['products'];

    return productList;
  }

  setCartCounter(cartCounter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("cartCounter", cartCounter);
    print(prefs.getInt("cartCounter"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: userData == null ? 1 : userData.length,
            child: Scaffold(
                backgroundColor: Color.fromRGBO(232, 231, 231, 1),
                //appBar: DnaAppBar().getAppBar(context, "Products"),
                appBar: GradientAppBar(
                  iconTheme: new IconThemeData(color: Colors.black),
                  title: Text("Products"),
                  backgroundColorStart: Colors.white,
                  backgroundColorEnd: Colors.white,
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.search), tooltip: 'Search'),
                    /*IconButton(
                        icon: Icon(Icons.shopping_cart),
                        tooltip: 'Shopping Cart',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartSummaryPage()),
                          );
                        },
                      ),*/
                    BadgeIconButton(
                        itemCount: cartCounter == null ? 0 : cartCounter,
                        badgeColor: Colors.red,
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartSummaryPage()),
                          );
                        }),
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      tooltip: 'Favourite',
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_none),
                      tooltip: 'Favourite',
                    ),
                  ],
                ),
                bottomNavigationBar:
                    DnaBottomNavigationBar().getNavBar(context),
                drawer: DnaDrawer().getDrawer(context),
                body: new Container(
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(232, 231, 231, 1)),
                    child: FutureBuilder<List>(
                      future: getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                              decoration: new BoxDecoration(
                                  color: Color.fromRGBO(232, 231, 231, 1)),
                              child: new GridView.builder(
                                itemCount: snapshot.data.length,
                                // == null ? 0 :productList[mainIndex].length,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  print(snapshot.data[index]);
                                  return InkWell(
                                      onTap: () {
                                        /*AddToCartSheet().getBottomSheet(
                                              context, 
                                              snapshot.data[index], 
                                              mobile, 
                                              customerId,
                                              );*/

                                        /*AddToCartSheet().getBottomSheet(
                                              context,
                                              snapshot.data[index],
                                              mobile,
                                              customerId,
                                            );**/

                                        quantity = 1;
                                        dropdownValue = '1 Quantity';
                                        return showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return Container(
                                                  child: Wrap(
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                ),
                                                                elevation: 6,
                                                                //child: Image.asset('assets/images/gallery_img.png', fit: BoxFit.fill,),
                                                                child: (snapshot.data[index]
                                                                            [
                                                                            "image"] ==
                                                                        null)
                                                                    ? Center(
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data[index]["title"]
                                                                              .substring(0, 1)
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(244, 176, 0, 1),
                                                                              fontSize: 35),
                                                                        ),
                                                                      )
                                                                    : Image
                                                                        .network(
                                                                        "http://admin.dailyneedapps.com/storage/product/${snapshot.data[index]["image"]}",
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 10,
                                                                        left:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width /
                                                                              2 -
                                                                          20,
                                                                      child:
                                                                          Text(
                                                                        snapshot.data[index]
                                                                            [
                                                                            "title"],
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          "${snapshot.data[index]["weight"]} ${snapshot.data[index]["weight_note"]}",
                                                                          style:
                                                                              TextStyle(fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          "Price ${snapshot.data[index]["total"]} Rs.",
                                                                          style:
                                                                              TextStyle(fontSize: 18),
                                                                        ),
                                                                      ],
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              //changeQuantity("remove");
                                                                              if (quantity != 1) {
                                                                                setState(() {
                                                                                  quantity--;
                                                                                });
                                                                              }
                                                                              print(quantity);
                                                                            },
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/minus.jpg",
                                                                              width: 30,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                29,
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFcccccc), width: 1), bottom: BorderSide(color: Color(0xFFcccccc), width: 1))),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "${quantity} Quantity",
                                                                                  style: TextStyle(fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              //changeQuantity("add");
                                                                              setState(() {
                                                                                quantity++;
                                                                              });

                                                                              print(quantity);
                                                                            },
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/plus.jpg",
                                                                              width: 32,
                                                                              height: 33,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                        ],

                                                                        /*Image.asset(name),
                                                                              Image.asset(name),
                                                                              Image.asset(name),*/
                                                                      ),
                                                                    ),
                                                                    (snapshot.data[index]["offer"].length >
                                                                            0)
                                                                        ? Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              SizedBox(
                                                                                height: 140,
                                                                                width: 180,
                                                                                child: Column(
                                                                                  children: <Widget>[
                                                                                    ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: snapshot.data[index]["offer"].length,
                                                                                        itemBuilder: (BuildContext context, int ofrIdx) {
                                                                                          return Row(children: <Widget>[
                                                                                            Radio(
                                                                                              groupValue: _offerValue,
                                                                                              value: snapshot.data[index]["offer"][ofrIdx]["id"],
                                                                                              onChanged: (value) {
                                                                                                setState(() {
                                                                                                  _offerValue = value;
                                                                                                  print(_offerValue);
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                            Text("${snapshot.data[index]["offer"][ofrIdx]["name"]}"),
                                                                                          ]);
                                                                                        }),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Container()
                                                                    /*Padding(
                                                                            padding: EdgeInsets.only(top:15, left:0),
                                                                            child: DropdownButton<String>(
                                                                            value: dropdownValue,
                                                                            onChanged: (String newValue) {
                                                                                print('test');
                                                                                print(newValue);

                                                                                setState((){
                                                                                  dropdownValue = newValue;
                                                                                });

                                                                              },
                                                                              items: <String>['1 Quantity', '2 Quantity', '3 Quantity', '4 Quantity']
                                                                                .map<DropdownMenuItem<String>>((String value) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: value,
                                                                                    child: Text(value),
                                                                                  );
                                                                                })
                                                                                .toList(),
                                                                            ),
                                                                          )*/
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 80,
                                                                right: 80,
                                                                top: 50,
                                                                bottom: 50),
                                                        child: Center(
                                                          child: RaisedButton(
                                                              onPressed: () {
                                                                print(snapshot
                                                                        .data[
                                                                    index]['id']);
                                                                print(mobile);
                                                                print(
                                                                    customerId);
                                                                print(dropdownValue
                                                                    .substring(
                                                                        0, 1));
                                                                /*var quantity = dropdownValue.substring(0,1);

                                                                        if(quantity == 0 || quantity == null || quantity == '') {
                                                                          quantity = "1";
                                                                        }*/
                                                                var offer = '';
                                                                if (_offerValue !=
                                                                    0) {
                                                                  offer = _offerValue
                                                                      .toString();
                                                                }

                                                                Utility.isInternetAvailable()
                                                                    .then(
                                                                        (isConnected) {
                                                                  if (isConnected) {
                                                                    http.post(
                                                                        'http://admin.dailyneedapps.com/api/addtocart',
                                                                        body: {
                                                                          "mobile":
                                                                              "${mobile}",
                                                                          "customerId":
                                                                              "${customerId}",
                                                                          "quantity":
                                                                              "${quantity}",
                                                                          "productId":
                                                                              "${snapshot.data[index]["id"]}",
                                                                          "offerId":
                                                                              "${offer}"
                                                                        }).then(
                                                                        (http.Response
                                                                            response) {
                                                                      print(
                                                                          "Response body: ${response.body}");
                                                                      var jsonResponse =
                                                                          convert
                                                                              .jsonDecode(response.body);
                                                                      if (jsonResponse[
                                                                              'success'] ==
                                                                          true) {
                                                                        print(
                                                                            "i am here");
                                                                        setState(
                                                                            () {
                                                                          //cartCounter++;
                                                                          cartCounter =
                                                                              jsonResponse["cartCount"];
                                                                          setCartCounter(
                                                                              cartCounter);
                                                                        });
                                                                      }
                                                                    });

                                                                    Navigator.pop(
                                                                        context);
                                                                  } else {
                                                                    Utility.showToast(
                                                                        'please check your internet connection',
                                                                        context);
                                                                    return;
                                                                  }
                                                                });
                                                              },
                                                              textColor:
                                                                  Colors.white,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0.0),
                                                              child: Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            244,
                                                                            176,
                                                                            8,
                                                                            1),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          20.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(Icons
                                                                          .add_shopping_cart),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        "Add to Cart",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      )
                                                                    ],
                                                                  ))),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ));
                                            });
                                      },
                                      child: SingleItem(
                                        productCategoryId:
                                            "${snapshot.data[index]["id"]}",
                                        prod_image:
                                            "${snapshot.data[index]["image"]}",
                                        productCategoryName:
                                            "${snapshot.data[index]["title"]}",
                                        product: snapshot.data[index],
                                      ));

                                  //return Card(
                                  //  child: ,
                                  //);
                                },
                              ));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    )))));
  }
}
