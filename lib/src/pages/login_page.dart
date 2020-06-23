import 'package:flutter/material.dart';

import 'package:formvalidator/src/bloc/provider.dart';

import 'package:formvalidator/src/pages/home_page.dart';
import 'package:formvalidator/src/pages/registro_page.dart';

import 'package:formvalidator/src/providers/usuario_provider.dart';

import 'package:formvalidator/src/utils/utils.dart' as util;

class LoginPage extends StatelessWidget {

  static final String route = "login";

  final usuarioProvider = UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    final titulo = Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.person_pin_circle,
            color: Colors.white,
            size: 100.0,
          ),
          SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Text(
            'Pablo Garcia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0
            ),
          )
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,

        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),

        titulo,
      ],
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 160.0,
            ),
          ),

          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(3.0, 5.0),
                  spreadRadius: 3.0
                ),
              ]
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Inicio de Sesión',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 40.0,),
                _crearEmail(bloc),
                SizedBox(height: 10.0,),
                _crearPassword(bloc),
                SizedBox(height: 10.0,),
                _crearBoton(context, bloc),
              ],
            ),
          ),
        
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, RegistroPage.route), 
            child: Text('Crear nueva cuenta')
          ),

          SizedBox(height: 300.0,)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(
                Icons.alternate_email,
              ),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo Electronico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );

    
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
              ),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
           ),
           onChanged: bloc.changePassword,
          ),
        );
      },
    );    
  }

  Widget _crearBoton(BuildContext context, LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          onPressed: (snapshot.hasData) ? () => _login(context, bloc) : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Entrar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
        );
      },
    );
  }

  void _login(BuildContext context, LoginBloc bloc) async {
    Map info = await usuarioProvider.loginUsuario(bloc.email, bloc.password);

    if(info['ok']) {
      Navigator.of(context).pushReplacementNamed(HomePage.route);
    } else {
      util.mostrarAlerta(context, 'Error login: ${info['mensaje']} ');
    }
  }
}