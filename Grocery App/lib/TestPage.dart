import 'package:flutter/material.dart';

class BodyLayout extends StatefulWidget {
      @override
      BodyLayoutState createState() {
        return new BodyLayoutState();
      }
    }

    class BodyLayoutState extends State<BodyLayout> {

      List<String> titles = ['Sun', 'Moon', 'Star'];

      @override
      Widget build(BuildContext context) {
        return _myListView();
      }

      Widget _myListView() {
        return ListView.builder(
          itemCount: titles.length,
          itemBuilder: (context, index) {
            final item = titles[index];
            return Card(
              child: ListTile(
                title: Text(item),

                /*onTap: () { //                                  <-- onTap
                  setState(() {
                    titles.insert(index, 'Planet');
                  });
                },*/

                onTap: () { //                            <-- onLongPress
                  setState(() {
                    titles.removeAt(index);
                  });
                },

              ),
            );
          },
        );
      }
    }