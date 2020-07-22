import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CheckoutPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class CartSummaryPage extends StatefulWidget {
  static String tag = "CartSummary";

  @override
  _CartSummaryPageState createState() => new _CartSummaryPageState();
}

class _CartSummaryPageState extends State<CartSummaryPage> {
  Map data;
  Map prodData;
  List cartData;
  List productData;
  var total;
  int customerId;
  int counter;
  String mobile;

  Future<Map> getData() async {
    http.Response response;
    var categoryURL = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt("customerId");
    mobile = prefs.getString("mobile");
    counter = prefs.getInt("cartCounter");

    categoryURL =
        "http://admin.dailyneedapps.com/api/shoppingcart/${customerId}";
    response = await http.get(categoryURL);

    data = convert.jsonDecode(response.body);

    /*setState(() {
      cartData = data['shoppingCart'];
      productData = data['products'];
      total = "${data["total"]}";
      print(cartData);
      print("product Data is ---");
      print(productData);
      print("length product data");
      print(productData.length);
    });*/

    return data;
  }

  removeFromCart(item) {
    /*setState(() {
        productData.removeAt(item);
      });*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(232, 231, 231, 1),
        appBar: new DnaAppBar().getAppBar(context, "Cart Summary"),
        /*appBar: DnaAppBarWidget(
        title: Text('Cart Summary'),
      ),*/
        bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
        drawer: new DnaDrawer().getDrawer(context),
        body: new Container(
          decoration: new BoxDecoration(
            color: Color.fromRGBO(232, 231, 231, 1),
          ),
          child: Padding(
              padding: EdgeInsets.all(0),
              child: FutureBuilder<Map>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      productData = snapshot.data['products'];
                      if (productData.length == 0)
                        return Center(child: Text("No Product added in cart"));
                      cartData = snapshot.data['shoppingCart'];
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: new ListView.builder(
                                //padding: new EdgeInsets.symmetric(vertical: 8.0),
                                itemCount: productData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = productData[index];
                                  return InkWell(
                                    onTap: () {
                                      //removeFromCart(index);
                                    },
                                    child: SingleProduct(
                                        indexPointer: index,
                                        productName:
                                            "${productData[index]["title"]}",
                                        product: productData[index],
                                        price: "${productData[index]["price"]}",
                                        quantity: productData[index]
                                            ["quantity"],
                                        grossTotal:
                                            "${productData[index]["total"]}",
                                        CartSummary: this),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  height: 60,
                                  child: Card(
                                      //color: Color.fromRGBO(239, 224, 0, 1),
                                      child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(
                                        "Total - ${snapshot.data['total']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 70),
                                  child: SizedBox(
                                    height: 60,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutPage(),
                                            ));
                                      },
                                      child: Card(
                                          color: Color.fromRGBO(245, 206, 8, 1),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                "     Checkout     ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(child: CircularProgressIndicator());

                    // By default, show a loading spinner
                  })),
        ));
  }
}

class SingleProduct extends StatefulWidget {
  //static String tag = "CartSummary";
  final productName;
  final price;
  final quantity;
  final grossTotal;
  final total;
  final product;
  final indexPointer;
  final Function(int item) removeFromCart;
  _CartSummaryPageState CartSummary;

  SingleProduct(
      {this.productName,
      this.price,
      this.quantity,
      this.grossTotal,
      this.total,
      this.product,
      this.indexPointer,
      @required this.removeFromCart(item),
      this.CartSummary});

  //ChildWidget({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _SingleProductState createState() => new _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  int localQuantity;
  int totalPrice;

  changeQuantity(action) {
    print(action);
    var qty = 0;
    setState(() {
      if (action == 'add') {
        localQuantity++;
        qty = 1;
      } else {
        if (localQuantity != 1) {
          localQuantity--;
          qty = -1;
        } else {
          return;
        }
      }

      http.post('http://admin.dailyneedapps.com/api/addtocart', body: {
        "customerId": "${widget.CartSummary.customerId}",
        "mobile": "${widget.CartSummary.mobile}",
        "cartId": "${widget.CartSummary.cartData[widget.indexPointer]["id"]}",
        "productId":
            "${widget.CartSummary.productData[widget.indexPointer]["partner_product_id"]}",
        "quantity": "${qty}",
        "offerId": ""
      }).then((http.Response response) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['success'] == true) {
          widget.CartSummary.setState(() {
            //widget.CartSummary.productData.removeAt(widget.indexPointer);
            if (qty == 1) {
              widget.CartSummary.total = (int.parse(widget.CartSummary.total) +
                      widget.CartSummary.productData[widget.indexPointer]
                          ["total"])
                  .toString();
            } else {
              widget.CartSummary.total = (int.parse(widget.CartSummary.total) -
                      widget.CartSummary.productData[widget.indexPointer]
                          ["total"])
                  .toString();
            }
          });
        }
      });
    });
  }

  refresh(item) {
    setState(() {
      widget.product.removeAt(item);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      localQuantity = widget.quantity;
      print("=============>local quantity");
      print(localQuantity);
      print("========>product weight");
      print(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    //localQuantity = widget.quantity;
    return new Card(
      margin: EdgeInsets.all(5),
      elevation: 6.0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  decoration:
                      new BoxDecoration(color: Color.fromRGBO(245, 206, 8, 1)),
                  child: Center(
                    child: Text(
                      widget.productName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text(
                            widget.productName,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.product["total"]} Rs / ${(widget.product["weight"] == null) ? 1 : widget.product["weight"]} ${(widget.product["weight_note"] == null) ? "item" : widget.product["weight_note"]}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                changeQuantity("remove");
                              },
                              child: Image.asset("assets/images/minus.jpg"),
                            ),
                            SizedBox(
                              height: 44,
                              width: 120,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Color(0xFFcccccc), width: 1),
                                        bottom: BorderSide(
                                            color: Color(0xFFcccccc),
                                            width: 1))),
                                child: Center(
                                  child: Text(
                                    "${localQuantity} Quantity",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                changeQuantity("add");
                              },
                              child: Image.asset("assets/images/plus.jpg"),
                            ),
                          ],

                          /*Image.asset(name),
                                  Image.asset(name),
                                  Image.asset(name),*/
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Gross - ${getNumberFormate(widget.product["total"] * localQuantity)} / ${((widget.product["weight"] == null) ? 1 : widget.product["weight"]) * localQuantity} ${(widget.product["weight_note"] == null) ? "item" : widget.product["weight_note"]}",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: new Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  print(widget.CartSummary.cartData[widget.indexPointer]["id"]);
                  print(widget.CartSummary.customerId);
                  print(widget.CartSummary.mobile);
                  http.post('http://admin.dailyneedapps.com/api/removecart',
                      body: {
                        "customerId": "${widget.CartSummary.customerId}",
                        "mobile": "${widget..CartSummary.mobile}",
                        "cartId":
                            "${widget.CartSummary.cartData[widget.indexPointer]["id"]}"
                      }).then((http.Response response) {
                    var jsonResponse = convert.jsonDecode(response.body);
                    print(jsonResponse);
                    if (jsonResponse['success'] == true) {
                      widget.CartSummary.setState(() {
                        widget.CartSummary.productData
                            .removeAt(widget.indexPointer);
                        widget.CartSummary.total = jsonResponse["total"];
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getNumberFormate(var value) {
    final formatter = new NumberFormat("##.##");
    return formatter.format(value);
  }
}
