import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

import 'package:formvalidator/src/preferencias_usuario/preferencias_usuario.dart';

import 'package:formvalidator/src/models/producto_model.dart';

class ProductosProvider {

  final _url   = 'https://flutter-varios-193f5.firebaseio.com';
  final _prefs = PreferenciasUsuario();

  Future<bool> crearProducto( ProductoModel producto ) async {
    
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final respuesta = await http.post(
      url,
      body: productoModelToJson(producto)
    );

    final decodeData = json.decode(respuesta.body);

    print(decodeData);

    return true;

  }

  Future<bool> modificarproducto( ProductoModel producto ) async {
    
    final url = '$_url/productos/${producto.id}.json';

    final respuesta = await http.put(
      url,
      body: productoModelToJson(producto)
    );

    final decodeData = json.decode(respuesta.body);

    print(decodeData);

    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async {    

    final url = '$_url/productos.json?auth=${_prefs.token}';

    final respuesta = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(respuesta.body);

    if (decodeData == null) return [];

    final listaProducto = List<ProductoModel>();

    decodeData.forEach((id, producto) {
      final productoAux = ProductoModel.fromJson(producto);
      productoAux.id = id;

      listaProducto.add(productoAux);
     });

    return listaProducto;

  }

  Future<int> borrarProducto(String id) async {

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';

    final respuesta = await http.delete(url);

    final decodeData = json.decode(respuesta.body);

    print(decodeData);

    return 1;

  }

  Future<String> subirImage(PickedFile foto) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwjgeqegn/image/upload?upload_preset=ya6v70zc');

    final mimeType = mime(foto.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath('file', foto.path, contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final respuesta = await http.Response.fromStream(streamResponse);

    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) {
      print('Error subiendo imagen');
      print(respuesta.body);
      return null;
    }

    final responData = json.decode(respuesta.body);

    print('ResponeData: $responData');

    return responData['secure_url'];

  }

}