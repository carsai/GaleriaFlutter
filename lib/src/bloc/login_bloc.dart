import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidator/src/bloc/validator.dart';

class LoginBloc with Validator {

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  /*
  final _emailController    = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();
  */

  // Recuperar datos del Stream
  Stream<String> get emailStream    => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores en el Stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }

}