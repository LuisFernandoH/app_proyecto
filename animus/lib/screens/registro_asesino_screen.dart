import 'package:flutter/material.dart';
import 'package:animus/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroAsesinoScreen extends StatefulWidget {
  const RegistroAsesinoScreen({super.key});

  @override
  _RegistroAsesinoScreenState createState() => _RegistroAsesinoScreenState();
}

class _RegistroAsesinoScreenState extends State<RegistroAsesinoScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _descripcionController = TextEditingController();
  // Aquí puedes agregar un controlador para la imagen si la necesitas.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del Asesino'),
        backgroundColor: const Color.fromARGB(221, 209, 209, 209),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            // Agregar un campo para cargar una imagen si lo necesitas.
            // TextField(controller: _imagenController, decoration: const InputDecoration(labelText: 'Imagen URL o cargada'),),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Llamar a la API para registrar el asesino
                final asesinoData = {
                  'nombre': _nombreController.text,
                  'apellido': _apellidoController.text,
                  'descripcion': _descripcionController.text,
                  // 'imagen': imagenData, // Aquí deberías manejar la imagen
                };

                final url = Uri.http('Animus.somee.com', '/api/Asesinos');
                final response = await http.post(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(asesinoData),
                );

                if (response.statusCode == 200) {
                  // Si la respuesta es exitosa, podrías mostrar un mensaje y redirigir al usuario
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Asesino registrado con éxito')));
                  Navigator.pop(context);  // Regresar a la pantalla principal
                } else {
                  // Si hay un error, mostrar un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar el asesino')));
                }
              },
              child: const Text('Registrar Asesino'),
            ),
          ],
        ),
      ),
    );
  }
}
