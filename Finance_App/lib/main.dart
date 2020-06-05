import 'package:flutter/material.dart';
import 'package:kartiksir/home.dart';
import 'package:kartiksir/Fade.dart';
import 'package:dio/dio.dart';
import 'package:kartiksir/ghome.dart';
void main()=>runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Signin(),
    routes: <String, WidgetBuilder>{
      '/a' : (BuildContext context) => MyHomePage(),
      '/b' : (BuildContext context) => MyHomePages(),
    },
  ),
);
class Signin extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Signin> {

  String s;
  String ident;

  createAlbum(Map<String, dynamic> body) async{
    var dio = Dio();
    try {
      FormData formData = new FormData.fromMap(body);
      var response = await dio.post("http://paisecentre.in/pc/web/index.php?r=jflipgradtest/verifycode", data: formData);
      setState(() {
        ident = response.data['status'].toString();
      });
      if(ident == "success") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => App()));
      }
      else{
        alreti();
      }
    }
    catch (e) {
      print(e);
    }
  }

  Future<void> alreti() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification Fail'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Reject'),
                Icon(
                  Icons.close,
                  color: Colors.red[800],
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('next'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Signin()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Column(
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
                height: 40,
              ),
              Center(
                child: FadeAnimation(
                  1,
                  Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  "ENTER THE MEMBER ID HERE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
               child: Container(
                width: 250,
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black26,
                    ),
                    right: BorderSide(
                      color: Colors.black26,
                    ),
                    left: BorderSide(
                      color: Colors.black26,
                    ),
                    top: BorderSide(
                      color: Colors.black26,
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
                    hintText: "Member ID",
                    hintStyle: TextStyle(color: Colors.black26),
                  ),
                ),
               ),
              ),
              SizedBox(
                height: 60,
              ),

              FadeAnimation(
                1,
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 260,
                    child: RaisedButton(
                      onPressed: () {
                        var map = new Map<String, dynamic>();
                        map['code'] = s;
                        createAlbum(map);

                      },

                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                      ),
                      child: Text(
                        "ENTER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FadeAnimation(
                1,
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 260,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Mapp()));
                      },

                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                      ),
                      child: Text(
                        "LOGIN AS GUEST",
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
        ],
      ),
      ),
    );
  }
}
