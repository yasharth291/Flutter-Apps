import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'CategoryPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'ProductListPage.dart';
import 'ProductsPage.dart';


class PartnerGallaryPage extends StatefulWidget {

  static String tag = "ProductGallery";

  final partnerId;
  
  PartnerGallaryPage({Key key, 
    @required this.partnerId,
  }) : super(key :key);

  @override
  PartnerGallaryPageState createState() => new PartnerGallaryPageState();
}

class PartnerGallaryPageState extends State<PartnerGallaryPage>{

  Map data;
  List userData;
  List galleryData;

  Future<List> getData() async {
    http.Response response;
    var categoryURL = "";
    categoryURL = "http://admin.dailyneedapps.com/api/shopdetails/${widget.partnerId}";
    print(categoryURL);
    response = await http.get(categoryURL);
    
    data = json.decode(response.body);
    print(data['partnerGallery']);
    setState(() {
      userData = data['partnerGallery'];
      print("Partner Gallery here: ");
      print(userData);
    });
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
      appBar: new DnaAppBar().getAppBar(context, "Product Gallery"),
      bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
      drawer: new DnaDrawer().getDrawer(context),
      body: new Container(
        decoration: new BoxDecoration(color: Color.fromRGBO(232, 231, 231, 1)),
        child: new GridView.builder(
          itemCount: userData == null ? 0 :userData.length,
          gridDelegate: 
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return new SingleProduct(
              //productCategoryId: userData[index]["catid"],
              prod_image: "http://admin.dailyneedapps.com/storage/gallary/${userData[index]["photo"]}",
              //productCategoryName: "${userData[index]["title"]}",
              //partnerId :widget.partnerId,
              //type: userData[index]['type'] 
            );
          },
        )
      )
    );
  }
}

class SingleProduct extends StatelessWidget {

  final prod_image;
  //final productCategoryName;
  //final productCategoryId;
  //final proCatObject;
  final partnerId;
  //final type;
  //final showPartnerValue;

  SingleProduct({
    this.prod_image,
   // this.productCategoryName,
    //this.productCategoryId,
    //this.proCatObject,
    this.partnerId,
   // this.type,
  });

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left:5.0,top: 5.0),
      child: new Card(
        elevation:6.0 ,
        color:Colors.tealAccent ,
        child: new Material(
              child: new InkWell(
                //padding: const EdgeInsets.all(1.0),
                onTap: (){
                },
                child: new GridTile(
                  child: new Padding(
                      padding: const EdgeInsets.all(1.0) ,
                      child: new Image.network(
                      prod_image,
                      fit: BoxFit.cover,
                      )
                  ),
                ),
                ),
              ),
            ),
      );
  }
}
