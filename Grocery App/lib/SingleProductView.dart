import 'package:Demo_app_grocery/ShopDetailsPage.dart';
import 'package:flutter/material.dart';

class SingleProductView extends StatelessWidget {
  final prod_image;
  final partnerName;
  final partnerId;
  final address;

  SingleProductView({
    this.prod_image,
    this.partnerName,
    this.partnerId,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
      child: new Card(
        elevation: 6.0,
        color: Colors.tealAccent,
        child: new Hero(
          tag: prod_image,
          child: new Material(
            child: new InkWell(
                onTap: () {
                  //print('tapped');
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) => new ShopDetailsPage(
                            shopName: partnerName,
                            shopAddress: address,
                            shopId: partnerId,
                            shopIcon: prod_image,
                          ));
                  Navigator.of(context).push(route);
                },
                child: new ListTile(
                  /* title: new Image.network(
                    prod_image,
                    fit: BoxFit.cover,
                      ),*/
                  /*title: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(prod_image),
                    ),*/
                  title: new Image.network(prod_image, width: 50, height: 50),
                  /*subtitle: new Container(
                      alignment: Alignment.center,
                      child: new Text(partnerName, style: new TextStyle(color: Colors.redAccent, fontSize: 14.0),),
                    ),*/
                  subtitle: new Text(
                    partnerName,
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
    );
  }
}
