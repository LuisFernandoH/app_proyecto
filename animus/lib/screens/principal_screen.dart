import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registro_asesino_screen.dart'; // Importa el archivo donde tienes el RegistroAsesinoScreen.
import 'package:animus/services/auth_services.dart'; // Asegúrate de usar la ruta correcta


class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assassin\'s Creed',
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          labelLarge: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Row(
            children: [
              Image.network(
           'https://static.wikia.nocookie.net/theassassinscreed/images/0/0a/Abstergo-FH.png/revision/latest?cb=20180629071736&path-prefix=es', // Reemplaza con la URL de tu imagen
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(221, 6, 25, 59), Color.fromARGB(221, 26, 76, 169)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Aquí agregamos la navegación a la pantalla de registro de asesino
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistroAsesinoScreen(),
                    ),
                  );
                },
                child: Text('Registrar Asesino'),
                style: ElevatedButton.styleFrom(
                 backgroundColor: const Color.fromARGB(255, 146, 146, 146), // Color de fondo, // Color del botón
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              FutureBuilder<List<String>>(
                future: Provider.of<AuthServices>(context, listen: false).getAsesinos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No se encontraron asesinos', style: TextStyle(color: Colors.white)));
                  } else {
                    final asesinos = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: asesinos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            asesinos[index],
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          leading: Icon(Icons.person, color: Colors.redAccent),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
