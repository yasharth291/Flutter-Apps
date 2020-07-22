import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'NotificationsDetailsPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class NotificationsPage extends StatefulWidget {
  static String tag = 'NotificationsPage';

  //NotificationsPage({Key key, @required this.mobile}) : super(key: key);

  @override
  _NotificationsPageState createState() => new _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Map data;
  List userData;
  List categoryData;
  List imageArr;
  int medicalId;
  int customerId;

  /*Future<Post> fetchPost() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }*/

  @override
  void initState() {
    super.initState();
    //post = fetchPost();
  }

  Future<List> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt("customerId");
    http.Response response = await http
        .get('http://admin.dailyneedapps.com/api/notifications/${customerId}');
    //debugPrint(response.body);
    data = convert.jsonDecode(response.body);

    userData = data['notifications'];
    //categoryData = data['categories'];

    /*imageArr = new List.generate(
        userData.length, (i) {
          return new NetworkImage("http://admin.dailyneedapps.com/storage/banner/${userData[i]["image"]}");
        }
      );*/

    /*for (var i = 0; i < categoryData.length; i++) {
        print(categoryData[i]['name']);
        if(categoryData[i]['name'] == "Medical") {
          medicalId = i;
        }
      }
    return imageArr;*/
    return userData;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(232, 231, 231, 1),
        appBar: new DnaAppBar().getAppBar(context, 'Notifications'),
        bottomNavigationBar: DnaBottomNavigationBar().getNavBar(context),
        drawer: DnaDrawer().getDrawer(context),
        body: new Container(
          child: FutureBuilder<List>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0)
                  return Center(child: Text("No notification availabel"));

                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      //var localDate = new DateFormat("dd/MM/yyyy").parse(snapshot.data[index]['created_at']);
                      //print(localDate);
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationDetailsPage(
                                      title: snapshot.data[index]['title'],
                                      description: snapshot.data[index]
                                          ['description'],
                                      date: snapshot.data[index]['created_at']),
                                ));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: ListTile(
                                    leading: Card(
                                        shape: BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        color: Color.fromRGBO(245, 206, 8, 1),
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Text(snapshot.data[index]
                                                  ['title']
                                              .substring(0, 1)
                                              .toUpperCase()),
                                        )),
                                    title: Text(snapshot.data[index]['title']),
                                    subtitle: Text(
                                        snapshot.data[index]['created_at']),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color.fromRGBO(96, 96, 96, 1),
                                    ))),
                          ));
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return Center(child: CircularProgressIndicator());
            },
          ),
          /*child: ListView.builder(
            itemCount: userData == null ? 1: userData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(10),
                child:Card(
                  child: ListTile(
                      leading: Image.asset("assets/images/logo.jpg", width: 50,),
                      title: Text("THis is test notification"),
                      subtitle: Text("This is date"),
                      trailing:  Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(96, 96, 96, 1),
                      )
                  )
                ),

              );
            },
        ),*/
        ));
  }
}
