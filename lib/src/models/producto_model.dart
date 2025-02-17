import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {

    ProductoModel({
        this.id,
        this.titulo     = '',
        this.valor      = 0.0,
        this.disponible = true,
        this.fotoURL,
    });

    String id;
    String titulo;
    double valor;
    bool disponible;
    String fotoURL;

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id         : json["id"],
        titulo     : json["titulo"],
        valor      : json["valor"].toDouble(),
        disponible : json["disponible"],
        fotoURL    : json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "titulo"     : titulo,
        "valor"      : valor,
        "disponible" : disponible,
        "fotoUrl"    : fotoURL,
    };
}