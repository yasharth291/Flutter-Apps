import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DashboardPage.dart';

class ProfilePage extends StatefulWidget {
  static String tag = 'profile-page';
  final int customerId;
  final Map customer;

  ProfilePage({Key key, @required this.customerId, @required this.customer})
      : super(key: key);

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _key = GlobalKey<FormState>();
  bool _autoValidate = false;
  Map data;
  String _name;
  String _email;
  String _password;
  String _city;
  String _location;
  String dropdownValue = "Pune";
  String townshipDropdownValue;
  List townshipArr;
  bool showTownshipError = false;

  Future<List> getData() async {
    print("============calling url===========");
    http.Response response =
        await http.get('http://admin.dailyneedapps.com/api/gettownships');
    data = convert.jsonDecode(response.body);

    setState(() {
      townshipArr = data['townships'];
      print(townshipArr);
    });

    return townshipArr;
  }

  @override
  void initState() {
    // TODO: implement initState
    //  imageArr = [new ExactAssetImage('assets/images/banner1.jpeg')];
    townshipArr = [
      {"id": 1, "name": "Nanded City - Pune"}
    ];
    super.initState();
    getData();
    print("partner list");
  }

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
        //    If all data are correct then save data to out variables
        _key.currentState.save();
        //Navigator.of(context).pushNamed(DirectoryPage.tag);
      } else {
        //    If all data are not valid then start auto validation.
        setState(() {
          _autoValidate = true;
        });
      }
    }

    // Here is FormUI
    Widget FormUI() {
      return new Container(
        color: Color.fromRGBO(231, 230, 230, 100),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          child: Card(
            margin: EdgeInsets.only(top: 50, bottom: 50, left: 20, right: 20),
            child: ListView(
              //padding: EdgeInsets.all(20.0),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                ),
                logo,
                SizedBox(height: 40.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Complete your Profile",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromRGBO(112, 112, 112, 1),
                        fontSize: 18.0,
                      ),
                    ),
                    new SizedBox(height: 20.0),
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
                                "Name*",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(165, 165, 165, 1)),
                                textAlign: TextAlign.left,
                              ),
                              TextFormField(
                                initialValue:
                                    "${widget.customer["fullname"] != null ? widget.customer["fullname"] : ''}",
                                keyboardType: TextInputType.text,
                                key: new Key('name'),
                                //maxLines: 2,
                                autofocus: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.0),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                validator: (val) => val.isEmpty
                                    ? 'Name can\'t be empty.'
                                    : null,
                                onSaved: (val) => _name = val,
                              ),
                            ],
                          )),
                    ),
                    new SizedBox(height: 20.0),
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
                                "Email ID",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(165, 165, 165, 1)),
                                textAlign: TextAlign.left,
                              ),
                              TextFormField(
                                initialValue:
                                    "${widget.customer["email"] != null ? widget.customer["email"] : ''}",
                                keyboardType: TextInputType.text,
                                key: new Key('email'),
                                //maxLines: 2,
                                autofocus: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.0),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),

                                onSaved: (val) => _email = val,
                              ),
                            ],
                          )),
                    ),
