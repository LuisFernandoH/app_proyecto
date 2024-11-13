import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registro_asesino_screen.dart'; // Importa el archivo donde tienes el RegistroAsesinoScreen.
import 'package:animus/services/auth_services.dart'; // Asegúrate de usar la ruta correcta

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context, listen: false);

    return MaterialApp(
      title: 'Assassin\'s Creed',
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          labelLarge: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://static.wikia.nocookie.net/theassassinscreed/images/0/0a/Abstergo-FH.png/revision/latest?cb=20180629071736&path-prefix=es',
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Text(
                'Bienvenido al Animus',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(221, 6, 25, 59), Color.fromARGB(221, 26, 76, 169)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistroAsesinoScreen(),
                      ),
                    );
                  },
                  child: const Text('Registrar Asesino'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 146, 146, 146),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<String>>(
                  future: authServices.getAsesinos(), // Llama a la función de obtener nombres
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Hubo un error al cargar los nombres de los asesinos',
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        'No hay asesinos registrados',
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return Column(
                        children: snapshot.data!.map((nombre) => Text(nombre, style: const TextStyle(color: Colors.white))).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
