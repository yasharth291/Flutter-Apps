import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'OtpPage.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'LoginPage';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _mobile;

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/ic_launcher.jpg'),
      ),
    );

    void _validateInputs() {
      if (_key.currentState.validate()) {
        //If all data are correct then save data to out variables
        //print(mobile);
        _key.currentState.save();
        //print('last mobile');
        //print(this._mobile);
        //Navigator.of(context).pushNamed(OtpPage.tag, arguments:LoginPageArguments(mobile));
        http.post('http://admin.dailyneedapps.com/api/newotp', body: {
          "mobile": this._mobile,
          "fullname": ""
        }).then((http.Response response) {
          print("Response body: ${response.body}");
          var jsonResponse = convert.jsonDecode(response.body);
          if (jsonResponse['success'] == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpPage(
                    mobile: this._mobile,
                  ),
                ));
          }
        });
      } else {
        //If all data are not valid then start auto validation.
        setState(() {
          _autoValidate = true;
        });
      }
    }

    String validateMobile(String value) {
      if (value.isEmpty)
        return 'Enter Mobile number';
      else {
        //Indian Mobile number are of 10 digit only
        if (value.length != 10)
          return 'Mobile Number must be of 10 digit';
        else
          return null;
      }
    }

    // Here is FormUI
    Widget FormUI() {
      return Container(
        margin: EdgeInsets.only(top: 50, bottom: 50, left: 20, right: 20),
        child: new Card(
          child: ListView(
            //padding: EdgeInsets.all(20.0),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              ),
              logo,
              SizedBox(height: 20.0),
              Text(
                "Hi,",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                "Let's Get Started",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF757575)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(204, 204, 204, 1), width: 1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 0, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Mobile Number",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(165, 165, 165, 1)),
                              textAlign: TextAlign.left,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              //maxLines: 2,
                              autofocus: false,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 18.0),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Text("+91",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18.0))),
                              validator: validateMobile,
                              onSaved: (String val) {
                                _mobile = val;
                              },
                            ),
                          ],
                        )),
                  ),

                  /*new TextFormField(
                  keyboardType: TextInputType.phone,
                  //maxLines: 2,
                  autofocus: false,
                  style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1), fontWeight: FontWeight.w300, fontSize: 16.0),
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Color.fromRGBO(110, 110, 110, 100))
                    ),
                    labelText: 'Mobile No',
                  ),
                  validator: validateMobile,
                  onSaved: (String val) {
                    _mobile = val;
                  },
                ),*/
                  new SizedBox(height: 20.0),
                  new ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      textColor: Color.fromRGBO(58, 56, 52, 100),
                      color: Color.fromRGBO(245, 153, 8, 100),
                      onPressed: () {
                        _validateInputs();
                      },
                      child: Text('Proceed',
                          style: TextStyle(
                              color: Color.fromRGBO(58, 56, 52, 100),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: Container(
      color: Color.fromRGBO(231, 230, 230, 100),
      child: Center(
          child: Form(
        key: _key,
        autovalidate: _autoValidate,
        child: FormUI(),
      )),
    ));
  }
}
