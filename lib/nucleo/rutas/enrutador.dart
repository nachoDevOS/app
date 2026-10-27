import 'package:go_router/go_router.dart';

import '../../pantallas/avisos.dart';
import '../../pantallas/contenedor_pestanas.dart';
import '../../pantallas/ingresar.dart';
import '../../pantallas/inicio.dart';
import '../../pantallas/perfil.dart';
import '../../pantallas/servicios.dart';
import '../modulos/registro.dart';
import '../sesion/sesion.dart';

GoRouter crearEnrutador(Sesion sesion) {
  return GoRouter(
    initialLocation: '/',
    // Escucha la sesión: al cerrarla (o al vencer el token) el redirect lleva al login.
    refreshListenable: sesion,
    redirect: (context, estado) {
      final enLogin = estado.matchedLocation == '/ingresar';
      if (!sesion.iniciada) return enLogin ? null : '/ingresar';
      if (enLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/ingresar', builder: (_, _) => const PantallaIngresar()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navegacion) => ContenedorPestanas(navegacion: navegacion),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (_, _) => const PantallaInicio())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/servicios', builder: (_, _) => const PantallaServicios())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/avisos', builder: (_, _) => const PantallaAvisos())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/perfil', builder: (_, _) => const PantallaPerfil())],
          ),
        ],
      ),
      // Fuera del shell: las pantallas de cada sistema tapan las pestañas, como una app aparte.
      for (final modulo in modulosRegistrados) ...modulo.rutas(),
    ],
  );
}
