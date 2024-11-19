import 'package:animus/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registro_asesino_screen.dart';
import 'package:animus/services/auth_services.dart';

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
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(221, 6, 25, 59), Color.fromARGB(221, 26, 76, 169)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://abstergo.org/wp-content/uploads/2016/06/cropped-abstergo-logo-new-movie-1.png',
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            const Text(
              'Opciones',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
      // Opción para cerrar sesión
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Cerrar sesión'),
        onTap: () async {
          await authServices.logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ),
      // Opción para registrar asesino
      ListTile(
        leading: const Icon(Icons.person_add),
        title: const Text('Registrar Asesino'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarAsesino()),
          );
        },
      ),
    ],
  ),
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
                const SizedBox(height: 20),
                FutureBuilder<List<String>>(
                  future: authServices.getAsesinos(),
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
                      return Expanded(
                        child: PageView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            String nombreAsesino = snapshot.data![index];
                            return FutureBuilder<ImageProvider?>(
                              future: authServices.getAsesinoImagen(nombreAsesino),
                              builder: (context, imgSnapshot) {
                                if (imgSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (imgSnapshot.hasError || !imgSnapshot.hasData) {
                                  return Center(
                                    child: ListTile(
                                      title: Text(
                                        nombreAsesino,
                                        style: const TextStyle(color: Colors.white, fontSize: 22),
                                      ),
                                      leading: const Icon(Icons.error, color: Colors.red),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: imgSnapshot.data!,
                                          radius: 150,  // Tamaño de la imagen
                                        ),
                                        const SizedBox(height: 10), // Espacio entre la imagen y el nombre
                                        Text(
                                          nombreAsesino,
                                          style: const TextStyle(color: Colors.white, fontSize: 22),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
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
