import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DashboardProduct.dart';
import 'shared/DnaDrawer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'ShopDetailsPage.dart';

class InvitePage extends StatefulWidget {
  
  static String tag = 'Dashboard';
  @override
  _InvitePageState createState() => new _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new DnaAppBar().getAppBar(context, 'Invite'),
      bottomNavigationBar: DnaBottomNavigationBar().getNavBar(context),
      drawer: DnaDrawer().getDrawer(context),
      body: new Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: new  LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
              colors: [const Color.fromRGBO(87, 136, 127, 1), const Color.fromRGBO(73, 172, 217, 1)], // whitish to gray
              tileMode: TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          height: (MediaQuery.of(context).size.height - (120)) / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Invite friends to DNA and Get Rs 100", style: TextStyle(fontSize: 21, color: Color.fromRGBO(245, 250, 251, 1)),),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 20),
                        child: Text("When they register.", style: TextStyle(fontSize: 21, color: Color.fromRGBO(245, 250, 251, 1)),)
                      ,),
                      Text("Share the code", style: TextStyle(fontSize: 30, color: Color.fromRGBO(245, 250, 251, 1)),),
                      /*Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: new SizedBox(
                          width: 250.0,
                          height: 45.0,
                          child: ListTile(
                            title: Card(
                              child: Text("This is test"),
                            ),
                            trailing: Image.asset("assets/images/icon_send.png"),
                          ),
                        ),
                      )*/
                      Padding(
                        padding: EdgeInsets.only(top:40),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 200,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white  
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("ABCD", style: TextStyle(
                                fontSize: 20
                              ),),
                            ),
                          ),
                          Image.asset("assets/images/icon_send.png")
                        ],
                      ),
                      ),
                      
                      
                    ],
                  ),
                  alignment: Alignment(0.0, 0.0),
                ),
                
              )
              
            ],
          ),
        )
      ],
    )
    );
  }

}