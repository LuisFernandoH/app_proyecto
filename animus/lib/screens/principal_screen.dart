import 'package:flutter/material.dart';
import 'package:animus/services/auth_services.dart';
import 'package:provider/provider.dart';

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assassin\'s Creed Login',
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Reemplazo de bodyText2
          labelLarge: TextStyle(fontSize: 20, color: Colors.white), // Reemplazo de button
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Row(
            children: [
              Icon(Icons.shield, color: Colors.red), // Un icono acorde a la temática
              const SizedBox(width: 10),
              const Text(
                'Assassin\'s Creed Login',
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
              colors: [Colors.black87, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenido al Credo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final authService = Provider.of<AuthServices>(context, listen: false);
                      await authService.logout();
                      final token = await authService.storage.read(key: "token");

                      if (token == null) {
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        print('El token aún está presente.');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
