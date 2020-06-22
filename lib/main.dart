import 'package:flutter/material.dart';
import 'package:formvalidator/src/bloc/provider.dart';

import 'package:formvalidator/src/pages/home_page.dart';
import 'package:formvalidator/src/pages/login_page.dart';
import 'package:formvalidator/src/pages/productor_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: HomePage.route,
        routes: {
          LoginPage.route    : (context) => LoginPage(),
          HomePage.route     : (context) => HomePage(),
          ProductoPage.route : (context) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
    
    
  }
}