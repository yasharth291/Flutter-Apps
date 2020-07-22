import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'CategoryPage.dart';
import 'PartnerListPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';

class DirectoryPage extends StatefulWidget {
  static String tag = 'Directory';

  @override
  _DirectoryPageState createState() => new _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  Map data;
  List userData;
  List imageArr;

  Future<List> getData() async {
    http.Response response =
        await http.get('http://admin.dailyneedapps.com/api/categories');
    data = json.decode(response.body);
    setState(() {
      userData = data['categories'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    imageArr = [new ExactAssetImage('assets/images/banner1.jpeg')];
    super.initState();
    getData();
  }

  var directory_list = [
    {"image": "assets/images/restaurant.png"},
    {"image": "assets/images/vegetables.png"},
    {"image": "assets/images/grocery.png"},
    {"image": "assets/images/ non-veg.png"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(232, 231, 231, 1),
        appBar: new DnaAppBar().getAppBar(context, 'Directory'),
        bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
        body: new Container(
            decoration:
                new BoxDecoration(color: Color.fromRGBO(232, 231, 231, 1)),
            child: new GridView.builder(
              itemCount: userData == null ? 0 : userData.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return new SingleProduct(
                  directoryCategoryId: "${userData[index]["id"]}",
                  prod_image:
                      "http://admin.dailyneedapps.com/storage/category/${userData[index]["icon"]}",
                  directoryProductName: "${userData[index]["name"]}",
                  showPartnerValue: "${userData[index]["showPartner"]}",
                );
              },
            )));
  }
}

class SingleProduct extends StatelessWidget {
  final prod_image;
  final directoryProductName;
  final directoryCategoryId;
  final showPartnerValue;

  SingleProduct({
    this.prod_image,
    this.directoryProductName,
    this.directoryCategoryId,
    this.showPartnerValue,
  });

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
      child: new Card(
        elevation: 6.0,
        color: Colors.tealAccent,
        child: new Hero(
          tag: prod_image,
          child: new Material(
            child: new InkWell(
                //padding: const EdgeInsets.all(1.0),
                onTap: () {
                  print('tapped');
                  if (showPartnerValue == 'true') {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new PartnerListPage(
                            categoryName: directoryProductName,
                            categoryImage: prod_image,
                            categoryId: directoryCategoryId,
                            showPartner: showPartnerValue,
                            type: "category"));
                    Navigator.of(context).push(route);
                  } else {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new CategoryPage(
                              categoryName: directoryProductName,
                              categoryImage: prod_image,
                              categoryId: directoryCategoryId,
                              showPartner: showPartnerValue,
                            ));
                    Navigator.of(context).push(route);
                  }
                },
                child: new ListTile(
                  title: new Image.network(
                    prod_image,
                    fit: BoxFit.cover,
                  ),
                  /*subtitle: new Container(
                      alignment: Alignment.center,
                      child: new Text(prod_text, style: new TextStyle(color: Colors.redAccent, fontSize: 14.0),),
                    ),*/
                  subtitle: new Text(
                    directoryProductName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
