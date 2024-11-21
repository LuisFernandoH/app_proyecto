import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animus/services/auth_services.dart';
import 'login_screen.dart';
import 'registro_asesino_screen.dart';
import 'eliminar_screen.dart'; // Importar la pantalla de eliminación


class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  late Future<List<String>> _asesinosFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authServices = Provider.of<AuthServices>(context, listen: false);
    // Refrescar la lista de asesinos cada vez que se accede a esta página
    _asesinosFuture = authServices.getAsesinos();
  }

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
          backgroundColor: const Color.fromARGB(255, 82, 82, 82),
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
              ListTile(
                leading: const Icon(Icons.person_remove),
                title: const Text('Eliminar Asesino'),
                onTap: () async {
                  // Aseguramos que el nombre del asesino esté disponible
                  String nombreAsesino = ''; // Aquí deberías obtener el nombre del asesino a eliminar (puedes pasarlo dinámicamente)

                  // Llama a la pantalla de eliminación pasando el nombre del asesino
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EliminarScreen(nombreAsesino: nombreAsesino),
                    ),
                  );
                },
              ),
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
          child: FutureBuilder<List<String>>(
            future: _asesinosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Hubo un error al cargar los nombres de los asesinos',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay asesinos registrados',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
              return PageView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (context, index) {
    String nombreAsesino = snapshot.data![index];
    return FutureBuilder<ImageProvider?>(
      future: authServices.getAsesinoImagen(nombreAsesino),
      builder: (context, imgSnapshot) {
        if (imgSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
          return GestureDetector(
            onTap: () async {
              try {
                final datosAsesino = await authServices.getDatosAsesino(nombreAsesino);

                // Acceder a los datos con las claves correctas
                String nombre = datosAsesino['nombre'] ?? 'Nombre no disponible';
                String apellido = datosAsesino['apellido'] ?? 'Apellido no disponible';
                String descripcion = datosAsesino['descripcion'] ?? 'Descripción no disponible';

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 26, 76, 169),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Text(
                      nombre,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundImage: imgSnapshot.data!,
                          radius: 100,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Apellido: $apellido',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Descripción: $descripcion',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aquí pasamos el nombre del asesino a la pantalla de eliminación
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EliminarScreen(nombreAsesino: nombre),
                            ),
                          );
                        },
                        child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al obtener datos del asesino: $e'),
                  ),
                );
              }
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: imgSnapshot.data!,
                    radius: 150,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nombreAsesino,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  },
);

              }
            },
          ),
        ),
      ),
    );
  }
}
