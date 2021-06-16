// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        required this.correo,
        required this.edad,
        required this.nombre,
    });

    String nombre;
    int edad;
    String correo;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nombre: json["nombre"],
        edad: json["edad"],
        correo: json["correo"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "edad": edad,
        "correo": correo,
    };
}
