import 'package:admin_dashboard/models/category.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/api/cafe_api.dart';

import 'package:admin_dashboard/models/http/categories_response.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> categorias = [];

  getCategorias() async {
    final response = await CafeApi.httpGet('/categorias');
    final categoriesResponse = CategoriesResponse.fromMap(response);
    this.categorias = [...categoriesResponse.categorias];
    notifyListeners();
  }

  Future crearCategoria(String nombre) async {
    final data = {'nombre': nombre};
    try {
      final response = await CafeApi.httpPost('/categorias', data);
      final newCategory = Category.fromMap(response);
      this.categorias.add(newCategory);
      notifyListeners();
    } catch (e) {
      getCategorias();
      throw ('Error de Creación: $e');
    }
  }

  Future actualizarCategoria(String id, String nombre) async {
    final data = {'nombre': nombre};
    try {
      await CafeApi.httpPut('/categorias/$id', data);
      this.categorias = this.categorias.map((cat) {
        if (cat.id != id) return cat;
        cat.nombre = nombre;
        return cat;
      }).toList();
      notifyListeners();
    } catch (_) {
      throw ('Error de Actualización');
    }
  }

  Future borrarCategoria(String id) async {
    try {
      await CafeApi.httpGet('/categorias/$id');
      this.categorias.removeWhere((cat) => cat.id == id);
      notifyListeners();
    } catch (_) {
      throw ('Error al Actualizar Categoria');
    }
  }
}
