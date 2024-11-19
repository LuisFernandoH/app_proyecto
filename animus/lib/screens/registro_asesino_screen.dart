import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; // To get MIME type

class RegistrarAsesino extends StatefulWidget {
  @override
  _RegistrarAsesinoState createState() => _RegistrarAsesinoState();
}

class _RegistrarAsesinoState extends State<RegistrarAsesino> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _descripcionController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerAssassin() async {
    setState(() {
      _isLoading = true;
    });

    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final descripcion = _descripcionController.text.trim();

    if (nombre.isEmpty || apellido.isEmpty || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una imagen')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      var uri = Uri.parse('http://Animus.somee.com/api/Asesinos');
      var request = http.MultipartRequest('POST', uri)
        ..fields['nombre'] = nombre
        ..fields['apellido'] = apellido
        ..fields['descripcion'] = descripcion;

      // Add the image as a multipart file
      var mimeType = lookupMimeType(_image!.path);
      var imageBytes = await _image!.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'imagen', 
        imageBytes, 
        filename: _image!.path.split('/').last,
        contentType: MediaType.parse(mimeType!),
      );
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asesino registrado con éxito')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del Asesino'),
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
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            if (_image != null) ...[
              Image.file(_image!),
            ],
            ElevatedButton(
              onPressed: _isLoading ? null : _registerAssassin,
              child: _isLoading ? CircularProgressIndicator() : const Text('Registrar Asesino'),
            ),
          ],
        ),
      ),
    );
  }
}
