import 'package:flutter/material.dart';
import 'auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Al cargar la pantalla por primera vez, disparamos el método que maneja la redirección automatizada
    _irAAuth();
  }

  // Método asíncrono para aguantar la pantalla de bienvenida un momento antes de mandarnos al Login/Registro
  void _irAAuth() async {
    // Seteamos un delay corto de 1.8 segundos para que el usuario logre leer el mensaje de soporte local
    await Future.delayed(const Duration(milliseconds: 1800));
    
    // Validamos con mounted que el widget siga activo en la interfaz para evitar excepciones al navegar
    if (mounted) {
      // Reemplazamos la pantalla actual por la de Auth para limpiar el árbol y que no se pueda regresar aquí
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          // Duración de la animación de entrada para la siguiente interfaz (800ms)
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const AuthScreen(),
          // Implementamos una transición de Fade para desvanecer la bienvenida e introducir el login sutilmente
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          // Agregamos un espaciado horizontal simétrico para que los textos no peguen a los bordes de la pantalla
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título principal de bienvenida en tipografía negrita resaltada
              Text(
                "¡Bienvenido!",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 28, 24, 255),
                ),
              ),
              const SizedBox(height: 16),
              // Texto secundario que describe el propósito y la misión de la aplicación móvil en el país
              Text(
                "Apoyando al talento y diseño de ropa independiente en Ecuador",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                  height: 1.5, // Ajustamos la altura de línea para mejorar la legibilidad del párrafo
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}