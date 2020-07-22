//import 'dart:async';
 
import 'package:Demo_app_grocery/CoinPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'LoginPage.dart';
import 'OtpPage.dart';
import 'ProfilePage.dart';
import 'DashboardPage.dart';
import 'DirectoryPage.dart';
import 'CategoryPage.dart';
import 'TestPage.dart';
import 'CartSummaryPage.dart';
import 'InvitePage.dart';
import 'OrderSummaryPage.dart';
import 'NotificationsPage.dart';
import 'ProductDetailsPage.dart';
import 'OrderHistoryPage.dart';
import 'OffersPage.dart';
import 'CoinPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}


class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    OtpPage.tag: (context) => OtpPage(),
    ProfilePage.tag: (context) => ProfilePage(),
    DashboardPage.tag: (context) => DashboardPage(),
    DirectoryPage.tag: (context) => DirectoryPage(),
    CartSummaryPage.tag: (context) => CartSummaryPage(),
    OrderSummaryPage.tag: (context) => OrderSummaryPage(),
    ProductDetailsPage.tag: (context) => ProductDetailsPage(),
    OrderHistoryPage.tag: (context) => OrderHistoryPage(),
    OffersPage.tag: (context) => OffersPage(),
    NotificationsPage.tag: (context) => NotificationsPage(),
    CoinPage.tag: (context) => CoinPage()
  };

  Widget build(BuildContext context) {
    return MaterialApp(
      /* home: Scaffold(
        backgroundColor: Color.fromRGBO(231, 230, 230, 100),
        body: MyCustomForm(),
      ),*/
      theme: ThemeData(fontFamily: 'Roboto'),
      home: DashboardPage(),
      routes: routes,
    );
  }
}

/*
class MyCustomForm extends StatefulWidget {

  MyCustomContainerFormState createState() {
    return MyCustomContainerFormState();
  }  
}

class MyCustomFormState extends State<MyCustomForm> {

  final _formKey =GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please Enter Mobile No';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data'),
                    )
                  );
                }
              },
              child: Text('Proceed'),
            )
          )
        ],
      ),
    );
  }
}

class MyCustomContainerFormState extends State<MyCustomForm> {

  final _formKey =GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Color.fromRGBO(231, 230, 230, 100),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 400.0,
            maxWidth: 300.0,
            minHeight: 200.0,
            minWidth: 200.0
          ),
          margin: new EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 50.0
          ),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white30,
          )
        ),
      ),
    );
  }
} */
