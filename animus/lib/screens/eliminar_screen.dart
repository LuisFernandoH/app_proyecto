import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animus/services/auth_services.dart';

class EliminarScreen extends StatelessWidget {
  final String nombreAsesino; // Recibimos el nombre del asesino

  const EliminarScreen({super.key, required this.nombreAsesino});

  @override
  Widget build(BuildContext context) {
    // Obtener la instancia de AuthServices usando Provider
    final authServices = Provider.of<AuthServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eliminar Asesino'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Estás seguro de eliminar al asesino: $nombreAsesino?',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Llamada al método eliminarAsesino de AuthServices
                  await authServices.eliminarAsesino(nombreAsesino);

                  // Mensaje de confirmación si la eliminación fue exitosa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Asesino $nombreAsesino eliminado')),
                  );

                  // Volver a la pantalla anterior después de la eliminación
                  Navigator.pop(context);
                } catch (e) {
                  // Si ocurre un error, mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar el asesino: $e')),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ),
    );
  }
}