//                  new SizedBox(height: 20.0),
//                  Container(
//                    decoration: BoxDecoration(
//                      border: Border.all(color: Color.fromRGBO(204, 204, 204, 1), width: 1),
//                      borderRadius: BorderRadius.circular(4.0),
//                    ),
//                    width: MediaQuery.of(context).size.width,
//                    child: Padding(
//                          padding: EdgeInsets.only(left: 10, bottom: 0, top: 5),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("Password", style: TextStyle(fontSize: 14, color: Color.fromRGBO(165, 165, 165, 1)), textAlign: TextAlign.left,),
//                              TextFormField(
//                                keyboardType: TextInputType.text,
//                                key: new Key('password'),
//                                obscureText: true,
//                                autocorrect: false,
//                                //maxLines: 2,
//                                autofocus: false,
//                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
//                                decoration: InputDecoration(
//                                  border:InputBorder.none,
//                                ),
//                                validator: (val) =>
//                                    val.isEmpty ? 'Password can\'t be empty.' : null,
//                                onSaved: (val) => _password = val,
//                              ),
//                            ],
//                          )
//                        ),
//                  ),
//                  new SizedBox(height: 20.0),
//                  Container(
//                    decoration: BoxDecoration(
//                      border: Border.all(color: Color.fromRGBO(204, 204, 204, 1), width: 1),
//                      borderRadius: BorderRadius.circular(4.0),
//                    ),
//                    width: MediaQuery.of(context).size.width,
//                    child: Padding(
//                          padding: EdgeInsets.only(left: 10, bottom: 0, top: 5),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("Your Current Location", style: TextStyle(fontSize: 14, color: Color.fromRGBO(165, 165, 165, 1)), textAlign: TextAlign.left,),
//                              TextFormField(
//                                keyboardType: TextInputType.text,
//                                key: new Key('location'),
//                                //maxLines: 2,
//                                autofocus: false,
//                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
//                                decoration: InputDecoration(
//                                  hintText: "Your Address",
//                                  border:InputBorder.none,
//                                ),
//                                validator: (val) =>
//                                    val.isEmpty ? 'Location can\'t be empty.' : null,
//                                onSaved: (val) => _location = val,
//                              ),
//                            ],
//                          )
//                        ),
//                  ),
                    new SizedBox(height: 20.0),
                   /* Container(
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
                                "Township*",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(165, 165, 165, 1)),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                width: 300.0,
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton(
                                      value: townshipDropdownValue,
                                      items: townshipArr
                                          .map((township) =>
                                              DropdownMenuItem<String>(
                                                child: SizedBox(
                                                  width: 200,
                                                  child: Text(township['name']),
                                                ),
                                                value:
                                                    township['id'].toString(),
                                              ))
                                          .toList(),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          print(newValue);
                                          townshipDropdownValue = newValue;
                                        });
                                      },
                                      isExpanded: false,
                                      //value: _currentUser,
                                      hint: Text('Select Township'),
                                    ),
                                  ),

                                  /*child: DropdownButton(
                                        value: townshipDropdownValue,
                                        /*items: <String>['Nanded City']
                                          .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          })
                                          .toList(),*/
                                        items: townshipArr.map((map) {
                                          return new DropdownMenuItem<String>(
                                            value: map["id"].toString(),
                                            child: new Text(
                                              map["name"],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String newValue) {
                                          print('test');
                                          print(newValue);

                                          setState(() {
                                            dropdownValue = newValue;
                                          });

                                        },
                                        style: Theme.of(context).textTheme.title,*/
                                  //),
                                ),
                              ),
                              showTownshipError
                                  ? Text("Township can't be empty.",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFd92d2d)),
                                      textAlign: TextAlign.left)
                                  : Container()
                            ],
                          )),
                    ),*/

                    /*new TextFormField(
                      keyboardType: TextInputType.text,
                      key: new Key('name'),
                      autofocus: true,
                      autocorrect: false,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(110, 110, 110, 100))),
                        labelText: 'Name',
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Name can\'t be empty.' : null,
                      onSaved: (val) => _name = val,
                    ),

                    new SizedBox(height: 20.0),

                    new TextFormField(
                      keyboardType: TextInputType.text,
                      key: new Key('email'),
                      autocorrect: false,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(110, 110, 110, 100))),
                        labelText: 'Email ID',
                      ),
                      validator: (String value) {
                        if (value.isEmpty)
                          return 'Email can\'t be empty.';
                        else {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(value))
                            return 'Enter Valid Email';
                          else
                            return null;
                        }
                      },
                      onSaved: (val) => _email = val,
                    ),

                    new SizedBox(height: 20.0),

                    new TextFormField(
                      keyboardType: TextInputType.text,
                      key: new Key('password'),
                      obscureText: true,
                      autocorrect: false,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(110, 110, 110, 100))),
                        labelText: 'Password',
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Password can\'t be empty.' : null,
                      onSaved: (val) => _password = val,
                    ),

                    new SizedBox(height: 20.0),

                    new TextFormField(
                      keyboardType: TextInputType.text,
                      key: new Key('city'),
                      autocorrect: false,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(110, 110, 110, 100))),
                        labelText: 'City',
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'City ID can\'t be empty.' : null,
                      onSaved: (val) => _city = val,
                    ),

                    new SizedBox(height: 20.0),

                    new TextFormField(
                      keyboardType: TextInputType.text,
                      key: new Key('location'),
                      autocorrect: false,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(110, 110, 110, 100))),index
                        labelText: 'Your Current Location',
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Location ID can\'t be empty.' : null,
                      onSaved: (val) => _location = val,
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
                          townshipDropdownValue = "3";
                          _validateInputs();
                          print(this._name);
                          print(this._email);
                          print(this._password);
//                        print(dropdownValue);
//                        print(this._location);
                          print(this.townshipDropdownValue);

                          if (this.townshipDropdownValue == null) {
                            showTownshipError = true;
                            return;
                          }
                          /*Map<String, String> body = {
                            "customerId": widget.customerId,
                            "formData": convert.jsonEncode({
                              'fullname':this._name,
                              'email':this._email,
                              'password':this._password,
                              'township':this._location,
                              'city':this._city})
                          };*/

