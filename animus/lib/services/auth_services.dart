import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'dart:html';

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'Animus.somee.com'; //aqui va la url de nuestro login. no lleva http ni www.
  final storage = new FlutterSecureStorage();

  //este metodo puede regresar string vacio. asincrono pq iremos a la bd a leer info. pa crear usuario
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'Email' : email,
      'Password' : password
    };

    //creamos la url
    final url = Uri.http(_baseUrl, '/api/Cuentas/Registrar');

    //conectamos, lo que regrese el back lo almacena esta variable. consume el servicio. codifica a json.
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    //decodificamos la respuesta
    Map<dynamic, dynamic> decodeResp;
    if(resp.body.contains('code')){
      List<dynamic> decodeResp2 = json.decode(resp.body);
      if (decodeResp2[0].containsKey('description')) {
        print('Error en Password: ${decodeResp2[0]['description']}');
        return decodeResp2[0]['description'];
      }
    }
    decodeResp = json.decode(resp.body);

    //si en decoderesp tengo token, se que regresa el token. y lo escribimos en el disp movil.
    if(decodeResp.containsKey('token')){
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    }
    else if (decodeResp.containsKey('errors')){
      final errors = decodeResp['errors'];
      if (errors.containsKey('Email')) {
        print('Error en Email: ${errors['Email'][0]}');
        return errors['Email'][0];
      }
      if (errors.containsKey('Password')) {
        print('Error en Password: ${errors['Password'][0]}');
        return errors['Password'][0];
      }
    } 
    else {
      return decodeResp['Error'];
    } 
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'Email' : email,
      'Password' : password
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/Login');

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('token')){
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    }
    else if (decodeResp.containsKey('errors')){
      final errors = decodeResp['errors'];
      if (errors.containsKey('Email')) {
        print('Error en Email: ${errors['Email'][0]}');
        return errors['Email'][0];
      }
      if (errors.containsKey('Password')) {
        print('Error en Password: ${errors['Password'][0]}');
        return errors['Password'][0];
      }
    } 
    else {
      return decodeResp['Error'];
    } 
    
  }

 // Método para obtener los nombres de los asesinos
  Future<List<String>> getAsesinos() async {
    final url = Uri.http(_baseUrl, '/api/Asesinos/nombres');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      List<dynamic> nombres = json.decode(resp.body);
      return nombres.cast<String>();
    } else {
      throw Exception('Error al cargar los nombres de los asesinos');
    }
  }

// Método para registrar asesinos
  Future<String?> registrarAsesino(Map<String, String> asesinoData) async {
  final url = Uri.http(_baseUrl, '/api/Asesinos');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(asesinoData),
  );

  if (response.statusCode == 200) {
    return null; // El registro fue exitoso
  } else {
    return 'Error al registrar al asesino';
  }
}

  //PA SABER SI todavia tiene la cuenta activa. si no existe nada regresa vacio, q significa que no esta autenticado
  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  //esto es el logout
  Future logout() async {
    //await storage.deleteAll();
    await storage.delete(key: 'token');
  }


}