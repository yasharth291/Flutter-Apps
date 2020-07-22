import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'ProductCategoryPage.dart';
import 'package:Demo_app_grocery/PartnerListPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import 'CategoryPage.dart';
import 'LoginPage.dart';
import 'OffersPage.dart';
import 'ShopDetailsPage.dart';
import 'SingleProductView.dart';
import 'shared/DashboardProduct.dart';
import 'shared/DnaAppBar.dart';
import 'shared/DnaBottomNavigationBar.dart';
import 'shared/DnaDrawer.dart';

class DashboardPage extends StatefulWidget {
  static String tag = 'Dashboard';

  @override
  _DashboardPageState createState() => new _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map data;
  List userData;
  List categoryData;
  List imageArr;
  int medicalId;
  bool isVerified;
  int currentCategoryId = 0;
  double width = 0;
  SharedPreferences prefs;
  var townshipId;

  Future<List> getData() async {
    prefs = await SharedPreferences.getInstance();
    getCartCount();
    townshipId = prefs.getString('townshipId');
    http.Response response = await http
        .get('http://admin.dailyneedapps.com/api/categories/${townshipId}');
    data = convert.jsonDecode(response.body);
    print(townshipId);
    townshipId = 3;
    userData = data['banners'];
    categoryData = data['categories'];

    isVerified = prefs.getBool("isVerified");
//    await getCategoryData(categoryData[10]);

    imageArr = new List.generate(userData.length, (i) {
      return new NetworkImage(
          "http://admin.dailyneedapps.com/storage/banner/${userData[i]["image"]}");
    });

    for (var i = 0; i < categoryData.length; i++) {
      print(categoryData[i]['name']);
      if (categoryData[i]['name'] == "Medical") {
        medicalId = i;
      }
    }
    categoryData[1]['homedata'] = await getCategoryData(categoryData[1]);
    categoryData[10]['homedata'] = await getCategoryData(categoryData[10]);
    categoryData[4]['homedata'] = await getCategoryData(categoryData[4]);
    categoryData[5]['homedata'] = await getCategoryData(categoryData[5]);
    categoryData[12]['homedata'] = await getCategoryData(categoryData[12]);
    categoryData[24]['homedata'] = await getCategoryData(categoryData[24]);
    categoryData[23]['homedata'] = await getCategoryData(categoryData[23]);
    categoryData[0]['homedata'] = await getCategoryData(categoryData[0]);
    setState(() {});
    return imageArr;
  }

