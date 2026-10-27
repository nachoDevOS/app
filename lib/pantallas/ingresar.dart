import 'package:flutter/material.dart';

import '../nucleo/sesion/sesion.dart';
import '../nucleo/widgets/componentes.dart';

/// Login del prototipo: pide cédula y contraseña, acepta cualquiera.
/// El real abrirá Ibare, el login de la Gobernación.
class PantallaIngresar extends StatefulWidget {
  const PantallaIngresar({super.key});

  @override
  State<PantallaIngresar> createState() => _PantallaIngresarState();
}

class _PantallaIngresarState extends State<PantallaIngresar> {
  final _formulario = GlobalKey<FormState>();
  final _ci = TextEditingController(text: '7633685');
  final _clave = TextEditingController();
  bool _ingresando = false;
  bool _verClave = false;

  @override
  void dispose() {
    _ci.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _ingresar() async {
    if (!_formulario.currentState!.validate()) return;
    setState(() => _ingresando = true);
    // Al iniciarse, el enrutador escucha la sesión y lleva al inicio solo.
    await AlcanceSesion.de(context).ingresar(ci: _ci.text);
    if (mounted) setState(() => _ingresando = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formulario,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: MarcaBeni(tamano: 80)),
                    const SizedBox(height: 24),
                    Text(
                      'Beni Digital',
                      style: t.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sus trámites de la Gobernación del Beni,\nen un solo lugar.',
                      style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _ci,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Cédula de identidad',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Escriba su número de cédula.' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _clave,
                      obscureText: !_verClave,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _ingresar(),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _verClave ? 'Ocultar' : 'Mostrar',
                          icon: Icon(_verClave ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _verClave = !_verClave),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Escriba su contraseña.' : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _ingresando ? null : _ingresar,
                      child: _ingresando
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                          : const Text('Ingresar'),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Prototipo: cualquier contraseña sirve y los datos son de ejemplo.',
                      style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gobierno Autónomo Departamental del Beni',
                      style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
