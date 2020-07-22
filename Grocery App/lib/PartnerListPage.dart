import 'dart:async';
import 'dart:convert';

import 'package:Demo_app_grocery/SingleProductView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class PartnerListPage extends StatefulWidget {
  static String tag = 'Category';

  final categoryId;
  final categoryName;
  final categoryImage;
  final showPartner;
  final type;
  //final subCategoryId;

  PartnerListPage(
      {Key key,
      @required this.categoryName,
      @required this.categoryImage,
      @required this.categoryId,
      @required this.showPartner,
      @required this.type
      //@required this.subCategoryId,
      })
      : super(key: key);

  @override
  _PartnerListPageState createState() => new _PartnerListPageState();
}

class _PartnerListPageState extends State<PartnerListPage> {
  Map data;
  List userData;
  List userSubCatData;
  List imageArr;
  Map subCategoryData;
  String townshipId;

  final mainImage = Image.asset(
    'assets/images/promo.png',
    fit: BoxFit.cover,
  );

  bool isCallingAPI = true;

  Future<List> getSubCategories() async {
    http.Response getsubcategories;
    getsubcategories = await http.get(
        "http://admin.dailyneedapps.com/api/subcategories/${widget.categoryId}");
    data = json.decode(getsubcategories.body);
    setState(() {
      subCategoryData = data['subcategories'];
    });
  }

  Future<List> getData() async {
    isCallingAPI = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    townshipId = prefs.getString('townshipId');
    http.Response response;
    var categoryURL = "";
    print("type:");
    print(widget.type);
    if (widget.type == 'subcategory') {
      categoryURL =
          "http://admin.dailyneedapps.com/api/partners/subcategory/${widget.categoryId}/$townshipId";
    } else {
      categoryURL =
          "http://admin.dailyneedapps.com/api/partners/category/${widget.categoryId}/$townshipId";
    }

    print(categoryURL);
    response = await http.get(categoryURL);

    data = json.decode(response.body);
//    data = new Map();

    setState(() {
      userData = data['partners'];
    });
    isCallingAPI = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    imageArr = [new ExactAssetImage('assets/images/banner1.jpeg')];
    super.initState();
    getData();
    print("partner list");
  }

  @override
  Widget build(BuildContext context) {
    //print(widget);
    return Scaffold(
        backgroundColor: Color.fromRGBO(232, 231, 231, 1),
        appBar: new DnaAppBar().getAppBar(context, "${widget.categoryName}"),
        bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
        drawer: new DnaDrawer().getDrawer(context),
        body: new Container(
          decoration:
              new BoxDecoration(color: Color.fromRGBO(232, 231, 231, 1)),
          child: ((userData == null || userData.length == 0) && !isCallingAPI)
              ? Center(child: Text("No partners found"))
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate([
                        new GridView.builder(
                          itemCount: userData == null ? 0 : userData.length,
                          primary: false,
                          shrinkWrap: true,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemBuilder: (BuildContext context, int index) {
                            if (widget.showPartner.toString() == 'true') {
                              return new SingleProductView(
                                partnerId: "${userData[index]["id"]}",
                                prod_image:
                                    "http://admin.dailyneedapps.com/storage/partner/${userData[index]["image"]}",
                                partnerName: "${userData[index]["shop_name"]}",
                                address: "${userData[index]["address"]}",
                              );
                            } else {
                              return new SingleProductView(
                                partnerId: "${userData[index]["id"]}",
                                prod_image:
                                    "http://admin.dailyneedapps.com/storage/subcategory/${userData[index]["icon"]}",
                                partnerName: "${userData[index]["name"]}",
                              );
                            }
                          },
                        ),
                      ]),
                    )
                  ],
                ),
        ));
  }
}
