import 'package:admin_dashboard/models/http/users_response.dart';
import 'package:admin_dashboard/models/usuario.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/api/cafe_api.dart';

class UsersProvider extends ChangeNotifier {
  List<Usuario> users = [];
  bool isLoading = true;
  bool order = true;
  int? sortColumnIndex;

  UsersProvider() {
    this.getPaginatedUsers();
  }

  getPaginatedUsers() async {
    final response = await CafeApi.httpGet('/usuarios?limite=100&desde=0');
    final usersResponse = UsersResponse.fromMap(response);
    this.users = [...usersResponse.usuarios];
    isLoading = false;
    notifyListeners();
  }

  void sort<T>(Comparable<T> Function(Usuario user) getField) {
    users.sort((ua, ub) {
      final aValue = getField(ua);
      final bValue = getField(ub);
      return order
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    order = !order;
    notifyListeners();
  }

  Future<Usuario> getUserById(String id) async {
    try {
      final response = await CafeApi.httpGet('/usuarios/$id');
      final user = Usuario.fromMap(response);
      return user;
    } catch (e) {
      throw ('Error de Busquedá : $e');
    }
  }

  void refreshUsers(Usuario newUser) {
    this.users = this.users.map((user) {
      if (user.uid != newUser.uid) return user;
      return newUser;
    }).toList();
    notifyListeners();
  }
}
