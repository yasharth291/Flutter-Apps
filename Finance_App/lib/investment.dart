import 'package:flutter/material.dart';
import 'package:kartiksir/SecondPage.dart';
import 'package:kartiksir/Fade.dart';
void main()=>
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Tardol(),
      ),
    );

class Tardol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InsPage(),
      routes: <String, WidgetBuilder> {
        '/l' : (BuildContext context)=> SecondApp(),
      },
    );
  }
}

class InsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<InsPage> {

  List<Company> _companies = Company.getLoan();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                        child:FadeAnimation(1,
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
                        child:FadeAnimation(1,
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
                        child:FadeAnimation(1,
                          Container(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
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
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  FadeAnimation(1,
                                    Text("Investment Type: ",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  FadeAnimation(1,
                                    DropdownButton(
                                      value: _selectedCompany,
                                      items: _dropdownMenuItems,
                                      onChanged: onChangeDropdownItem,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                ]
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      width: 260,
                      child: FadeAnimation(1,
                        RaisedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, "/l");
                          },
                          color: Colors.blue[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: Color.fromRGBO(49, 39, 79, 1),
                            ),
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
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
class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getLoan() {
    return <Company>[
      Company(1, 'Fix Deposite'),
      Company(2, 'Mutual Fund'),
      Company(3, 'Trading'),
      Company(4, 'Dmat account')
    ];
  }
}