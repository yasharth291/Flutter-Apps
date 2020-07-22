import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class OrderSummaryPage extends StatefulWidget {
  static String tag = "OrderSummary";
  final int orderId;

  OrderSummaryPage({Key key, @required this.orderId}) : super(key: key);

  @override
  _OrderSummaryPageState createState() => new _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  Map orderData;
  Map orderDetailsData;
  List orderHistory;
  Map orderHistoryDetails;
  List productDetails;
  var total;
  int customerId;
  bool showCancelOrder = false;

  double rating = 1.5;
  int starCount = 5;

  Future<Map> getData() async {
    http.Response response;
    http.Response responseDetails;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId');

    var orderHistoryURL = "";
    var orderDetailsURL = "";
    //orderHistoryURL = "http://admin.dailyneedapps.com/api/orderhistory/${customerId}";
    orderDetailsURL =
        "http://admin.dailyneedapps.com/api/orderhistorydetails/${widget.orderId}";
    print(orderDetailsURL);
    //response = await http.get(orderHistoryURL);
    responseDetails = await http.get(orderDetailsURL);

    //orderData = convert.jsonDecode(response.body);
    orderDetailsData = convert.jsonDecode(responseDetails.body);

    /*setState(() {
      //orderHistory = orderData['orders'];
      orderHistoryDetails = orderDetailsData['order'];
      productDetails = orderDetailsData['orderDetails'];

      //print(orderData);
      //print(orderHistory.length);
    });*/

    return orderDetailsData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(232, 231, 231, 1),
        appBar: new DnaAppBar().getAppBar(context, "Order Summary"),
        bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
        drawer: new DnaDrawer().getDrawer(context),
        body: SingleChildScrollView(
            child: Container(
                decoration: new BoxDecoration(
                  color: Color.fromRGBO(232, 231, 231, 1),
                ),
                //child: SingleChildScrollView(
                child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        showCancelOrder = snapshot.data["showCancelOrder"];
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              //Column(
                              //children: <Widget>[
                              InkWell(
                                onTap: () {
                                  _showProductDetails(
                                      context, snapshot.data["orderDetails"]);
                                },
                                child: SingleProduct(
                                  titleText:
                                      "Products # ${snapshot.data["order"]["id"]} # ${snapshot.data["order"]["items"]} items",
                                  subtitleText:
                                      "Gross Total: ${snapshot.data["order"]["amount"]}",
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  _showOrderDeliveryStatus(
                                      context, snapshot.data["order"]);
                                },
                                child: SingleProduct(
                                  titleText:
                                      "${snapshot.data["order"]["request_status"]}",
                                  subtitleText: "2:30 PM - 3:15 PM : 45 Mins",
                                ),
                              ),

                              InkWell(
                                /*onTap: (){
                                _showProductDetails(context);
                              },*/
                                child: SingleProduct(
                                  titleText:
                                      "Payment Method # Total Paid ${snapshot.data["order"]["amount"]}",
                                  subtitleText:
                                      "${snapshot.data["order"]["payment_mode"]}",
                                ),
                              ),
                              InkWell(
                                /* onTap: (){
                                _showProductDetails(context);
                              },*/
                                child: SingleProduct(
                                  titleText: "Address",
                                  subtitleText:
                                      "${snapshot.data["order"]["delivery_address"]}",
                                ),
                              ),
                              Card(
                                child: Padding(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Rating",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87),
                                        textAlign: TextAlign.justify,
                                      ),
                                      new StarRating(
                                        size: 30.0,
                                        rating: rating,
                                        color: Colors.black,
                                        borderColor: Colors.grey,
                                        starCount: starCount,
                                        onRatingChanged: (rating) => setState(
                                          () {
                                            this.rating = rating;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                              ),
//                  (showCancelOrder == false)?Container():Padding(
//                            padding: EdgeInsets.only(left:80, right:80, top:10, bottom:50),
//                            child: Center(
//                              child: RaisedButton(
//                        onPressed: () {
//                          http.post('http://admin.dailyneedapps.com/api/order/cancel', body: {
//                            'order_id': "${snapshot.data["order"]["id"]}",
//                          }).then((http.Response response){
//                              print("Response body: ${response.body}");
//                              var jsonResponse = convert.jsonDecode(response.body);
//                              if(jsonResponse['success'] == true) {
//                                setState(){
//                                  showCancelOrder = false;
//                                }
//                                showDialog(
//                                context: context,
//                                builder: (context) {
//                                  return AlertDialog(
//                                    title: Text("Success"),
//                                    content: Text('Your order is cancelled'),
//                                  );
//                                });
//                              } else {
//                                showDialog(
//                                context: context,
//                                builder: (context) {
//                                  return AlertDialog(
//                                    title: Text("Error"),
//                                    content: Text('Something went wrong'),
//                                  );
//                                });
//                              // Find the Scaffold in the Widget tree and use it to show a SnackBar!
//
//                              }
//                          });
//                        },
//                        textColor: Colors.black,
//                        padding: const EdgeInsets.all(0.0),
//                        child: Container(
//                            width: 200,
//                            height: 50,
//                            decoration: const BoxDecoration(
//                              color: const Color(0xFFd92d2d),
//                            ),
//                            padding: const EdgeInsets.all(0),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text("Cancel Order", style: TextStyle(fontSize: 15, color: Colors.white), )
//                              ],
//                            )
//                        )
//
//                    ),
//                            ),
//                          )

                              //],
                              //),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner
                      return Center(child: CircularProgressIndicator());
                    }))));
  }

  void _showProductDetails(context, productDetails) {
    print(productDetails);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildcontext) {
          return Container(
              //child:Container
              //children: <Widget>[
              child: ListView.builder(
                  itemCount: productDetails == null ? 0 : productDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BottomSheetProducts(
                      productTitle: "${productDetails[index]["title"]}",
                      price: "${productDetails[index]["price"]}",
                      itemCount: "${productDetails[index]["quantity"]}",
                      grossTotal: "${productDetails[index]["total"]}",
                    );
                  })
              //],
              //),
              //),
              );
        });
  }

  void _showOrderDeliveryStatus(context, orderHistoryDetails) {
    print(
        'Date time pf order ===========> ${orderHistoryDetails["updated_at"]}');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildcontext) {
          return Container(
              padding: EdgeInsets.all(10),

              //child: SingleChildScrollView(
              child: Column(children: [
                Card(
                    child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Order Delivery Status',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    "${orderHistoryDetails["request_status"]}: ",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black54),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${orderHistoryDetails["updated_at"]}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black54),
                                    ),
                                  )
                                ],
                              ),
                            ]))),
                SizedBox(
                  child: Image.asset(
                    'assets/images/13B-map.png',
                    fit: BoxFit.fitWidth,
                  ),
                )
              ]));
        });
  }
}

