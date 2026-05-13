import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_auth_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Esta variable controla si mostramos la vista de Login (true) o la de Registro (false)
  bool _mostrarLogin = true;

  // Claves globales para controlar y validar los estados de ambos formularios
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Controladores para capturar y manipular el texto que ingresa el usuario
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emprendimientoController = TextEditingController();
  final _telefonoController = TextEditingController();
  
  // Variable booleana para el switch (para saber si el usuario es vendedor o comprador)
  bool _esEmprendedor = false;

  int _contadorToquesAdmin = 0;
  DateTime? _ultimoToqueAdmin;

  @override
  void dispose() {
    // Es buena práctica liberar los controladores de la memoria cuando ya no se usa la pantalla
    _emailController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    _emprendimientoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // --- VALIDACIONES CON EXPRESIONES REGULARES (RegExp) ---

  // Función para validar que el correo no esté vacío y que tenga un formato real con @ y dominio
  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu correo';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido (ej: usuario@correo.com)';
    }
    return null;
  }

  // Función para validar que el nombre no esté vacío y que use únicamente letras y espacios
  String? _validarNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final nombreRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nombreRegex.hasMatch(value)) {
      return 'El nombre no debe contener números ni caracteres especiales';
    }
    return null;
  }

  // Función para validar los requisitos de la contraseña (longitud de 8 a 12 y caracteres combinados)
  String? _validarPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa una contraseña';
    }
    if (value.length < 8 || value.length > 12) {
      return 'Debe tener entre 8 y 12 caracteres';
    }
    // Verifica que tenga al menos una mayúscula, una minúscula y un número obligatoriamente
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Debe incluir mayúsculas, minúsculas y números';
    }
    return null;
  }

  // Función para validar que el teléfono tenga una longitud mínima aceptable
  String? _validarTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un número de teléfono';
    }
    if (value.length < 9) {
      return 'El número es demasiado corto';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedSwitcher(
              // Agregamos una animación suave de 400ms al cambiar entre Login y Registro
              duration: const Duration(milliseconds: 400),
              child: _mostrarLogin ? _buildLoginForm() : _buildRegisterForm(),
            ),
          ),
        ),
      ),
    );
  }

  // --- FORMULARIO DE LOGIN ---
  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('LoginForm'), // Key única para que AnimatedSwitcher reconozca el cambio
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Iniciar Sesión",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 28, 24, 255),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _emailController,
            label: "Correo Electrónico",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validarEmail,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: "Contraseña",
            icon: Icons.lock_outline,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu contraseña';
              }
              return null; // En el login solo vemos que no esté vacío, la validación fuerte está en el registro
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Si todo el formulario pasa las validaciones, ejecutamos la lógica del botón
              if (_loginFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Validando credenciales...')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Iniciar Sesión",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _mostrarLogin = false; // Cambiamos el estado para ocultar el login y mostrar registro
                  _loginFormKey.currentState?.reset(); // Limpiamos errores previos del formulario
                });
              },
              child: const Text(
                "Registrar",
                style: TextStyle(
                  color: Color.fromARGB(255, 28, 24, 255),
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- FORMULARIO DE REGISTRO ---
  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('RegisterForm'), // Key única para el cambio de animación
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // REEMPLAZAMOS EL TEXT POR EL GESTUREDETECTOR DETECTOR DE 5 TOQUES:
          GestureDetector(
            onTap: () {
              final ahora = DateTime.now();

              // Si el toque actual es rápido (menos de 500ms de diferencia), suma al contador
              if (_ultimoToqueAdmin == null || ahora.difference(_ultimoToqueAdmin!) < const Duration(milliseconds: 500)) {
                _contadorToquesAdmin++;
              } else {
                // Si tardó mucho entre toques, el contador se reinicia a 1
                _contadorToquesAdmin = 1;
              }

              _ultimoToqueAdmin = ahora; // Guardamos la hora de este toque

              // ¡Al llegar a los 5 toques seguidos saltamos a la nueva pantalla!
              if (_contadorToquesAdmin == 5) {
                _contadorToquesAdmin = 0; // Reseteamos el contador al instante

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminAuthScreen(),
                  ),
                );
              }
            },
            child: Text(  //no se usa const por el color dinamico
              "Crea tu Cuenta",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 28, 24, 255), // Tu color azul intacto
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _nombreController,
            label: "Nombre Completo",
            icon: Icons.person_outline,
            validator: _validarNombre,
            inputFormatters: [
              // Formatter físico para impedir que el usuario pueda tipear números directamente
              FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: "Correo Electrónico",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validarEmail,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: "Contraseña (8-12 carac., Mayús., Minús. y Núm.)",
            icon: Icons.lock_outline,
            obscureText: true,
            validator: _validarPassword,
          ),
          const SizedBox(height: 16),
          // Switch para alternar el rol de usuario normal a emprendedor vendedor
          SwitchListTile(
            title: const Text(
              "¿Eres Emprendedor?",
              style: TextStyle(color: Color.fromARGB(255, 28, 24, 255)),
            ),
            subtitle: const Text(
              "Activa esto si vas a vender ropa",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 13),
            ),
            value: _esEmprendedor,
            activeColor: const Color.fromARGB(255, 17, 201, 20),
            onChanged: (bool value) {
              setState(() {
                _esEmprendedor = value; // Actualiza el estado para redibujar la pantalla
              });
            },
          ),
          
          // --- CAMPOS DINÁMICOS PARA EMPRENDEDORES ---
          // Este widget maneja la animación de tamaño para desplegar los campos extra de forma fluida
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _esEmprendedor
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emprendimientoController,
                        label: "Nombre del Emprendimiento",
                        icon: Icons.store_outlined,
                        // Si está activo el switch, valida el nombre del local; si no, retorna null
                        validator: (value) => _esEmprendedor ? _validarNombre(value) : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[0-9]')), // Bloquea números en el local
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _telefonoController,
                        label: "Número de Teléfono",
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone, // Despliega el teclado numérico en el celular
                        validator: (value) => _esEmprendedor ? _validarTelefono(value) : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Fuerza a que solo admita números enteros
                          LengthLimitingTextInputFormatter(10),   // Restringe la entrada a máximo 10 dígitos (Ecuador)
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(), // Si no es emprendedor, renderiza un espacio vacío sin ocupar tamaño
          ),
          
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Ejecuta la validación de todos los campos del registro antes de avanzar
              if (_registerFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Procesando registro ')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Registrarse",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _mostrarLogin = true; // Volvemos a cambiar el estado para ir a la vista de Login
                  _registerFormKey.currentState?.reset(); // Reseteamos errores en la UI del registro
                });
              },
              child: const Text(
                "Ya tengo cuenta",
                style: TextStyle(
                  color: Color.fromARGB(255, 28, 24, 255),
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TEXTFIELD PERSONALIZADO Y REUTILIZABLE ---
  // Constructor modular para no repetir el mismo diseño visual de InputDecoration en cada input
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Color.fromARGB(255, 1, 1, 1)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 60, 55, 55), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: const Color.fromARGB(255, 251, 251, 255), // Color de fondo oscuro personalizado
        errorStyle: const TextStyle(color: Colors.redAccent),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 28, 24, 255), width: 1.5),
        ),
      ),
    );
  }
}