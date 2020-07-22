import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'PartnerListPage.dart';
import 'ShopDetailsPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class SubCategoryPage extends StatefulWidget {
  static String tag = 'Category';

  final categoryId;
  final categoryName;
  final categoryImage;
  final showPartner;
  //final subCategoryId;

  SubCategoryPage({
    Key key,
    @required this.categoryName,
    @required this.categoryImage,
    @required this.categoryId,
    @required this.showPartner,
    //@required this.subCategoryId,
  }) : super(key: key);

  @override
  _SubCategoryPageState createState() => new _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  Map data;
  List userData;
  List userSubCatData;
  List imageArr;
  Map subCategoryData;

  final mainImage = Image.asset(
    'assets/images/promo.png',
    fit: BoxFit.cover,
  );

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
    http.Response response;
    var categoryURL = "";

    categoryURL =
        "http://admin.dailyneedapps.com/api/subcategories/${widget.categoryId}";
    print(categoryURL);
    response = await http.get(categoryURL);

    data = json.decode(response.body);
    print(data);
    setState(() {
      userData = data['subcategories'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    imageArr = [new ExactAssetImage('assets/images/banner1.jpeg')];
    super.initState();
    getData();
    print("subcategory page");
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
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  new GridView.builder(
                    itemCount: userData == null ? 0 : userData.length,
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      if (userData[index]["showPartner"] == 'true') {
                        print("--in--");
                        return new SingleProduct(
                            partnerId: "${userData[index]["id"]}",
                            prod_image:
                                "http://admin.dailyneedapps.com/storage/partner/${userData[index]["image"]}",
                            partnerName: "${userData[index]["shop_name"]}",
                            address: "${userData[index]["address"]}",
                            showPartner: "${userData[index]["showPartner"]}");
                      } else {
                        print("--else--");
                        return new SingleProduct(
                            partnerId: "${userData[index]["id"]}",
                            prod_image:
                                "http://admin.dailyneedapps.com/storage/subcategory/${userData[index]["icon"]}",
                            partnerName: "${userData[index]["name"]}",
                            showPartner: "${userData[index]["showPartner"]}");
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
    return new Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
      child: new Card(
        elevation: 6.0,
        color: Colors.tealAccent,
        child: new Hero(
          tag: prod_image,
          child: new Material(
            child: new InkWell(
                onTap: () {
                  print("subcatgory");
                  //print('tapped');
                  print(showPartner);
                  if (showPartner == 'true') {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new PartnerListPage(
                              categoryName: partnerName,
                              categoryImage: prod_image,
                              categoryId: partnerId,
                              showPartner: showPartner,
                            ));
                    Navigator.of(context).push(route);
                  } else {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new ShopDetailsPage(
                              shopName: partnerName,
                              shopAddress: address,
                              shopId: partnerId,
                              shopIcon: prod_image,
                            ));
                    Navigator.of(context).push(route);
                  }
                },
                child: new ListTile(
                  /* title: new Image.network(
                    prod_image,
                    fit: BoxFit.cover,
                      ),*/
                  title: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(prod_image),
                  ),
                  /*subtitle: new Container(
                      alignment: Alignment.center,
                      child: new Text(partnerName, style: new TextStyle(color: Colors.redAccent, fontSize: 14.0),),
                    ),*/
                  subtitle: new Text(
                    partnerName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