class SingleProduct extends StatelessWidget {
  final orderId;
  final itemCount;
  final grossTotal;
  final orderStatus;
  final time;
  final paymentMethod;
  final address;
  final titleText;
  final subtitleText;

  SingleProduct({
    this.orderId,
    this.itemCount,
    this.orderStatus,
    this.grossTotal,
    this.time,
    this.paymentMethod,
    this.address,
    this.titleText,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return new Card(
        elevation: 6.0,
        color: Colors.black38,
        child: new Material(
          //child:Card(
          child: ListTile(
              title: Text(
                //"Products # $orderId # $itemCount items",
                titleText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
              subtitle: Text(
                  //"Gross Total: $grossTotal",
                  subtitleText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  )),
              leading: SizedBox(
                height: 60,
                width: 60,
                child: Card(
                    color: Color.fromRGBO(239, 224, 0, 1),
                    child: Center(
                      child: Text(
                        "D",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
              ),
              trailing: Icon(
                Icons.navigate_next,
                size: 30,
              )),
        )
        //)
        );
  }
}

//All product details
class BottomSheetProducts extends StatelessWidget {
  final image;
  final productTitle;
  final itemCount;
  final grossTotal;
  final price;
  final titleText;
  final subtitleText;

  BottomSheetProducts({
    this.image,
    this.productTitle,
    this.itemCount,
    this.price,
    this.grossTotal,
    this.titleText,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                elevation: 6,
                //child: Image.asset('assets/images/gallery_img.png', fit: BoxFit.fill,),
                child: Center(
                  child: Text(
                    productTitle.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: Color.fromRGBO(244, 176, 0, 1), fontSize: 35),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    productTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Price - $price Rs.",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Quantity - ${itemCount} ",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Gross Total - $grossTotal Rs.",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        )

        //)

        );
  }
}
