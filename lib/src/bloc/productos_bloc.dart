import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidator/src/providers/productos_provider.dart';
import 'package:formvalidator/src/models/producto_model.dart';

class ProductosBloc {

  final _productoController = BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _productosProviders = ProductosProvider();

  Stream<List<ProductoModel>> get productoStream => _productoController.stream;
                 Stream<bool> get cargando       => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productosProviders.cargarProductos();
    _productoController.sink.add(productos);
  }

  void agregarProducto (ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProviders.crearProducto(producto);
    cargarProductos();
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto (PickedFile foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProviders.subirImage(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  void modificarProducto (ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProviders.modificarProducto(producto);
    cargarProductos();
    _cargandoController.sink.add(false);
  }

  void eliminarProducto (String id) async => await _productosProviders.borrarProducto(id);

  dispose() {
    _productoController?.close();
    _cargandoController?.close();
  }

}