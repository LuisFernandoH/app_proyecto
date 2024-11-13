import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
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
  File? _image;  // Variable para almacenar la imagen seleccionada

  final ImagePicker _picker = ImagePicker();

  // Método para seleccionar la imagen
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Puedes cambiar a ImageSource.camera si quieres usar la cámara.
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del Asesino'),
        backgroundColor: const Color.fromARGB(221, 139, 139, 139),
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
            const SizedBox(height: 20),
            // Mostrar la imagen seleccionada
            _image != null
                ? Image.file(_image!, height: 150, width: 150, fit: BoxFit.cover)
                : const Text('No se ha seleccionado ninguna imagen'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Convertir la imagen a base64
                String? imageBase64;
                if (_image != null) {
                  final bytes = await _image!.readAsBytes();
                  imageBase64 = base64Encode(bytes); // Convertimos la imagen a base64
                }

                // Crear el objeto para enviar
                final asesinoData = {
                  'nombre': _nombreController.text,
                  'apellido': _apellidoController.text,
                  'descripcion': _descripcionController.text,
                  'imagen': imageBase64, // Incluir la imagen codificada en base64
                };

                // Realizar la solicitud a la API
                final url = Uri.http('Animus.somee.com', '/api/Asesinos');
                final response = await http.post(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(asesinoData),
                );

                if (response.statusCode == 200) {
                  // Si la respuesta es exitosa, mostrar un mensaje y regresar
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
