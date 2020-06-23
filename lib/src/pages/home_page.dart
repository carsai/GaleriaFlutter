import 'package:flutter/material.dart';

import 'package:formvalidator/src/bloc/provider.dart';

import 'package:formvalidator/src/models/producto_model.dart';

import 'package:formvalidator/src/pages/productor_page.dart';

class HomePage extends StatelessWidget {
  
  static final route = "home";

  @override
  Widget build(BuildContext context) {

    final productoBloc = Provider.productosBloc(context);
    productoBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(productoBloc),
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

  Widget _crearListado(ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productoStream,
      builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItems(context, productos[i], productosBloc),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Widget _crearItems( BuildContext context, ProductoModel producto, ProductosBloc productosBloc ) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => productosBloc.eliminarProducto(producto.id),
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
              onTap: () => Navigator.pushNamed(
                context, ProductoPage.route, 
                arguments: producto
              ),
            )
          ],
        ),
      ),
    );
  }
}