import 'package:flutter/material.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class NotificationDetailsPage extends StatefulWidget {
  static String tag = 'NotificationDetailsPage';
  final String title;
  final String description;
  final String date;

  NotificationDetailsPage({Key key, @required this.title, @required this.description, @required this.date}) : super(key: key);
  //NotificationDetailsPage({Key key, @required this.mobile}) : super(key: key);

  @override
  _NotificationDetailsPageState createState() => new _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 231, 231, 1),
      appBar: new DnaAppBar().getAppBar(context, 'Notifications'),
      bottomNavigationBar: DnaBottomNavigationBar().getNavBar(context),
      drawer: DnaDrawer().getDrawer(context),
      body: new Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Card(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      color: Color.fromRGBO(245, 206, 8, 1),
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(widget.title.substring(0,1).toUpperCase()),
                      )
                    ),
                    title: Text(widget.title),
                    subtitle: Text(widget.date),
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5,right: 5),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(widget.description),
                )
                
              ],
            ),
          ),
      )
      )
    );
  }
}