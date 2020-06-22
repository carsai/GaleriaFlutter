import 'package:flutter/material.dart';
import 'package:formvalidator/src/utils/utils.dart' as utils;

class ProductoPage extends StatelessWidget {

  static final String route = 'producto';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: () {}
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearNombre(),
                _crearprecio(),
                _crearBoton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearprecio() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      validator: (value) {
        if (!utils.esNumero(value)) {
          return 'No es un numero valido';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      icon: Icon(Icons.save),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      label: Text('Guardar'),
      onPressed: _submit,

    );
  }

  void _submit() {
    formKey.currentState.validate();
  }

}