import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:formvalidator/src/preferencias_usuario/preferencias_usuario.dart';

class UsuarioProvider {

  final _fireBaseToken = 'AIzaSyCACkQCMM_4UlmfbsvZcDgLg0cNupQ6Kd0';
  final _pref = PreferenciasUsuario();

  Future <Map<String, dynamic>> loginUsuario(String email, String password) async {
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_fireBaseToken';

    final respuesta = await http.post(
      url,
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(respuesta.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      
      _pref.token = decodeResp['idToken'];

      return {
        'ok'    : true,
        'token' : decodeResp['idToken']
        };
    } else {
      return {
        'ok'      : false,
        'mensaje' : decodeResp['error']['message']
        };
    }

  }

  Future <Map<String, dynamic>> nuevoUsuario(String email, String password) async {

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_fireBaseToken';

    final respuesta = await http.post(
      url,
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(respuesta.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      
      _pref.token = decodeResp['idToken'];

      return {
        'ok'    : true,
        'token' : decodeResp['idToken']
        };
    } else {
      return {
        'ok'      : false,
        'mensaje' : decodeResp['error']['message']
        };
    }

  }

}