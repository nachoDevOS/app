import 'package:flutter/material.dart';

import '../nucleo/sesion/sesion.dart';

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final sesion = AlcanceSesion.de(context);
    final usuario = sesion.usuario;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: t.colorScheme.primaryContainer,
              child: Text(
                _iniciales(usuario?.nombre ?? ''),
                style: t.textTheme.headlineSmall?.copyWith(color: t.colorScheme.onPrimaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(usuario?.nombre ?? '', style: t.textTheme.titleLarge, textAlign: TextAlign.center),
          Text(
            'C.I. ${usuario?.ci ?? ''}',
            style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.verified_user_outlined),
                  title: const Text('Cuenta'),
                  subtitle: const Text('Prototipo · datos de ejemplo'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Beni Digital'),
                  subtitle: Text('Gobierno Autónomo Departamental del Beni'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: sesion.salir,
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  static String _iniciales(String nombre) =>
      nombre.split(' ').where((p) => p.isNotEmpty).take(2).map((p) => p[0]).join().toUpperCase();
}
