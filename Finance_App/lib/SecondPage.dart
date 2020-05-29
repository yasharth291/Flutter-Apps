import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kartiksir/Fade.dart';
import 'package:dio/dio.dart';
import 'package:kartiksir/main.dart';

void main()=>runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SecondApp(),

  ),
);


class SecondApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SecondApp> {
  String s ="", s1 = "", s2 = "", s3 = "", s5 = "";

  createAlbum(Map<String, dynamic> body)async{
      var dio = Dio();
      try {
        FormData formData = new FormData.fromMap(body);
        var response = await dio.post("http://hiddenmasterminds.com/web/index.php?r=jflipgradtest/createdata", data: formData);
        return response.data;
      } catch (e) {
        print(e);
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/pngtree-finance-app-page-geometric-background-banner-image_157396.jpg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: FadeAnimation(1,
                     Container(
                      child: Text(
                          "Paise Centre",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: FadeAnimation(
                        1,
                        Text(
                          "Value for every paise",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                    1,
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            child: TextField(
                              onChanged: (String text3){
                                s = text3;
                              },
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.black),
                              ),

                            ),

                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              onChanged: (String text2){
                                s1 = text2;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Mobile Number",
                                  hintStyle: TextStyle(color: Colors.black)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              onChanged: (String text1){
                                s2 = text1;
                                print(s2);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Pincode",
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            child: TextField(
                              onChanged: (String text5){
                                s5 = text5;
                              },
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "City",
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Time To Contact",
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              onChanged: (String text){
                                s3 =  text;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FadeAnimation(
                    1,
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 260,
                        child: RaisedButton(
                          onPressed: (){
                            setState(() {
                              var map = new Map<String, dynamic>();
                              map['name'] = s;
                              map['mobile_number'] = s1;
                              map['pincode'] = s2;
                              map['city'] = s5;
                              map['time_to_contact'] = s3;
                              createAlbum(map);
                              alret(context);

                            });

                          },
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: Color.fromRGBO(49, 39, 79, 1),
                            ),
                          ),
                          child: Text(
                            "Send",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void alret(BuildContext context) {

    var alertDialog = AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Color.fromRGBO(49, 39, 79, 1),
          ),
        ),
      title: Center(
        child: Text("Request Taken"),
      ),
      content:
       Icon(
         Icons.check_circle_outline,
               color: Colors.lightGreenAccent,
         size: 50.0,
       ),
      backgroundColor: Colors.lightBlue[300],
      actions: <Widget>[
        FlatButton(
          child: Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();

          },
        ),
      ],

    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }
}

