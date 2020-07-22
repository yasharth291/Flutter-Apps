import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'PartnerListPage.dart';
import 'SubCategoryPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class CategoryPage extends StatefulWidget {
  static String tag = 'Category';

  final categoryId;
  final categoryName;
  final categoryImage;
  final showPartner;
  //final subCategoryId;

  CategoryPage({
    Key key,
    @required this.categoryName,
    @required this.categoryImage,
    @required this.categoryId,
    @required this.showPartner,
    //@required this.subCategoryId,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => new _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Map data = new Map();
  List userData;
  List userSubCatData;
  List imageArr;
  Map subCategoryData = new Map();

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
    if (data == null) data = new Map();

    setState(() {
      if (data.isNotEmpty) subCategoryData = data['subcategories'];
    });
  }

  Future<List> getData() async {
    isCallingAPI = true;

    http.Response response;
    var categoryURL = "";
    if (widget.showPartner == 'true') {
      categoryURL =
          "http://admin.dailyneedapps.com/api/partners/category/${widget.categoryId}";
    } else {
      categoryURL =
          "http://admin.dailyneedapps.com/api/subcategories/${widget.categoryId}";
    }

    print(categoryURL);

    response = await http.get(categoryURL);

    data = json.decode(response.body);
    setState(() {
      if (widget.showPartner == 'true') {
        userData = data['partners'];
      } else {
        userData = data['subcategories'];
      }
    });
    isCallingAPI = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    imageArr = [new ExactAssetImage('assets/images/banner1.jpeg')];
    super.initState();
    getData();
    print("category page");
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
          padding: EdgeInsets.all(3),
          decoration:
              new BoxDecoration(color: Color.fromRGBO(232, 231, 231, 1)),
          child: ((userData == null || userData.length == 0) && !isCallingAPI)
              ? Center(child: Text("No category found"))
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
                            print(widget.showPartner);
                            if (widget.showPartner == true) {
                              print("--in--");
                              return new SingleProduct(
                                  partnerId: "${userData[index]["id"]}",
                                  prod_image:
                                      "http://admin.dailyneedapps.com/storage/partner/${userData[index]["image"]}",
                                  partnerName:
                                      "${userData[index]["shop_name"]}",
                                  address: "${userData[index]["address"]}",
                                  showPartner:
                                      "${userData[index]["showPartner"]}");
                            } else {
                              print("--else--");
                              return new SingleProduct(
                                  partnerId: "${userData[index]["id"]}",
                                  prod_image:
                                      "http://admin.dailyneedapps.com/storage/subcategory/${userData[index]["icon"]}",
                                  partnerName: "${userData[index]["name"]}",
                                  showPartner:
                                      "${userData[index]["showPartner"]}");
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

class SingleProduct extends StatelessWidget {
  final prod_image;
  final partnerName;
  final partnerId;
  final address;
  final showPartner;

  SingleProduct(
      {this.prod_image,
      this.partnerName,
      this.partnerId,
      this.address,
      this.showPartner});

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 6.0,
      margin: EdgeInsets.all(3),
      color: Colors.white,
      child: new InkWell(
          onTap: () {
            //print('tapped');
            print('here--showpaster');
            print(showPartner);
            if (showPartner == 'true') {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new PartnerListPage(
                      categoryName: partnerName,
                      categoryImage: prod_image,
                      categoryId: partnerId,
                      showPartner: showPartner,
                      type: "subcategory"));
              Navigator.of(context).push(route);
            } else {
              print("subcategory");
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new SubCategoryPage(
                        categoryName: partnerName,
                        categoryImage: prod_image,
                        categoryId: partnerId,
                        showPartner: showPartner,
                      ));
              Navigator.of(context).push(route);
            }
          },
          child: new ListTile(
            /* title: new Image.network(
              prod_image,
              fit: BoxFit.cover,
                ),*/
            /*title: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(prod_image),
              ),*/
            title: new Image.network(prod_image, width: 50, height: 50),
            /*subtitle: new Container(
                alignment: Alignment.center,
                child: new Text(partnerName, style: new TextStyle(color: Colors.redAccent, fontSize: 14.0),),
              ),*/
            subtitle: new Text(
              partnerName,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
