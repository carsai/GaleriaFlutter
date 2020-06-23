import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formvalidator/src/models/producto_model.dart';

import 'package:formvalidator/src/providers/productos_provider.dart';

import 'package:formvalidator/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {

  static final String route = 'producto';

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final _formKey     = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductoModel _producto = ProductoModel();
  bool _guardando = false;
  PickedFile foto;

  final _productoProvider = ProductosProvider();

  @override
  Widget build(BuildContext context) {

    final productoData = ModalRoute.of(context).settings.arguments;

    if (productoData != null) {
      _producto = productoData;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: _seleccionarFoto
          ),
          IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: _tomarFoto
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(context),
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
      initialValue: _producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (newValue) => _producto.titulo = newValue,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: _producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (newValue) => _producto.valor = double.parse(newValue),
      validator: (value) {
        if (!utils.esNumero(value)) {
          return 'No es un numero valido';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearDisponible(BuildContext context) {
    return SwitchListTile(
      value: _producto.disponible, 
      onChanged: (value) => setState(() => _producto.disponible = value),
      title: Text('Disponible'),
      activeColor: Theme.of(context).primaryColor,
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
      label: (_producto.id == null) ? Text('Guardar') : Text('Modificar'),
      onPressed: (_guardando) ? null : _submit,

    );
  }

  void _submit() async {
    if ( !_formKey.currentState.validate() ) return;

    _formKey.currentState.save();

    setState(() => _guardando = true);

    if (foto != null) {
      _producto.fotoURL = await _productoProvider.subirImage(foto);
    }

    if (_producto.id == null) {
      await _productoProvider.crearProducto(_producto);
    } else {
      await _productoProvider.modificarproducto(_producto);
    }

    setState(() => _guardando = false);

    _mostrarSnackbar('Producto guardado');

    Navigator.pop(context);

  }

  void _mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (_producto.fotoURL != null) {
      return (_producto.fotoURL == null)
              ? Image(image: AssetImage('assets/img/no-image.png'))
              : FadeInImage(
                placeholder: AssetImage('assets/img/jar-loading.gif'), 
                image: NetworkImage(_producto.fotoURL),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              );
    } else {
      return Image(
        image: AssetImage( foto?.path ?? 'assets/img/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery); 
  }

  void _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  void _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker().getImage(
      source: origen
    );

    if (foto != null) {
      _producto.fotoURL = null;
    }

    setState(() {});
  }
}