import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';
import 'ProductCategoryPage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

class ProductDetailsPage extends StatefulWidget {
  
  static String tag = "ProductDetails";

_ProductDetailsPageState createState() => new _ProductDetailsPageState();

}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  @override
  Widget build(BuildContext context) {
    //print(widget);
    print("Product Summary");
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 231, 231, 1),
      appBar: new DnaAppBar().getAppBar(context, "Product Details"),
      bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
      drawer: new DnaDrawer().getDrawer(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: new Icon(Icons.add),
      )
    );
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildcontext){
          return Container(

            child: SingleChildScrollView(
          child:Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [ 
                Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      color: Color.fromRGBO(239, 224, 0, 1),
                      child:Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset('assets/images/favorite-1.png', width: 50, height: 50,)
                      )
                      //decoration: new BoxDecoration(color: Color.fromRGBO(239, 224, 0, 1)),
                      
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Text("Mixed Pasta",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 120,
                                child: Text("Price",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54
                                  ),
                                ),
                              ),
                              Text("Rs. 220",
                              style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54
                                  ),),
                            ],
                          ),
                          Divider(height: 10,color: Colors.black,),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 120,
                                child: Text("Quantity",
                                  style: TextStyle(
                                    fontSize: 18, color: Colors.black54
                                  ),
                                ),
                              ),
                              Text("2 Items",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54
                                  ),
                              ),
                            ],
                          ),
                        ]
                      )
                    )
                  ]
                )
              )
              ]
            )
          )            
          )
        );
      }
    );
  }
}