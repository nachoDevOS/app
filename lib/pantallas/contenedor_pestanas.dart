import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Las cuatro pestañas del cascarón. Cada una conserva su pila al cambiar de pestaña.
class ContenedorPestanas extends StatelessWidget {
  const ContenedorPestanas({super.key, required this.navegacion});

  final StatefulNavigationShell navegacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navegacion,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navegacion.currentIndex,
        // Tocar la pestaña en la que ya se está vuelve a su raíz.
        onDestinationSelected: (i) => navegacion.goBranch(i, initialLocation: i == navegacion.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.apps_outlined), selectedIcon: Icon(Icons.apps), label: 'Servicios'),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Avisos',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
