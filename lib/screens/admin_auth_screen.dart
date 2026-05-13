import 'package:flutter/material.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({Key? key}) : super(key: key);

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  final _adminFormKey = GlobalKey<FormState>();
  final _codigoAccesoController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _codigoAccesoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un fondo un poco diferente (un gris/negro más profundo) para denotar que es zona administrativa
      backgroundColor: const Color.fromARGB(255, 43, 43, 169),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 249, 247, 247),
        elevation: 0,
        title: const Text(
          "Acceso Privado",
          style: TextStyle(color: Color.fromARGB(255, 255, 0, 0), fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _adminFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icono de seguridad o candado
                  const Icon(
                    Icons.admin_panel_settings_outlined,
                    size: 80,
                    color: Color.fromARGB(255, 255, 0, 0),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Panel de Control Admin",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Esta es una zona restringida. Introduce tus credenciales.",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Campo para Código de Empleado o Llave Maestra
                  _buildAdminField(
                    controller: _codigoAccesoController,
                    label: "Código de Administrador / Token",
                    icon: Icons.vpn_key_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu código de autorización';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de contraseña del Admin
                  _buildAdminField(
                    controller: _passwordController,
                    label: "Contraseña Maestra",
                    icon: Icons.lock_clock_outlined,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Botón de Ingreso
                  ElevatedButton(
                    onPressed: () {
                      if (_adminFormKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Conectando al servidor seguro ..'),
                            backgroundColor: Colors.purpleAccent,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Autenticar Administrador",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  // Diseño de TextField adaptado para la estética de administrador
  Widget _buildAdminField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 234, 255, 0)),
        filled: true,
        fillColor: const Color(0xFF1A1A2E),
        errorStyle: const TextStyle(color: Colors.redAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 234, 255, 0), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}