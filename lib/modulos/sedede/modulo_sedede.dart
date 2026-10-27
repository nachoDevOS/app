import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../nucleo/modulos/modulo.dart';
import '../../nucleo/sesion/sesion.dart';
import '../../nucleo/widgets/pantalla_proximamente.dart';

/// Sedede: lo arma su equipo. Ver docs/AGREGAR-MODULO.md.
class ModuloSedede extends ModuloSistema {
  @override
  String get id => 'sedede';

  @override
  String get nombre => 'Sedede';

  // TODO(equipo Sedede): confirmar institución y descripción.
  @override
  String get institucion => 'Servicio Departamental de Deportes';

  @override
  String get descripcion => 'Servicios del Servicio Departamental de Deportes.';

  @override
  Color get color => const Color(0xFF7C3AED);

  @override
  IconData get icono => Icons.sports_soccer_outlined;

  @override
  EstadoModulo get estado => EstadoModulo.proximamente;

  @override
  Future<List<TarjetaResumen>> resumen(Sesion sesion) async => const [];

  @override
  Future<List<Aviso>> avisos(Sesion sesion) async => const [];

  @override
  List<RouteBase> rutas() => [
    GoRoute(
      path: rutaInicio,
      builder: (_, _) => PantallaProximamente(modulo: this),
    ),
  ];
}
