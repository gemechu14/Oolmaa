import 'package:flutter/material.dart';
import 'package:wallet/screens/homepage.dart';


Future<void> main() async{
  runApp(MyTask());
}

class MyTask extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      title: ' My Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
      
      ),
      home: HomePage("My Tasks"),
    );
  }
}

