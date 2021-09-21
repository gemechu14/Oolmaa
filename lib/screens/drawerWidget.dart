import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        elevation: defaultTargetPlatform==TargetPlatform.android?5.5:0.0,
        child: ListView(children: [
          DrawerHeader(
           
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                Colors.deepOrange,
                Colors.orangeAccent,
                Colors.black
              ]),
            ),
           child: Container(
             margin: EdgeInsets.only(top: 50,left:50 ),
             child: Text("My Tasks")),
          ),
        
            ListTile(
             
              title: Text("Setting"),
              leading: Icon(Icons.settings),
              
            ),
      
          ListTile(
            title: Text("Share"),
            leading: Icon(Icons.share),
          ),
          ListTile(
            title: Text("Rate Us"),
            leading: Icon(Icons.rate_review_outlined),
          )
        ]),
      ),
    );
  }
}

class CustomListT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.black,
        onTap: () {},
        child: Container(
          height: 40.0,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.perm_camera_mic),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Camera"),
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