  getCartCount() async {
    int latestCartCount = prefs.getInt("cartCounter");
    int customerId = prefs.getInt('customerId');

    if (latestCartCount != null && latestCartCount > 0) {
      http.Response response;
      response = await http
          .get("http://admin.dailyneedapps.com/api/shoppingcart/$customerId");
      Map cartData = convert.jsonDecode(response.body);

      if (cartData['products'].length == 0) {
        prefs.setInt("cartCounter", 0);
        //print(prefs.getInt("cartCounter"));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    imageArr = [new ExactAssetImage('assets/images/banner1.jpeg')];
    super.initState();
    getUpdate();
  }

  @override
  Widget build(BuildContext context) {
    if (width == 0) width = MediaQuery.of(context).size.width;
    if (data == null) {
      return Scaffold(
          backgroundColor: Color.fromRGBO(232, 231, 231, 1),
          appBar: new DnaAppBar().getAppBar(context, 'Dashboard'),
         // bottomNavigationBar: DnaBottomNavigationBar().getNavBar(context),
          body: new Container(
            color: Colors.white,
            child: Center(
              child: Text("Loading...."),
            ),
          ));
    } else {
      if (isVerified != true) {
        return LoginPage();
      }

      return Scaffold(
          backgroundColor: Colors.white,
          appBar: new DnaAppBar().getAppBar(context, 'Dashboard'),
         // bottomNavigationBar: DnaBottomNavigationBar().getNavBar(context),
          drawer: DnaDrawer().getDrawer(context),
          body: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                //  width: 20,
                  height: 10,
                ),
                Center(
                  child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  )
                  ),
                 // height: 80,
                    width: 420,
                    child: Image.asset("assets/Screenshot_20200718-071421 (2).png"),

                )
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                      ),
                        boxShadow: [
                      BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                      ),

                      // height: 80,
                      width: 420,
                      child: Image.asset("assets/Screenshot_20200718-071421 (3).png"),
                    )
                ),
                Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          )
                      ),
                      // height: 80,
                      width: 420,
                      child: Image.asset("assets/Screenshot_20200718-071421.png"),
                    )
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: 200,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Color.fromRGBO(36,219,219,100))
                      ),
                    color:   Color.fromRGBO(36,219,219,100),
                      child: Text(
                      "Order Now",
                      style: TextStyle(
                      color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductCategoryPage(
                                  partnerId: 415,
                                ),
                          ));
                    },
                  ),
                  ),
                )
              ],
            ),
          )
        /*new Container(
              decoration:
                  new BoxDecoration(color: Color.fromRGBO(232, 231, 231, 1)),
              child: ListView(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: new SizedBox(
                      height: 180.0,
                      width: MediaQuery.of(context).size.width,
                      child: new Swiper(
                        itemCount: userData == null ? 0 : userData.length,
                        itemWidth: 300.0,
                        itemBuilder: (BuildContext context, int index) {
                          return new Image.network(
                            "http://admin.dailyneedapps.com/storage/banner/${userData[index]["image"]}",
                            fit: BoxFit.fill,
                          );
                        },
                        pagination: new SwiperPagination(),
                        //control: new SwiperControl(),
                        loop: true,
                        autoplay: true,
                        onTap: (int index) {
                          print(index);
                          print(userData[index]);
                          print(userData[index]['partner_id']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShopDetailsPage(
                                  shopId: userData[index]['partner_id'],
                                  shopName: userData[index]['name'],
                                  shopAddress: '',
                                  shopIcon: userData[index]['image'],
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[1]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[1]["icon"]}",
                          directoryProductName: "${categoryData[1]["name"]}",
                          showPartnerValue: "${categoryData[1]["showPartner"]}",
                        ),
                      ),
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[10]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[10]["icon"]}",
                          directoryProductName: "${categoryData[10]["name"]}",
                          showPartnerValue:
                              "${categoryData[10]["showPartner"]}",
                        ),
                      ),
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[4]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[4]["icon"]}",
                          directoryProductName: "${categoryData[4]["name"]}",
                          showPartnerValue: "${categoryData[4]["showPartner"]}",
                        ),
                      ),
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[5]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[5]["icon"]}",
                          directoryProductName: "${categoryData[5]["name"]}",
                          showPartnerValue: "${categoryData[5]["showPartner"]}",
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(OffersPage.tag);
                      },
                      child: Image.asset(
                        "assets/images/offers.jpg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[12]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[12]["icon"]}",
                          directoryProductName: "${categoryData[12]["name"]}",
                          showPartnerValue:
                              "${categoryData[12]["showPartner"]}",
                        ),
                      ),
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[24]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[24]["icon"]}",
                          directoryProductName: "${categoryData[24]["name"]}",
                          showPartnerValue:
                              "${categoryData[24]["showPartner"]}",
                        ),
                      ),
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[23]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[23]["icon"]}",
                          directoryProductName: "${categoryData[23]["name"]}",
                          showPartnerValue:
                              "${categoryData[23]["showPartner"]}",
                        ),
                      ),
                      Container(
                        width: width / 4,
                        child: DashboardProduct(
                          directoryCategoryId: "${categoryData[0]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/category/${categoryData[0]["icon"]}",
                          directoryProductName: "${categoryData[0]["name"]}",
                          showPartnerValue: "${categoryData[0]["showPartner"]}",
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  getCategoryBuilder(categoryData[1]),
                  SizedBox(
                    height: 10.0,
                  ),
                  getCategoryBuilder(categoryData[10]),
                  SizedBox(
                    height: 10.0,
                  ),
                  getCategoryBuilder(categoryData[4]),
                  SizedBox(
                    height: 10.0,
                  ),
                  getCategoryBuilder(categoryData[5]),

                  SizedBox(
                    height: 10.0,
                  ),
                  getCategoryBuilder(categoryData[12]),
                  SizedBox(
                    height: 10.0,
                  ),
                  getCategoryBuilder(categoryData[24]),
                  SizedBox(
                    height: 10.0,
                  ),
                  getCategoryBuilder(categoryData[23]),
                  SizedBox(
                    height: 10.0,
                  ),
                  getCategoryBuilder(categoryData[0]),
                  SizedBox(
                    height: 10.0,
                  ),

//                    getCategoryDataWidget(),
                ],
              )
          )*/
      );
    }
  }

  getCategoryDataWidget(dynamic categoryData, List<dynamic> partnerList) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  categoryData["name"],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              )),
              partnerList.length >= 5
                  ? FlatButton(
                      child: Text('More'),
                      onPressed: () {
                        print(
                            'Show partner ==> ${categoryData["showPartner"]}');
                        if (categoryData["showPartner"] as bool) {
                          var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new PartnerListPage(
                                      categoryName: categoryData['name'],
                                      categoryImage:
                                          "http://admin.dailyneedapps.com/storage/category/${categoryData["icon"]}",
                                      categoryId: categoryData['id'],
                                      showPartner: categoryData['showPartner'],
                                      type: "category"));
                          Navigator.of(context).push(route);
                        } else {
                          var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new CategoryPage(
                                    categoryName: categoryData['name'],
                                    categoryImage:
                                        "http://admin.dailyneedapps.com/storage/category/${categoryData["icon"]}",
                                    categoryId: categoryData['id'],
                                    showPartner: categoryData['showPartner'],
                                  ));
                          Navigator.of(context).push(route);
                        }
                      },
                    )
                  : Container()
            ],
          ),
          Container(
            height: 90,
            child: new ListView.builder(
//          shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: partnerList.length,
              itemBuilder: (BuildContext context, int index) {
                print(
                    'Show partner bool ==> ${partnerList[index]["showPartner"]}');
                return Container(
                  width: 90,
                  child: partnerList[index]["showPartner"] == null
                      ? SingleProductView(
                          partnerId: "${partnerList[index]["id"]}",
                          prod_image:
                              "http://admin.dailyneedapps.com/storage/partner/${partnerList[index]["image"]}",
                          partnerName: "${partnerList[index]["shop_name"]}",
                        )
                      : new Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                          child: new Card(
                            elevation: 6.0,
                            color: Colors.tealAccent,
                            child: new Hero(
                              tag:
                                  "http://admin.dailyneedapps.com/storage/subcategory/${partnerList[index]["icon"]}",
                              child: new Material(
                                child: new InkWell(
                                    onTap: () {
                                      var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new PartnerListPage(
                                                  categoryName:
                                                      "${partnerList[index]["name"]}",
                                                  categoryImage:
                                                      "http://admin.dailyneedapps.com/storage/subcategory/${partnerList[index]["icon"]}",
                                                  categoryId:
                                                      "${partnerList[index]["id"]}",
                                                  showPartner:
                                                      partnerList[index]
                                                          ["showPartner"],
                                                  type: "subcategory"));
                                      Navigator.of(context).push(route);
                                    },
                                    child: new ListTile(
                                      title: new Image.network(
                                          "http://admin.dailyneedapps.com/storage/subcategory/${partnerList[index]["icon"]}",
                                          width: 50,
                                          height: 50),
                                      subtitle: new Text(
                                        "${partnerList[index]["name"]}",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> getCategoryData(dynamic category) async {
    print('show partners ==> ${category["showPartner"]}');
    var categoryURL = category["showPartner"] as bool
        ? "http://admin.dailyneedapps.com/api/partners/category/${category["id"]}/$townshipId"
        : "http://admin.dailyneedapps.com/api/subcategories/${category["id"]}";
    print(categoryURL);
    prefs.setString(categoryURL, null);
    if (prefs.getString(categoryURL) == null) {
      http.Response response = await http.get(categoryURL);
      print('response => ${response.body}');
      Map data = json.decode(response.body);
      String encodedJsonData = category["showPartner"] as bool
          ? json.encode(data['partners'])
          : json.encode(data['subcategories']);

      prefs.setString(categoryURL, encodedJsonData);
    }

    String prefData = prefs.getString(categoryURL.replaceAll('\"', ''));

    List<dynamic> partners = json.decode(prefData) as List;

    return partners;
  }

  getCategoryBuilder(dynamic categoryData) {
    return getCategoryDataWidget(
        categoryData, categoryData['homedata'] as List);
//    return FutureBuilder(
//      future: getCategoryData(categoryData),
//      builder: (context, snapshot) {
//        if (snapshot.connectionState != ConnectionState.done) {
//          print('Builder hasn\'t data');
//
//          return Container(
//            child: Center(
//              child: CircularProgressIndicator(),
//            ),
//          );
//        }
//        print('Builder has data');
//        return getCategoryDataWidget(categoryData, snapshot.data);
//      },
//    );
  }

  getUpdate() async {
    Map data, forceUpdateData, updateVersionData;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String applicationVersion = packageInfo.version;
    print('application version-->$applicationVersion');
    http.Response response = await http
        .get('http://admin.dailyneedapps.com/api/force_update_versions');
    data = convert.jsonDecode(response.body);
    if (data['success'] == true) {
      forceUpdateData = data['force_update_version'];
      updateVersionData = data['update_version'];
      String forceUpdateVersion = forceUpdateData['force_update_version'];
      String updateVersion = updateVersionData['update_version'];
      if (applicationVersion.compareTo(forceUpdateVersion) == 0 ||
          applicationVersion.compareTo(forceUpdateVersion) == 1) {
        if (applicationVersion.compareTo(updateVersion) == 0 ||
            applicationVersion.compareTo(updateVersion) == 1) {
          getData();
          getCartCount();
        } else {
          showDialogFunction(updateVersionData['update_message'], "Update App",
              () {
            openAppInPlayStore();
          }, () {
            Navigator.pop(context);
            getData();
          });
        }
      } else {
        showDialogFunction(
            forceUpdateData['force_update_message'], "Update App", () {
          openAppInPlayStore();
        }, () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
      }
    }
    print("Response body: ${response.body}");
  }

  void showDialogFunction(String message, String title, Function positiveButton,
      Function negativeButton) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            content: Text(message),
            actions: <Widget>[
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () {
                  negativeButton();
                },
              ),
              MaterialButton(
                child: Text('Update'),
                onPressed: () {
                  positiveButton();
                },
              ),
            ],
          );
        });
  }

  void openAppInPlayStore() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.packageName;
    print('package name ==> $appName');
    StoreRedirect.redirect(androidAppId: appName, iOSAppId: appName);
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
