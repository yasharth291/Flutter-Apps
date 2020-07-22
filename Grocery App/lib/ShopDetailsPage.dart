import 'dart:async';
import 'dart:convert' as convert;

import 'package:Demo_app_grocery/shared/DnaDrawer.dart';
import 'package:Demo_app_grocery/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smiley_rating_dialog/smiley_rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'PartnerGallaryPage.dart';
import 'ProductCategoryPage.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';

class ShopDetailsPage extends StatefulWidget {
  static String tag = "ShopDetails";

  final shopId;
  final shopName;
  final shopAddress;
  final shopIcon;

  ShopDetailsPage({
    Key key,
    @required this.shopId,
    @required this.shopName,
    @required this.shopAddress,
    @required this.shopIcon,
  }) : super(key: key);

  @override
  _ShopDetailsPageState createState() => new _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  Map data;
  Map userData;
  List galleryData;
  List userSubCatData;
  List imageArr;
  String availability;
  bool _isFavorited = true;
  String favoriteText = "Add to Favorite";
  var imageLike;
  String contactNumber;
  static String launchUrl;
  int customerId;
  String mobile;
  String remainingTime;

  //Star count vars
  double rating = 0;
  int starCount = 5;
  double shopRating = 0;
  bool visibilityAvailable = false;
  bool visibilityGallery = false;
  bool visibilityCart = true;
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  Future<Map> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt("customerId");
    mobile = prefs.getString("mobile");
    http.Response response;
    var categoryURL = "";
    print(widget.shopId);
    categoryURL =
        "http://admin.dailyneedapps.com/api/shopdetails/${widget.shopId}/${customerId}";

    print(categoryURL);

    response = await http.get(categoryURL);

    data = convert.jsonDecode(response.body);
    print("favourite: ${data['isFavorite']}");
    //setState(() {
    userData = data['partner'];
    galleryData = data['partnerGallery'];

    DateTime now = DateTime.now();
    String formatDay = DateFormat('EEEE').format(now);

    if (data['availability'].isEmpty) {
      availability = "";
    } else {
      availability = data['availability'][formatDay];
      remainingTime = data['remainingTime'];
      visibilityAvailable = true;
    }
    print("=============>${data["enableCart"]}===============");

    if (data["enableCart"] == true) {
      visibilityCart = true;
    }

    if (!galleryData.isEmpty) {
      visibilityGallery = true;
    }

    contactNumber = data['partner']['contact_number'];
    launchUrl = "tel://${contactNumber}";

    _isFavorited = data['isFavorite'];
    if (_isFavorited) {
      favoriteText = "Remove from Favorite";
    }
    print(contactNumber);
    //availability = data['availability'];
    //print(userData);
    //print(galleryData);
    //print(availability["Monday"]);

    print(formatDay);
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    print(formattedDate);

