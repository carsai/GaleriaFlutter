import 'package:flutter/material.dart';

import 'package:formvalidator/src/bloc/login_bloc.dart';
export 'package:formvalidator/src/bloc/login_bloc.dart';

import 'package:formvalidator/src/bloc/productos_bloc.dart';
export 'package:formvalidator/src/bloc/productos_bloc.dart';

class Provider extends InheritedWidget{

  final loginBLoc     = LoginBloc();
  final _productosBloc = ProductosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  LoginBloc get loginBloc => loginBLoc;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }

}
