import 'package:flutter/material.dart';
import 'package:formvalidator/src/bloc/provider.dart';
import 'package:formvalidator/src/pages/productor_page.dart';

class HomePage extends StatelessWidget {

  static final String route = "home";

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Container(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pushNamed(ProductoPage.route),
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add),
    );
  }
}