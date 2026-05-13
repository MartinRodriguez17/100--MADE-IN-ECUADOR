import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Apenas se inicializa este componente, llamamos a la función que maneja el tiempo de espera
    _irABienvenida();
  }

  // Función asíncrona para controlar el tiempo que dura la pantalla de carga antes de pasar a la siguiente
  void _irABienvenida() async {
    // Simulamos un delay de 2.5 segundos para que se alcance a ver el logo y el loader
    await Future.delayed(const Duration(milliseconds: 2500));
    
    // El mounted sirve para verificar que el widget siga existiendo en el árbol antes de meter el Navigator
    if (mounted) {
      // Usamos pushReplacement para destruir esta pantalla y que el usuario no pueda regresar a ella con el botón de atrás
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          // Duración de la animación de transición (800 milisegundos)
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const WelcomeScreen(),
          // Configuramos una transición personalizada de tipo Fade (desvanecimiento) para que se vea más pro
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono principal de la tienda en color cyan para mantener la identidad visual
            Icon(
              Icons.storefront_outlined,
              size: 90,
              color: Color.fromARGB(255, 28, 24, 255),
            ),
            const SizedBox(height: 24),
            // Eslogan principal del proyecto centrado en el emprendimiento local
            Text(
              "MADE IN ECUADOR",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 3, // Separación entre letras para darle un toque más moderno
                color: Color.fromARGB(255, 28, 24, 255) ,
              ),
            ),
            const SizedBox(height: 30),
            // Indicador de carga circular animado que le avisa al usuario que la app está respondiendo
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 28, 24, 255)),
            ),
          ],
        ),
      ),
    );
  }
}