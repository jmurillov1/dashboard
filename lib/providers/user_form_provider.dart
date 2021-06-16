import 'dart:typed_data';

import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/models/usuario.dart';

class UserFormProvider extends ChangeNotifier {
  Usuario? usuario;
  late GlobalKey<FormState> formKey;

  copyUserWith({
    String? rol,
    bool? estado,
    bool? google,
    String? nombre,
    String? correo,
    String? uid,
    String? img,
  }) {
    usuario = new Usuario(
      rol: rol ?? this.usuario!.rol,
      estado: estado ?? this.usuario!.estado,
      google: google ?? this.usuario!.google,
      nombre: nombre ?? this.usuario!.nombre,
      correo: correo ?? this.usuario!.correo,
      uid: uid ?? this.usuario!.uid,
      img: img ?? this.usuario!.img,
    );

    notifyListeners();
  }

  bool _validateForm() => formKey.currentState!.validate() ? true : false;

  Future updateUser() async {
    if (!this._validateForm()) return false;
    final data = {'nombre': usuario!.nombre, 'correo': usuario!.correo};
    try {
      await CafeApi.httpPut('/usuarios/${usuario!.uid}', data);
      return true;
    } catch (e) {
      throw ('Error en actualización de usuario $e');
    }
  }

  Future<Usuario> updateImage(Uint8List bytes) async {
    try {
      final response =
          await CafeApi.uploadFile('/uploads/usuarios/${usuario!.uid}', bytes);
      usuario = Usuario.fromMap(response);
      notifyListeners();
      return usuario!;
    } catch (e) {
      throw ('Error en actualización de la imagen: $e');
    }
  }
}
