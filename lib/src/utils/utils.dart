import 'package:flutter/material.dart';

bool esNumero(String valor) {
  if (valor.isEmpty)
    return false;

  final n = num.tryParse(valor);

  return (n == null) ? false : true;
  
}

void mostrarAlerta(BuildContext context, String mensaje, {String titulo}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo ?? 'Informacion'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('OK')
          )
        ],
      );
    },
  );
}