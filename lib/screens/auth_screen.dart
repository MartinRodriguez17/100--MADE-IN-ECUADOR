import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _mostrarLogin = true;

  // Claves globales para validar los formularios
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Controladores de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emprendimientoController = TextEditingController();
  final _telefonoController = TextEditingController();
  
  bool _esEmprendedor = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    _emprendimientoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // --- VALIDACIONES CON EXPRESIONES REGULARES (RegExp) ---

  // Validar Correo Electrónico con @ y dominio
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

  // Validar Nombre Completo (Solo letras y espacios)
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

  // Validar Contraseña (Min 8, Max 12, Mayúscula, Minúscula y Número)
  String? _validarPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa una contraseña';
    }
    if (value.length < 8 || value.length > 12) {
      return 'Debe tener entre 8 y 12 caracteres';
    }
    // Validar al menos una mayúscula, una minúscula y un número
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Debe incluir mayúsculas, minúsculas y números';
    }
    return null;
  }

  // Validar Teléfono (Solo números)
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
        key: const ValueKey('LoginForm'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Iniciar Sesión",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
              return null; // La validación de fuerza de contraseña se hace al registrarse
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (_loginFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Validando credenciales...')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
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
                  _mostrarLogin = false;
                  // Limpiar formularios al cambiar de pantalla
                  _loginFormKey.currentState?.reset();
                });
              },
              child: const Text(
                "Registrar",
                style: TextStyle(
                  color: Colors.cyanAccent,
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
        key: const ValueKey('RegisterForm'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Crea tu Cuenta",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Nombre Completo (Filtra números desde el teclado)
          _buildTextField(
            controller: _nombreController,
            label: "Nombre Completo",
            icon: Icons.person_outline,
            validator: _validarNombre,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[0-9]')), // No permite escribir números
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
          // Switch de Emprendedor
          SwitchListTile(
            title: const Text(
              "¿Eres Emprendedor?",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Activa esto si vas a vender ropa",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            value: _esEmprendedor,
            activeColor: Colors.cyanAccent,
            onChanged: (bool value) {
              setState(() {
                _esEmprendedor = value;
              });
            },
          ),
          
          // --- CAMPOS DINÁMICOS PARA EMPRENDEDORES ---
          // Aparecen con una transición suave si _esEmprendedor es true
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
                        validator: (value) => _esEmprendedor ? _validarNombre(value) : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _telefonoController,
                        label: "Número de Teléfono",
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) => _esEmprendedor ? _validarTelefono(value) : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Solo permite números en el teclado
                          LengthLimitingTextInputFormatter(10),   // Máximo 10 dígitos (Formato celular Ecuador)
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_registerFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Procesando registro en Supabase...')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
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
                  _mostrarLogin = true;
                  _registerFormKey.currentState?.reset();
                });
              },
              child: const Text(
                "Ya tengo cuenta (Login)",
                style: TextStyle(
                  color: Colors.cyanAccent,
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1E1E30),
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
          borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}