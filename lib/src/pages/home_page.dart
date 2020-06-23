import 'package:flutter/material.dart';

import 'package:formvalidator/src/models/producto_model.dart';

import 'package:formvalidator/src/pages/productor_page.dart';

import 'package:formvalidator/src/providers/productos_provider.dart';

// TODO -> Cambiar a StatelessWidget
class HomePage extends StatefulWidget {

  static final String route = "home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = ProductosProvider();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      // TODO _> QUITAR THEN
      onPressed: () => Navigator.of(context).pushNamed(ProductoPage.route).then((value) => setState((){})),
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItems(context, productos[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItems( BuildContext context, ProductoModel producto ) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => productosProvider.borrarProducto(producto.id),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.red,
        child: Row(          
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white,),
            Text('Eliminar', style: TextStyle(color: Colors.white),),
            Spacer(),
          ],
        ),
      ),
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoURL == null)
              ? Image(image: AssetImage('assets/img/no-image.png'))
              : FadeInImage(
                placeholder: AssetImage('assets/img/jar-loading.gif'), 
                image: NetworkImage(producto.fotoURL),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text(producto.id),
              // TODO _> QUITAR THEN
              onTap: () => Navigator.pushNamed(
                context, ProductoPage.route, 
                arguments: producto
              ).then((value) => setState((){})),
            )
          ],
        ),
      ),
    );
  }
}