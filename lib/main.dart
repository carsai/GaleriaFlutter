import 'package:flutter/material.dart';
import 'package:formvalidator/src/bloc/provider.dart';

import 'package:formvalidator/src/pages/home_page.dart';
import 'package:formvalidator/src/pages/login_page.dart';
import 'package:formvalidator/src/pages/productor_page.dart';
import 'package:formvalidator/src/pages/registro_page.dart';

import 'package:formvalidator/src/preferencias_usuario/preferencias_usuario.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = PreferenciasUsuario();

    print('Token actual: ${prefs.token}');

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: LoginPage.route,
        routes: {
          LoginPage.route    : (context) => LoginPage(),
          HomePage.route     : (context) => HomePage(),
          ProductoPage.route : (context) => ProductoPage(),
          RegistroPage.route : (context) => RegistroPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
    
    
  }
}