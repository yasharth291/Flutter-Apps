import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProfilePage.dart';

class OtpPage extends StatefulWidget {
  static String tag = 'OtpPage';
  final String mobile;
  int customerId;
  String pin;

  OtpPage({Key key, @required this.mobile}) : super(key: key);
  @override
  _OtpPageState createState() => new _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _code;
  final OtpController = TextEditingController();
  static final int _pinLength = 6;
  static final TextStyle _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
  );
  PinEditingController _pinEditingController = PinEditingController();
  PinDecoration _pinDecoration = UnderlineDecoration(
    textStyle: _textStyle,
    enteredColor: Colors.deepOrange,
  );
  bool _obscureEnable = false;
  PinEntryType _pinEntryType = PinEntryType.underline;
  Color _solidColor = Colors.purpleAccent;
  bool _solidEnable = false;

  void _setPinValue() {
    _pinEditingController.text = _generateRandomPin();
  }

  String _generateRandomPin() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < _pinLength; i++) {
      sb.write("$i");
    }
    return sb.toString();
  }

  Future<List> getCode() async {
    //SmsAutoFill().listenForCode;
  }

  setCustomerDetails(isVerified, customerId, mobile) async {
    print(isVerified);
    print(customerId);
    print(mobile);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVerified', isVerified);
    await prefs.setInt('customerId', customerId);
    await prefs.setString('mobile', mobile);
  }

  @override
  void initState() {
    //SmsAutoFill().listenForCode;
    _pinEditingController.addListener(() {
      debugPrint('changed pin:${_pinEditingController.text}');
    });
    super.initState();
  }

  @override
  void dispose() {
    _pinEditingController.dispose();
    OtpController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    print(widget.mobile);
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/ic_launcher.jpg'),
      ),
    );

    final otpimage = Hero(
      tag: 'otpimage',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/otp.png'),
      ),
    );

    /*final phoneno = TextFormField(
      keyboardType: TextInputType.phone,
      //maxLines: 2,

      autofocus: false,
      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w300, fontSize: 16.0),
      enabled: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Color.fromRGBO(110, 110, 110, 100))
        ),
        labelText: 'Mobile No',
      ),
    );*/

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          //print(_pinEditingController.text);
          print("new otp");
          print(OtpController.text);
          //this._code = _pinEditingController.text;
          this._code = OtpController.text;
          print('this one is pin:');
          print(this._code);
          http.post('http://admin.dailyneedapps.com/api/confirmotp', body: {
            'otp': this._code,
            'mobile': widget.mobile,
            'fullname': '',
            'firebaseId': ''
          }).then((http.Response response) {
            print("Response body: ${response.body}");
            var jsonResponse = convert.jsonDecode(response.body);
            if (jsonResponse['success'] == true) {
              setCustomerDetails(true, jsonResponse['customer']['id'],
                  jsonResponse['customer']['mobile']);
              print(jsonResponse['customer']);
//                Navigator.of(context).pushNamed(DashboardPage.tag);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        customerId: jsonResponse['customer']['id'],
                        customer: jsonResponse['customer']),
                  ));
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text('Invalid pin'),
                    );
                  });
              // Find the Scaffold in the Widget tree and use it to show a SnackBar!

            }
          });
          // Navigator.of(context).pushNamed(ProfilePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Color.fromRGBO(245, 161, 0, 100),
        child: Text('Proceed',
            style: TextStyle(
                color: Color.fromRGBO(58, 56, 52, 100), fontSize: 20.0)),
      ),
    );

    return Scaffold(
        body: Center(
      child: Container(
          color: Color.fromRGBO(231, 230, 230, 100),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            margin: EdgeInsets.only(top: 50, bottom: 50, left: 20, right: 20),
            child: Card(
              child: ListView(
                //padding: EdgeInsets.all(20.0),
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  ),
                  /*Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/images/logo.jpg'),
                      ),
                    ),
                    Expanded(
                      child: Image.asset('assets/images/otp.png'),
                    )
                  ],
                ),*/
                  logo,
                  SizedBox(height: 10.0),
                  otpimage,
                  SizedBox(
                    height: 10.0,
                  ),

                  Text(
                    "Waiting to automatically detect SMS sent to your mobile number ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(110, 110, 110, 100),
                      fontSize: 14.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //${widget.value.phoneno},
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Enter 6 Digit Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(110, 110, 110, 100),
                            fontSize: 18.0),
                      ),
                      /*new PinEntryTextField(
                        fields: 6,
                        fontSize: 20.0,
                        fieldWidth: 30.0,
                        onSubmit: (String pin) {
                          print('new pin');
                          print(pin);
                          http.post('http://admin.dailyneedapps.com/api/confirmotp', body: {
                            'pin': pin,
                            'mobile': widget.mobile,
                            'fullname':'',
                            'firebaseId':''
                          }).then((http.Response response){
                              print("Response body: ${response.body}");
                              var jsonResponse = convert.jsonDecode(response.body);
                              if(jsonResponse['success'] == true) {
                                Navigator.of(context).pushNamed(ProfilePage.tag);
                              } else {
                                showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text('Invalid pin'),
                                  );
                                });
                              // Find the Scaffold in the Widget tree and use it to show a SnackBar!

                              }
                          });
                        }
                        ),*/
                      /*PinInputTextField(
                          pinLength: _pinLength,
                          decoration: _pinDecoration,
                          pinEditingController: _pinEditingController,
                          autoFocus: true,
                          onSubmit: (pin) {
                            debugPrint('submit pin:$pin');
                          },
                        ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 5, right: 5, top: 10),
                            child: SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: OtpController,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                key: new Key('otp'),
                                cursorWidth: 1,
                                cursorColor: Color.fromRGBO(165, 165, 165, 1),
                                decoration: InputDecoration(
                                    hintText: "OTP",
                                    border: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  loginButton,
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Didn't received the code?",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        InkWell(
                          onTap: () {
                            http.post(
                                'http://admin.dailyneedapps.com/api/profile/${widget.mobile}',
                                body: {
                                  "mobile": widget.mobile,
                                  "fullname": ""
                                }).then((http.Response response) {
                              print("Response body: ${response.body}");
                              var jsonResponse =
                                  convert.jsonDecode(response.body);
                              if (jsonResponse['success'] == true) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("OTP"),
                                        content: Text('OTP sent successfully.'),
                                      );
                                    });
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Text("RESEND CODE",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        )
                      ],
                    ),
                  ),
//              Padding(
//                padding:EdgeInsets.only(bottom:5),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    RaisedButton(
//                        onPressed: () {
//                            http.get('http://admin.dailyneedapps.com/api/profile/${widget.mobile}')
//                                .then((http.Response response){
//                                  print("Response body: ${response.body}");
//                                  var jsonResponse = convert.jsonDecode(response.body);
//                                  if(jsonResponse['success'] == true) {
//                                    setCustomerDetails(true, jsonResponse['customer']['id'], jsonResponse['customer']['mobile']);
//                                    print(jsonResponse['customer']);
//                                    Navigator.of(context).pushNamed(DashboardPage.tag);
////                                    Navigator.push(
////                                      context,
////                                      MaterialPageRoute(
////                                        builder: (context) => ProfilePage(
////                                        customerId: jsonResponse['customer']['id'],
////                                        customer:jsonResponse['customer']
////                                      ),
////                                      )
////                                    );
//                                  }
//                                });
//                        },
//                        textColor: Colors.black,
//                        padding: const EdgeInsets.all(0.0),
//                        child: Container(
//                            width: 100,
//                            height: 35,
//                            decoration: const BoxDecoration(
//                              color: const Color(0xFFbdde11),
//                            ),
//                            padding: const EdgeInsets.all(0),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text("Skip", style: TextStyle(fontSize: 15),)
//                              ],
//                            )
//                        )
//
//                    )
//                  ],
//                ),
//              )
                ],
              ),
            ),
          )),
    ));
  }
}

class PinEntryTextField extends StatefulWidget {
  int fields;
  var onSubmit;
  double fieldWidth;
  double fontSize;
  bool isTextObscure;
  bool showFieldAsBox;

  PinEntryTextField(
      {this.fields: 6,
      this.onSubmit,
      this.fieldWidth: 40.0,
      this.fontSize: 20.0,
      this.isTextObscure: false,
      this.showFieldAsBox: false})
      : assert(fields > 0);

  @override
  State createState() {
    return PinEntryTextFieldState();
  }
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  List<String> _pin;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _pin = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
  }

  @override
  void dispose() {
    _focusNodes.forEach((FocusNode f) => f.dispose());
    _textControllers.forEach((TextEditingController t) => t.dispose());
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
  }

  Widget buildTextField(int i, BuildContext context) {
    _focusNodes[i] = FocusNode();
    _textControllers[i] = TextEditingController();

    _focusNodes[i].addListener(() {
      if (_focusNodes[i].hasFocus) {
        _textControllers[i].clear();
      }
    });

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: widget.fontSize),
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        decoration: InputDecoration(
            counterText: "",
            border: widget.showFieldAsBox
                ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
                : null),
        onChanged: (String str) {
          _pin[i] = str;

          if (i + 1 != widget.fields) {
            print('in');
            //widget.pin = _pin.join();
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          } else if (i == 5) {
            //print(_pin.join());
            print('5');
            widget.onSubmit(_pin.join());
          } else {
            //clearTextFields();
            print('else');
            FocusScope.of(context).requestFocus(_focusNodes[0]);
          }
        },
        onSubmitted: (String str) {
          clearTextFields();
          print('submit');
          //print(_pin.join());
          widget.onSubmit(_pin.join());
        },
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    // FocusScope.of(context).requestFocus(_focusNodes[0]);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: generateTextFields(context),
    );
  }
}
