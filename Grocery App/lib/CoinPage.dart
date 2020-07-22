import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class CoinPage extends StatefulWidget {
  static String tag = 'CoinPage';

  @override
  _CoinPageState createState() => new _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  Map data;
  List userData;
  List categoryData;
  List imageArr;
  int medicalId;
  int customerId;

  @override
  void initState() {
    super.initState();
  }

  Future<Map> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt("customerId");
    http.Response response = await http
        .get('http://admin.dailyneedapps.com/api/coin/logs/${customerId}');
    data = convert.jsonDecode(response.body);
    print(data);

    return data;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 231, 231, 1),
      appBar: new DnaAppBar().getAppBar(context, 'Notifications'),
      bottomNavigationBar: DnaBottomNavigationBar().getNavBar(context),
      drawer: DnaDrawer().getDrawer(context),
      body: new Container(
          child: FutureBuilder<Map>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    snapshot.data["logs"] == null ||
                    snapshot.data["logs"].length == 0)
                  return Center(child: Text("No data found"));

                if (snapshot.hasData) {
                  return Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                            child: Column(
                              children: <Widget>[
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data["logs"].length,
                                  itemBuilder: (context, index) {
                                    List dateStr = snapshot.data["logs"][index]
                                            ["created_at"]
                                        .substring(0, 10)
                                        .split("-");
                                    String orderDate =
                                        "${dateStr[2]}/${dateStr[1]}/${dateStr[0]}";
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20, top: 20),
                                                child: Row(children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      "${orderDate}",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  Text(
                                                    "#${snapshot.data["logs"][index]["order_id"]}",
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ])),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20, right: 20),
                                              child: Text(
                                                "${snapshot.data["logs"][index]["amount"]} Rs",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Balance - ${snapshot.data["coinAmount"]["amount"]}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return Center(child: CircularProgressIndicator());
              })),
    );
  }
}
