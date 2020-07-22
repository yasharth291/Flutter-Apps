import 'package:flutter/material.dart';

import 'CartSummaryPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'OrderSummaryPage.dart';

class OrderHistoryPage extends StatefulWidget {
  static String tag = "OrderHistory";

  @override
  OrderHistoryPageState createState() => new OrderHistoryPageState();
}

class OrderHistoryPageState extends State<OrderHistoryPage> {

  Map orderData;
  List orderHistory;
  List productDetails;
  int customerId;
  int partnerId;

  Future<List> getData() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId');

    var orderHistoryURL = "";
    var partnerURL = "";
    orderHistoryURL = "http://admin.dailyneedapps.com/api/orderhistory/${customerId}";
    //partnerURL = "http://admin.dailyneedapps.com/api/orderhistory/${[orderHistory][partner_id]}";

    response = await http.get(orderHistoryURL);

    orderData = convert.jsonDecode(response.body);

    orderHistory = orderData['orders'];

    print(orderHistoryURL);
      //orderHistory = orderData['orders'];
    print('I am in Order History');
    print(orderHistory);
    print('here is length');
    print(orderHistory.length);

    return orderHistory;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 231, 231, 1),
      appBar: new DnaAppBar().getAppBar(context, "Order History"),
      bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
      drawer: new DnaDrawer().getDrawer(context),
      body: new Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(232, 231, 231, 1),
        ),
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: orderHistory.length == null ? 0 :orderHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                      print(orderHistory[index]["main_order_id"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryPage(
                            orderId: orderHistory[index]["id"],
                          ),
                        )
                      );
                    },
                    child: SingleProduct(
                    titleText:
                      "# ${orderHistory[index]["id"]} # ${orderHistory[index]["items"]} items",
                      subtitleText: "Gross Total: ${orderHistory[index]["amount"]}",
                    ),
                  );
                  
                },
              );
            }
            else if (snapshot.hasError) {
                return Text("${snapshot.error}");
            }
            return Center(
                child:CircularProgressIndicator()
            );
          }
        )
      )
    );
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
    return new Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Card(
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
                      fontWeight: FontWeight.w300,
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
          )
        );
  }
}
