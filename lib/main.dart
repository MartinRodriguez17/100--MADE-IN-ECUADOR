import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart'; // Importamos la primera pantalla que se va a mostrar al abrir la app

// El método main es el punto de inicio obligatorio de cualquier aplicación en Flutter/Dart
void main() {
  runApp(const MyApp()); // Inicializa y lanza el widget principal que va a contener todo el proyecto
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Desactivamos la etiqueta roja molesta de "DEBUG" que sale por defecto en la esquina de la pantalla
      debugShowCheckedModeBanner: false,
      title: 'MADE IN ECUADOR',
      
      // Configuramos el diseño visual y los colores base que se van a heredar en toda la interfaz de la app
      theme: ThemeData(
        brightness: Brightness.dark, // Configuramos por defecto el modo oscuro para el diseño de la interfaz
        scaffoldBackgroundColor: const Color.fromARGB(255, 237, 240, 59), // Definimos el fondo personalizado oscuro urbano
      ),
      
      // Definimos cuál va a ser la primera vista o pantalla que se renderice al arrancar la aplicación
      home: const SplashScreen(),
    );
  }
}