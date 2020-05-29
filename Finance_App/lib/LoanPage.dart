import 'package:flutter/material.dart';
import 'package:kartiksir/SecondPage.dart';
import 'package:kartiksir/Fade.dart';
void main()=>
    runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Loan(),

      ),
    );

class Loan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoanPage(),
      routes: <String, WidgetBuilder> {
        '/h' : (BuildContext context)=> SecondApp(),
      },
    );
  }
}

class LoanPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoanPage> {

  List<Company> _companies = Company.getLoan();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  Bank _selectedBank;
  List<DropdownMenuItem<Bank>> _dropdownMenuBank;
  List<Bank> _banks = Bank.getLoan();

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    _dropdownMenuBank = buildDropdownMenuBank(_banks);
    _selectedBank = _dropdownMenuBank[0].value;
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

  List<DropdownMenuItem<Bank>> buildDropdownMenuBank(List banks) {
    List<DropdownMenuItem<Bank>> items = List();
    for (Bank bank in banks) {
      items.add(
        DropdownMenuItem(
          value: bank,
          child:
          Row(
            children: <Widget>[
              Image.asset(
                bank.image,
                width: 25,
                height: 25,
              ),
              Text(" "+bank.name+" "),
            ],
        ),
        )
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  onChangeDropdownBank(Bank selectedbank) {
    setState(() {
      _selectedBank = selectedbank;
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
                       padding: EdgeInsets.all(2.0),
                       child: Column(
                         children: <Widget>[
                           Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: <Widget>[
                                 FadeAnimation(1,
                                  Text("Loan Type: ",
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
                           Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: <Widget>[
                                 FadeAnimation(1,
                                  Text("Bank Name: ",
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
                                   value: _selectedBank,
                                   items: _dropdownMenuBank,
                                   onChanged: onChangeDropdownBank,
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
                       Navigator.pushNamed(context, "/h");
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
        Company(1, 'Personal Loan'),
        Company(2, 'Home Loan'),
        Company(3, 'Business Loan'),
        Company(4, 'Education Loan'),
        Company(5, 'Mortgage Loan'),
    ];
  }
}
class Bank {
  int id;
  String name;
  String image;

  Bank(this.id, this.name, this.image);

  static List<Bank> getLoan() {
    return <Bank>[
      Bank(1, 'HDFC Bank', "assets/hdfc.ico"),
      Bank(2, 'Axis Bank', "assets/axis.ico"),
      Bank(3, 'Icici Bank', "assets/icici.ico"),
      Bank(4, 'Kotak Mahindra Bank', "assets/kotak.ico"),
    ];
  }
}
