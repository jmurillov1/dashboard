import 'dart:convert';

import 'package:admin_dashboard/models/category.dart';

class CategoriesResponse {
  CategoriesResponse({
    required this.total,
    required this.categorias,
  });

  int total;
  List<Category> categorias;

  factory CategoriesResponse.fromJson(String str) =>
      CategoriesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoriesResponse.fromMap(Map<String, dynamic> json) =>
      CategoriesResponse(
        total: json["total"],
        categorias: List<Category>.from(
            json["categorias"].map((x) => Category.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "categorias": List<dynamic>.from(categorias.map((x) => x.toMap())),
      };
}
