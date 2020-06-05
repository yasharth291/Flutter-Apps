import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kartiksir/LoanPage.dart';
import 'package:kartiksir/Cards.dart';
import 'package:kartiksir/Insurance.dart';
import 'package:kartiksir/Fade.dart';
import 'package:kartiksir/investment.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder> {
        '/a': (BuildContext context) => MyHomePage(),
        '/b': (BuildContext context) => Loan(),
        '/c': (BuildContext context) => Cardol(),
        '/d': (BuildContext context) => Ardol(),
        '/e': (BuildContext context) => Tardol(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Offset _offset = Offset(0,0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;


  @override
  void initState() {
    limits= [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration){
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy;
    double contLimit = position.dy + renderBox.size.height ;
    double step = (contLimit-start)/5;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });

  }

  double getSize(int x){
    double size  = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 20;
    return size;
  }


  @override
  Widget build(BuildContext context) {

    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height/1.32;

    return SafeArea(
      child: Scaffold(
        body:  Stack(
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
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: FadeAnimation(
                            1,
                            Container(
                              width: sidebarSize,
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
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 150.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                width: 160.0,
                                child: Image.asset("assets/WhatsApp Image 2020-05-29 at 1.38.06 AM.jpeg"),

                              ),

                              Container(
                                padding: EdgeInsets.all(10.0),
                                width: 160.0,
                                child: Image.asset("assets/WhatsApp Image 2020-05-29 at 1.38.06 AM (1).jpeg"),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                width: 160.0,
                                child: Image.asset("assets/WhatsApp Image 2020-05-29 at 1.38.06 AM (2).jpeg"),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                width: 160.0,
                                child: Image.asset("assets/WhatsApp Image 2020-05-29 at 1.38.07 AM (1).jpeg"),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                width: 160.0,
                                child: Image.asset("assets/WhatsApp Image 2020-05-29 at 1.38.07 AM.jpeg"),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                width: 160.0,
                                child: Image.asset("assets/663b13da-d8c9-48fe-aae5-a6c4283bb18c.jpg"),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                width: 160.0,
                                child: Image.asset("assets/b4ee8976-132c-4626-ba9a-c8c7cb8a57de.jpg"),
                              ),

                            ],

                          ),
                        ),


                      ],
                    ),
                  ),
                  Center(
                    child: FadeAnimation(1,
                      Padding(
                        child: Container(
                          width: sidebarSize,
                          child: Image.network("http://paisecentre.in/pc/web/uploads_student/download.jpeg"),
                          padding: EdgeInsets.all(10.0),
                        ),
                        padding: EdgeInsets.all(5.0),

                      ),
                    ),
                  ),

                ]
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              left: isMenuOpen?0: -sidebarSize+20,
              top: 0,
              curve: Curves.elasticOut,
              child: SizedBox(
                width: sidebarSize,
                child: GestureDetector(
                  onPanUpdate: (details){
                    if(details.localPosition.dx <=sidebarSize){
                      setState(() {
                        _offset = details.localPosition;
                      });
                    }
                    if(details.localPosition.dx>sidebarSize-20 && details.delta.distanceSquared>2){
                      setState(() {
                        isMenuOpen = true;
                      });
                    }
                  },
                  onPanEnd: (details){
                    setState(() {
                      _offset = Offset(0,0);
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      CustomPaint(
                        size: Size(sidebarSize, mediaQuery.height),
                        painter: DrawerPainter(offset: _offset),
                      ),

                      Container(
                        color: Colors.lightBlueAccent[100],
                        height: mediaQuery.height,
                        width: sidebarSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              color: Colors.lightBlueAccent[100],
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("assets/intro (2).png",width: sidebarSize,),
                                  ],
                                ),
                              ),
                            ),
                            Divider(thickness: 1,),
                            Container(
                              key: globalKey,
                              width: double.infinity,
                              height: menuContainerHeight,
                              child: Column(
                                children: <Widget>[
                                  MyButton(
                                    text: "HOME",
                                    iconData: Icons.home,
                                    textSize: getSize(0),
                                    height: (menuContainerHeight)/10,
                                    num: 1,
                                  ),
                                  MyButton(
                                    text: "LOAN",
                                    iconData: Icons.attach_money,
                                    textSize: getSize(1),
                                    height: (menuContainerHeight)/10,
                                    num: 2,
                                  ),
                                  MyButton(
                                    text: "CARDS",
                                    iconData: Icons.credit_card,
                                    textSize: getSize(2),
                                    height: (mediaQuery.height/2)/10,
                                    num: 3,
                                  ),
                                  MyButton(
                                    text: "INSURANCE",
                                    iconData: Icons.monetization_on,
                                    textSize: getSize(3),
                                    height: (menuContainerHeight)/10,
                                    num: 4,
                                  ),
                                  MyButton(
                                    text: "INVESTMENT",
                                    iconData: Icons.strikethrough_s,
                                    textSize: getSize(4),
                                    height: (menuContainerHeight)/10,
                                    num: 5,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 400),
                        right: (isMenuOpen)?10:sidebarSize,
                        bottom: 30,
                        child: IconButton(
                          enableFeedback: true,
                          icon: Icon(Icons.keyboard_backspace,color: Colors.black45,size: 30,),
                          onPressed: (){
                            this.setState(() {
                              isMenuOpen = false;
                            });
                          },),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  final int num;

  MyButton({this.text, this.iconData, this.textSize,this.height,this.num});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.black45,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {
        if (num == 1) {
          Navigator.pushNamed(context, "/a");
        }
        else if (num == 2) {
          Navigator.pushNamed(context, "/b");
        }
        else if (num == 3) {
          Navigator.pushNamed(context, "/c");
        }
        else if (num == 4) {
          Navigator.pushNamed(context, "/d");
        }
        else if (num == 5) {
          Navigator.pushNamed(context, "/e");
        }
      },
    );
  }
}




class DrawerPainter extends CustomPainter{

  final Offset offset;

  DrawerPainter({this.offset});

  double getControlPointX(double width){
    if(offset.dx == 0){
      return width;
    } else {
      return offset.dx>width?offset.dx:width+75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(getControlPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}