    //});
    return userData;
  }

  Future getRating() async {
    var ratingURL =
        "http://admin.dailyneedapps.com/api/getrating/${widget.shopId}";

    http.Response response;
    response = await http.get(ratingURL);

    data = convert.jsonDecode(response.body);
    print(data);
    setState(() {
      this.rating = double.parse(data['rating'].toString());
      print(this.rating);
    });
  }

  void setFavourite(isFavourite) async {
    http.Response response;

    if (isFavourite) {
      print('add to favorite');
      http.post('http://admin.dailyneedapps.com/api/favorites', body: {
        'customerId': "${customerId}",
        'mobile': "${mobile}",
        'partner_id': "${widget.shopId}"
      }).then((http.Response response) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
      });
    } else {
      print('remove to favorite');
      http.post('http://admin.dailyneedapps.com/api/deletefavorite', body: {
        'customerId': "${customerId}",
        'mobile': "${mobile}",
        'partner_id': "${widget.shopId}"
      }).then((http.Response response) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
      });
    }

    //response = await http.get(categoryURL);
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
        favoriteText = "Add to Favorite";
      } else {
        _isFavorited = true;
        favoriteText = "Remove from Favorite";
      }

      setFavourite(_isFavorited);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
    getRating();
  }

  final firstSection = Container(
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black12),
          color: Colors.white),
      child: new ListTile(
        title: Image.asset("assets/images/icons/icon_like_added.png"),
        subtitle: Text(
          "Added to favorites",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));

  final secondSection = Container(
     // width: 105,
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black12),
          color: const Color(0xFFd92d2d)),
      child: new ListTile(
        title: Image.asset("assets/images/icons/icon_oniline_order.png"),
        subtitle: Text(
          "Order now",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ));

  final thirdSection = Container(child: Text("text"));

  final forthSection = Container(
    //width: 80,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(width: 0.5, color: Colors.black12),
    ),
    padding: EdgeInsets.only(top: 15),
    /*child: new Center(
              child: new FlatButton(
                onPressed: ()=> UrlLauncher.launch("tel://919096395839"),
                child: Text("Call Now", textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
              ),
            )*/
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: new Center(
            child: new FlatButton(
              onPressed: () {
                UrlLauncher.launch(launchUrl);
              },
              child: Image.asset("assets/images/icons/icon_call_now.png"),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Text(
            "Call Now",
            style: TextStyle(fontSize: 14),
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    //print(widget);
    print("${widget.shopName}");
    if (data == null) {
      return Scaffold(
        appBar: DnaAppBar().getAppBar(context, "Products"),
      );
    } else {
      return Scaffold(
          backgroundColor: Color.fromRGBO(232, 231, 231, 1),
          appBar: new DnaAppBar().getAppBar(context, "${widget.shopName}"),
          bottomNavigationBar: new DnaBottomNavigationBar().getNavBar(context),
          drawer: new DnaDrawer().getDrawer(context),
          body: new Container(
            decoration:
                new BoxDecoration(color: Color.fromRGBO(232, 231, 231, 1)),
            child: SingleChildScrollView(
                child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      ListTile(
                          title: Text("${widget.shopName}",
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text("${snapshot.data["address"]}"),
                          leading: Image.network(
                            "http://admin.dailyneedapps.com/storage/partner/${snapshot.data["image"]}",
                            width: 60,
                            height: 80,
                          )),

                      Container(
                        height: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: visibilityCart ? 4 : 3,
                              child: new ListTile(
                                title: IconButton(
                                  icon: (_isFavorited
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border)),
                                  color: Colors.red[500],
                                  onPressed: _toggleFavorite,
                                ),
                                subtitle: Text(
                                  favoriteText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                //alignment: Alignment(2, 0),
                              ),
                            ),
                            visibilityCart
                                ? Expanded(
                                    flex: 4,
                                    child: InkWell(
                                      onTap: () {
                                        print(widget.shopId+"***");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductCategoryPage(
                                                partnerId: widget.shopId,
                                              ),
                                            ));
                                      },
                                      child: secondSection,
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              flex: visibilityCart ? 4 : 3,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black12),
                                  ),
                                  padding: EdgeInsets.only(top: 10),
                                  child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (context) =>
                                                SmileyRatingDialog(
                                                  title: Text('Rate Shop'),
                                                  starColor: Colors.red,
                                                  isRoundedButtons: true,
                                                  positiveButtonText: 'Ok',
                                                  negativeButtonText: 'Cancel',
                                                  positiveButtonColor:
                                                      Colors.amber,
                                                  negativeButtonColor:
                                                      Colors.amber,
                                                  onCancelPressed: () =>
                                                      Navigator.pop(context),
                                                  onSubmitPressed: (val) {
                                                    Utility.isInternetAvailable()
                                                        .then((isConnected) {
                                                      if (isConnected) {
                                                        var shopRating = val;
                                                        http.post(
                                                            'http://admin.dailyneedapps.com/api/saverating',
                                                            body: {
                                                              'customer_id':
                                                                  '${this.customerId}',
                                                              'partner_id':
                                                                  '${widget.shopId}',
                                                              'rating':
                                                                  '${shopRating}',
                                                            }).then(
                                                            (http.Response
                                                                response) {
                                                          var jsonResponse =
                                                              convert.jsonDecode(
                                                                  response
                                                                      .body);
                                                          print(jsonResponse[
                                                              'partnerRating']);
                                                          var partnerRating =
                                                              double.parse(
                                                                  '${jsonResponse['partnerRating']}');
                                                          setState(() {
                                                            this.rating =
                                                                partnerRating;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } else {
                                                        Utility.showToast(
                                                            'please check your internet connection',
                                                            context);
                                                        return;
                                                      }
                                                    });
                                                    /*setState(() {
                                      this.rating = 5;
                                    });*/
                                                  },
                                                ));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "Rating",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0.5,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${this.rating} Ratings',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w200,
                                                letterSpacing: 0.5,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: StarRating(
                                              size: 12.0,
                                              rating: this.rating,
                                              color: Colors.black,
                                              borderColor: Colors.grey,
                                              starCount: 5,
                                            ),
                                          ),
                                        ],
                                      ))),
                            ),
                            Expanded(
                              flex: visibilityCart ? 4 : 3,
                              child: forthSection,
                            ),
                          ],
                        ),
                        color: Colors.white,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 0.5, color: Colors.black12),
                            color: Colors.white),
                        child: new ListTile(
                          title: Text('Description',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(snapshot.data["description"] != null &&
                                  snapshot.data["description"].length > 0
                              ? "${snapshot.data["description"]}"
                              : "No description found"),
                        ),
                      ),
                      //if (galleryData != null) {
                      visibilityGallery
                          ? ListTile(
                              title: Text('Gallery',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              trailing: MaterialButton(
                                  child: new Text("Click to View All"),
                                  color: Colors.white,
                                  textColor: Colors.black54,
                                  onPressed: () {
                                    print('tapped: ${widget.shopId}');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PartnerGallaryPage(
                                            partnerId: widget.shopId,
                                          ),
                                        ));
                                    /*var route=new MaterialPageRoute(

                      builder: (BuildContext context)=> new ProductCategoryPage(
                        partnerId: "${widget.shopId}",
                       // partnerName: "${widget.shopName}",
                      )
                  );
                  Navigator.of(context).push(route);*/
                                  }),
                            )
                          : Container(),
                      visibilityGallery
                          ? Row(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  decoration: new BoxDecoration(
                                      color: Color.fromRGBO(232, 231, 231, 1)),
                                  child: GridView.builder(
                                    itemCount: galleryData == null
                                        ? 0
                                        : ((galleryData.length > 3)
                                            ? 3
                                            : galleryData.length),
                                    gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new SingleProduct(
                                        prod_image:
                                            "http://admin.dailyneedapps.com/storage/gallary/${galleryData[index]["photo"]}",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      visibilityAvailable
                          ? Row(children: <Widget>[
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    height: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.black12),
                                        color: Colors.white),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Store Availability',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black45),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "Today ${availability}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black26,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            (remainingTime == '')
                                                ? ''
                                                : "Hurry!!Store will be closed in ${remainingTime}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.red,
                                              // fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  return showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Wrap(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 40, top: 20),
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text("Store Availability",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                Text("Monday"),
                                                          ),
                                                          Text(
                                                              "${data['availability']['Monday']}")
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                Text("Tuesday"),
                                                          ),
                                                          Text(
                                                              "${data['availability']['Tuesday']}")
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 100,
                                                            child: Text(
                                                                "Wednesday"),
                                                          ),
                                                          Text(
                                                              "${data['availability']['Wednesday']}")
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 100,
                                                            child: Text(
                                                                "Thursday"),
                                                          ),
                                                          Text(
                                                              "${data['availability']['Thursday']}")
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                Text("Friday"),
                                                          ),
                                                          Text(
                                                              "${data['availability']['Friday']}")
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 100,
                                                            child: Text(
                                                                "Saturday"),
                                                          ),
                                                          Text(
                                                              "${data['availability']['Saturday']}")
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, bottom: 30),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                Text("Sunday"),
                                                          ),
                                                          Text(
                                                              "${data['availability']['Sunday']}")
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(19, 40, 20, 20),
                                  width: 110,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5, color: Colors.black12),
                                      color: Color.fromRGBO(241, 189, 0, 100)),
                                  child: Text(
                                    "All Days >",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ])
                          : Container(),
                      /*ListTile(
                    title: Text('Favorite Products',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset('assets/images/favorite-1.png'),
                      ),
                      Expanded(
                        child: Image.asset('assets/images/favorite-2.png'),
                      ),
                    ],
                  ),*/
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return Center(child: CircularProgressIndicator());
              },
            )),
          ));
    }
  }

  Widget _buildRatingDialog(BuildContext context) {
    var shopRating = 0.0;
    return new AlertDialog(
      title: const Text('Rate Shop'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*StarRating(
            size: 30.0,
            rating: this.shopRating,
            color: Colors.black,
            borderColor: Colors.grey,
            starCount: starCount,
            onRatingChanged: (rating) {
              print(rating);
              setState(() {
                this.shopRating = rating;
                print("shop rating");
                print(this.shopRating);
              });
            }
            ),*/
          SmoothStarRating(
              allowHalfRating: false,
              onRatingChanged: (v) {
                setState(() {
                  shopRating = v;
                });
              },
              starCount: 5,
              rating: shopRating,
              size: 40.0,
              color: Colors.green,
              borderColor: Colors.green,
              spacing: 0.0)
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class SingleProduct extends StatelessWidget {
  final prod_image;
  final shopId;
  final shopName;

  SingleProduct({this.prod_image, this.shopId, this.shopName});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: new Card(
        elevation: 6.0,
        color: Colors.black38,
        child: new Hero(
          tag: prod_image,
          child: new Material(
            child: new InkWell(
                //padding: const EdgeInsets.all(1.0),
                onTap: () {
                  print('tapped');
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new ProductCategoryPage(
                            //partnerName: shopName,
                            //productImage: prod_image,
                            partnerId: shopId,
                          ));
                  Navigator.of(context).push(route);
                },
                child: new ListTile(
                  title: new Image.network(
                    prod_image,
                    fit: BoxFit.fill,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
