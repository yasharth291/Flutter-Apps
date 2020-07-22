import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class OffersPage extends StatefulWidget {
  static String tag = "Offers";

  @override
  OffersPageState createState() => new OffersPageState();
}

class OffersPageState extends State<OffersPage> {
  Map offerData;
  Map offers;
  int customerId;

  Future<Map> getData() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId');

    var offersURL = "";
    offersURL = "http://admin.dailyneedapps.com/api/offers/${customerId}";
    //partnerURL = "http://admin.dailyneedapps.com/api/orderhistory/${[orderHistory][partner_id]}";

    response = await http.get(offersURL);

    offerData = convert.jsonDecode(response.body);

    offers = offerData['offers'];

    print(offersURL);
    //orderHistory = orderData['orders'];
    print('I am in Offers');
    print(offers);
    print('here is length');
    print(offers.length);

    return offers;
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
        appBar: new DnaAppBar().getAppBar(context, "Offers"),
        bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
        drawer: new DnaDrawer().getDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Center(
              child: Text(
            "Great offers will be update soon",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )

              /*decoration: new BoxDecoration(
            color: Color.fromRGBO(232, 231, 231, 1),
          ),
          child: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(index);
                    print(snapshot.data);
                    return SingleProduct(
                  titleText:
                    "# ${offers[index]["id"]} # ${offers[index]["name"]} items",
                  subtitleText: "Gross Total: ${offers[index]["offer_type"]}",
                  );
                  },
                );
              }

              return Center(
                  child:CircularProgressIndicator()
              );
            }
          )*/
              ),
        ));
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
        child: new Card(
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
            ));
  }
}
