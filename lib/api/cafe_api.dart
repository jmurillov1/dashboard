import 'dart:typed_data';

import 'package:admin_dashboard/services/local_storage.dart';
import 'package:dio/dio.dart';

class CafeApi {
  static Dio _dio = new Dio();

  static void configureDio() {
    //base de url desarrollo
    //_dio.options.baseUrl = 'http://localhost:8080/api';
    //base url Aprodución
    _dio.options.baseUrl = 'https://flutter-dashboard-jm.herokuapp.com/api';
    //Configurar headers
    _dio.options.headers = {
      'x-token': LocalStorage.prefs.getString('token') ?? ''
    };
  }

  static Future httpGet(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        if (e.response!.data['errors'] != null)
          throw (e.response!.data['errors'][0]['msg']);
        else
          throw (e.response!.data['msg']);
      } else
        throw ('Error en el GET');
    }
  }

  static Future httpPost(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    try {
      final response = await _dio.post(path, data: formData);
      return response.data;
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        if (e.response!.data['errors'] != null)
          throw (e.response!.data['errors'][0]['msg']);
        else
          throw (e.response!.data['msg']);
      } else
        throw ('Error en el POST');
    }
  }

  static Future httpPut(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    try {
      final response = await _dio.put(path, data: formData);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      if (e.response!.statusCode == 400) {
        if (e.response!.data['errors'] != null)
          throw (e.response!.data['errors'][0]['msg']);
        else
          throw (e.response!.data['msg']);
      } else
        throw ('Error en el PUT');
    }
  }

  static Future httpDelete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        if (e.response!.data['errors'] != null)
          throw (e.response!.data['errors'][0]['msg']);
        else
          throw (e.response!.data['msg']);
      } else
        throw ('Error en el DELETE');
    }
  }

  static Future uploadFile(String path, Uint8List bytes) async {
    final formData = FormData.fromMap({
      'archivo': MultipartFile.fromBytes(bytes),
    });
    try {
      final response = await _dio.put(path, data: formData);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      if (e.response!.statusCode == 400) {
        if (e.response!.data['errors'] != null)
          throw (e.response!.data['errors'][0]['msg']);
        else
          throw (e.response!.data['msg']);
      } else
        throw ('Error en el Upload Image');
    }
  }
}