//                        print('password-->${base64Encode(utf8.encode(this._password))}');
                          http.post(
                              'http://admin.dailyneedapps.com/api/saveprofile',
                              body: {
                                "customerId": "${widget.customerId}",
                                "fullname": this._name,
                                "email": this._email != null ? this._email : '',
                                "mobile": "${widget.customer["mobile"]}",
                                "password":
                                    '', //base64Encode(utf8.encode(this._password)),//this._password,
                                "township": "${this.townshipDropdownValue}",
                                "location": '',
                                "city": dropdownValue
                              }).then((http.Response response) {
                            var jsonResponse =
                                convert.jsonDecode(response.body);
                            print(jsonResponse);
                            if (jsonResponse['success'] == true) {
                              setTownship(townshipDropdownValue);
                              setEmail(this._email != null ? this._email : '');
                              setFullname(this._name);
                              Navigator.of(context)
                                  .pushNamed(DashboardPage.tag);
                            }
                          });
                        },
                        child: Text('Submit',
                            style: TextStyle(
                                color: Color.fromRGBO(58, 56, 52, 100),
                                fontSize: 20.0)),
                      ),
                    ),
                    new SizedBox(height: 20.0),
                    /*new ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: double.infinity),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Color.fromRGBO(245, 153, 8, 100),
                            child: Text('Submit', style: TextStyle(color: Color.fromRGBO(58, 56, 52, 100), fontSize: 20.0)),
                        ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                        child: new MaterialButton(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onPressed: () {
                              _validateInputs();

                              Map<String, String> body = {
                                "customerId": "586",
                                "formData": convert.jsonEncode({
                                  'fullname':this._name,
                                  'email':this._email,
                                  'password':this._password,
                                  'township':this._location,
                                  'city':this._city})
                              };

                              http.post('http://admin.dailyneedapps.com/api/profile',
                                body: {
                                  "customerId": "586",
                                  "formData": convert.jsonEncode({
                                  'fullname':this._name,
                                  'email':this._email,
                                  'password':this._password,
                                  'township':this._location,
                                  'city':this._city})
                                }
                              ).then((http.Response response){
                                var jsonResponse = convert.jsonDecode(response.body);
                                print(jsonResponse);
                                if(jsonResponse['success'] == true) {
                                  //Navigator.of(context).pushNamed(DashboardPage.tag);
                                }
                              });

                            },
                            padding: EdgeInsets.all(12),
                            color: Color.fromRGBO(245, 161, 0, 100),
                            child: Text('Submit', style: TextStyle(color: Color.fromRGBO(58, 56, 52, 100), fontSize: 20.0)),
                          ),
                      ),
                    )*/
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        body: Center(
            child: Form(
      key: _key,
      autovalidate: _autoValidate,
      child: FormUI(),
    )));
  }

  setTownship(townshipId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('townshipId', townshipId);
  }

  setEmail(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  setFullname(fullname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullname', fullname);
  }
}
