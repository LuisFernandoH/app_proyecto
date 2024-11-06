import 'package:flutter/material.dart';
import 'package:animus/providers/login_form_provider.dart';
import 'package:animus/services/auth_services.dart';
import 'package:animus/services/notifications_services.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatelessWidget {
  RegistroScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E1E1E), // color oscuro de fondo
              Color(0xFF444444), // gradiente gris medio
              Color(0xFF8C8C8C), // gradiente gris claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o Imagen Decorativa
              Container(
                width: size.width * 0.6,
                height: size.height * 0.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('../assets/images/assassins_creed_logo.png'), // Coloca el logo en tu carpeta de assets
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Campo de Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'ejemplo@email.com',
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF303030),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Campo de Contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF303030),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Botón Olvidaste tu contraseña
              TextButton(
                onPressed: () {
                  // Acción de recuperación de contraseña
                },
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: Color.fromARGB(255, 255, 244, 244)),
                ),
              ),
              // Botón de Registro
              ElevatedButton(
                onPressed: () async {
                  final authService = Provider.of<AuthServices>(context, listen: false);
                  final String? errorMessage = await authService.createUser(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (errorMessage == null) {
                    Navigator.pushReplacementNamed(context, 'login');
                  } else {
                    NotificationsServices.showSnackbar(errorMessage);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 181, 184, 187),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
                  'Registra tu usuario',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 250, 253, 247),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Botón para Iniciar Sesión si ya tiene cuenta
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: const Text(
                  '¿Ya tienes una cuenta? Inicia sesión',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 244, 244),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
