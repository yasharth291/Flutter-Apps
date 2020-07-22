import 'dart:async';
import 'dart:convert' as convert;

import 'package:Demo_app_grocery/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'OrderSummaryPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class CheckoutPage extends StatefulWidget {
  static String tag = 'Category';

  final categoryId;
  final categoryName;
  final categoryImage;
  final showPartner;

  //final subCategoryId;

  CheckoutPage({
    Key key,
    @required this.categoryName,
    @required this.categoryImage,
    @required this.categoryId,
    @required this.showPartner,
    //@required this.subCategoryId,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => new _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentValue = "cod";
  String _addressValue = "existing";
  int customerId;
  String mobile;
  String emailAddr;
  Map data;
  double total;
  String address = "";
  String fullname;
  String townshipId;
  final AddressController = TextEditingController();
  bool showAddressBox = false;
  static MethodChannel _channel = MethodChannel('easebuzz');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
  }

  void _handlePaymentValueChange(String value) {
    setState(() {
      _paymentValue = value;
    });
  }

  void _handleAddressValueChange(String value) {
    setState(() {
      _addressValue = value;
      if (_addressValue == 'new') {
        showAddressBox = true;
      } else {
        showAddressBox = false;
      }
    });
  }

  Future<Map> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt("customerId");
    mobile = prefs.getString("mobile");
    address = prefs.getString("address");
    townshipId = prefs.getString('townshipId');

    if (address == '') {
      _addressValue = "new";
      showAddressBox = true;
    }

    emailAddr = prefs.getString("email");
    if (emailAddr == '') {
      emailAddr = "test@dna.com";
    }
    fullname = prefs.getString("fullname");
    if (fullname == '') {
      fullname = "test user";
    }
    http.Response response = await http
        .get('http://admin.dailyneedapps.com/api/shoppingcart/${customerId}');
    data = convert.jsonDecode(response.body);
    print("===>townshipId");
    print(townshipId);
    print(data);
    setState() {
      total = data['total'] - data['coinAmount'];
      //_paymentValue = "new";
      //print(total);
    }

    return data;
  }

  Future<void> setCartCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("counter", 0);
  }

  Future<Map> payment(paymentData) async {
    String txnid =
        "${new DateTime.now().millisecondsSinceEpoch}"; //This txnid should be unique every time.
    String amount = "${paymentData['total'] - paymentData['coinAmount']}";

    //String amount = "1.0";
    String productinfo = "DNA Puchase order";
    String firstname = fullname;
    String email = emailAddr;
    String phone = mobile;
    String trxn_s_url = "";
    String trxn_f_url = "";
    String key = "JF3HC5M8P1";
    String udf1 = "";
    String udf2 = "";
    String udf3 = "";
    String udf4 = "";
    String udf5 = "";
    String address1 = "${(address == "") ? "address" : address}";
    String address2 = "";
    String city = "";
    String state = "";
    String country = "";
    String zipcode = "";
    String salt = "HPF1DB77G6";
    String pay_mode = "production";
    String unique_id = "${customerId}";
    Object parameters = {
      "txnid": txnid,
      "amount": amount,
      "productinfo": productinfo,
      "firstname": firstname,
      "email": email,
      "phone": phone,
      "trxn_s_url": trxn_s_url,
      "trxn_f_url": trxn_f_url,
      "key": key,
      "udf1": udf1,
      "udf2": udf2,
      "udf3": udf3,
      "udf4": udf4,
      "udf5": udf5,
      "address1": address1,
      "address2": address2,
      "city": city,
      "state": state,
      "country": country,
      "zipcode": zipcode,
      "salt": salt,
      "pay_mode": pay_mode,
      "unique_id": unique_id
    };
    print(parameters);
    final payment_response =
        await _channel.invokeMethod("payWithEasebuzz", parameters);
    print("=====>Response<======");
    print(payment_response);

    var paymentResponse =
        convert.jsonDecode(convert.jsonEncode(payment_response));
    print("====>result<====");
    print(paymentResponse["result"]);

    if (paymentResponse["result"] == "user_cancelled") {}

    /* payment_response is the HashMap containing the response of the payment.
                                              You can parse it accordingly to handle response */
    if (paymentResponse["result"] == "user_cancelled" ||
        paymentResponse["result"] == "payment_failed") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text('Payment failed. Please try again.'),
            );
          });
    } else if (paymentResponse["result"] == "payment_successfull") {
      http.post('http://admin.dailyneedapps.com/api/placeorder', body: {
        "mobile": "${mobile}",
        "customerId": "${customerId}",
        "paymentMode": _paymentValue,
        "paymentStatus": "success",
        "address": "${address}",
        "coinAmount": "${paymentData['coinAmount']}",
        "response": "${payment_response}",
        "townshipId": "${townshipId}"
      }).then((http.Response response) {
        print("Response body: ${response.body}");
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          print(jsonResponse['orders'][0]['id']);
          setCartCounter();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSummaryPage(
                  orderId: jsonResponse['orders'][0]['id'],
                ),
              ));
        }
      });
    }
    return payment_response;
  }

  @override
  Widget build(BuildContext context) {
    //print(widget);
    return Scaffold(
        backgroundColor: Color.fromRGBO(232, 231, 231, 1),
        appBar: new DnaAppBar().getAppBar(context, "Checkout"),
        bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
        drawer: new DnaDrawer().getDrawer(context),
        body: SingleChildScrollView(
            child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            //print(snapshot.data);
            if (snapshot.hasData) {
              return Container(
                  padding: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                      color: Color.fromRGBO(232, 231, 231, 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    decoration: new BoxDecoration(
                                        color: Color.fromRGBO(245, 206, 8, 1)),
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        "P",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 35),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Products",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Gross Total",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            Text(
                                              "${data["total"] - snapshot.data["deliveryCharges"]} Rs",
                                              style: TextStyle(fontSize: 17),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.grey,
                                )),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 85),
                                    child: Text(
                                      "Delivery Charges",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data["deliveryCharges"]} Rs",
                                    style: TextStyle(fontSize: 17),
                                    textAlign: TextAlign.right,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.grey,
                                )),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    decoration: new BoxDecoration(
                                        color: Color.fromRGBO(245, 206, 8, 1)),
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        "P",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 35),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "DNA Coin Balance",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${snapshot.data["coinAmount"]} Rs",
                                              style: TextStyle(fontSize: 17),
                                              textAlign: TextAlign.right,
                                            )
                                          ],
                                        ),
                                        Text(
                                          "Total Balance - ${snapshot.data["totalCoinAmount"]} Rs",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Text(
                                          "After Order - ${snapshot.data["totalCoinAmount"] - snapshot.data["coinAmount"]} Rs",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.grey,
                                )),
                            /*Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  decoration: new BoxDecoration(color: Color.fromRGBO(245, 206, 8, 1)),
                                  width: 60,
                                  height: 60,
                                  child: Center(
                                    child: Text("P", style: TextStyle(color: Colors.white, fontSize: 35),),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                                Text("Discount Coupon", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                                SizedBox(
                                                      width: 140,
                                                      child: Text("0 Rs", style: TextStyle(fontSize: 17), textAlign: TextAlign.right,),
                                                    )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                width: 220,
                                                padding: const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color.fromRGBO(213, 213, 213, 1)
                                                    ),
                                                ), //             <--- BoxDecoration here
                                                child: Text(
                                                  "Enter Coupon Code",
                                                  style: TextStyle(fontSize: 15.0),
                                                ),
                                            )
                                          ],
                                        ),
                                      ),
                                ],
                              )
                            ],
                          ),*/
                            /*Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                            child: Divider(),
                          ),*/
                            Container(
                              padding: EdgeInsets.only(bottom: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 80),
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data["total"] - snapshot.data["coinAmount"]} Rs",
                                    style: TextStyle(fontSize: 17),
                                    textAlign: TextAlign.right,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "Payment method",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              groupValue: _paymentValue,
                                              value: "online",
                                              onChanged:
                                                  _handlePaymentValueChange,
                                            ),
                                            Text(
                                                "Debit Card / Credit Card / Net Banking"),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              groupValue: _paymentValue,
                                              value: "cod",
                                              onChanged:
                                                  _handlePaymentValueChange,
                                            ),
                                            Text("Cash On Delivery"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 15),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "Address",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        (address == '')
                                            ? Container()
                                            : Row(
                                                children: <Widget>[
                                                  Radio(
                                                    groupValue: _addressValue,
                                                    value: "existing",
                                                    onChanged:
                                                        _handleAddressValueChange,
                                                  ),
                                                  Text("Current Location"),
                                                ],
                                              ),
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              groupValue: _addressValue,
                                              value: "new",
                                              onChanged:
                                                  _handleAddressValueChange,
                                            ),
                                            Text("Other Location"),
                                          ],
                                        ),
                                        showAddressBox
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5,
                                                        right: 5,
                                                        top: 10),
                                                    child: SizedBox(
                                                      width: 300,
                                                      height: 80,
                                                      child: TextField(
                                                        controller:
                                                            AddressController,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        key: new Key('address'),
                                                        cursorWidth: 0.5,
                                                        cursorColor:
                                                            Color.fromRGBO(165,
                                                                165, 165, 1),
                                                        decoration:
                                                            InputDecoration(
                                                                hintText:
                                                                    "Your Address",
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          0.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          0.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              //color: Color.fromRGBO(239, 224, 0, 1),
                              child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "Total - ${snapshot.data["total"] - snapshot.data["coinAmount"]}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          )),
                          InkWell(
                            onTap: () {
                              Utility.isInternetAvailable().then((isConnected) {
                                if (isConnected) {
                                  if (_addressValue == "new") {
                                    if (AddressController.text.trim() == "") {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Error"),
                                              content: Text(
                                                  'Please add your address'),
                                            );
                                          });
                                      return;
                                    }

                                    address = AddressController.text;
                                  }

                                  if (_paymentValue == "online") {
                                    var response = payment(snapshot.data);
                                    print("===>my === response<====");
                                    print(response);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: new Text("Order Confirmation"),
                                          content: new Text(
                                              "Do you wish to place the order?"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            //Here api call

                                            new FlatButton(
                                              child: new Text("cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
//                                                    Navigator.of(context).pop();
                                              },
                                            ),

                                            new FlatButton(
                                              child: new Text("ok"),
                                              onPressed: () {
                                                http.post(
                                                    'http://admin.dailyneedapps.com/api/placeorder',
                                                    body: {
                                                      "mobile": "${mobile}",
                                                      "customerId":
                                                          "${customerId}",
                                                      "paymentMode":
                                                          _paymentValue,
                                                      "paymentStatus":
                                                          "success",
                                                      "address": "${address}",
                                                      "coinAmount":
                                                          "${snapshot.data["coinAmount"]}",
                                                      "response": "",
                                                      "townshipId":
                                                          "${townshipId}",
                                                      "delivery_charges":
                                                          "${snapshot.data["deliveryCharges"]}"
                                                    }).then(
                                                    (http.Response response) {
                                                  //print("Response body: ${response.body}");
                                                  var jsonResponse =
                                                      convert.jsonDecode(
                                                          response.body);
                                                  if (jsonResponse['success'] ==
                                                      true) {
                                                    setCartCounter();
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderSummaryPage(
                                                            orderId:
                                                                jsonResponse[
                                                                        'orders']
                                                                    [0]['id'],
                                                          ),
                                                        ));
                                                    //print(jsonResponse['orders'][0]['id']);

                                                  }
                                                });

//                                                      Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        content: new Text(
                                            "Internet Is Not Available Please Check Your Internet Connection."),
                                        actions: <Widget>[
                                          // usually buttons at the bottom of the dialog
                                          new FlatButton(
                                            child: new Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  return;
                                }
                              });
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
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ],
                  ));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
        )));
  }
}
