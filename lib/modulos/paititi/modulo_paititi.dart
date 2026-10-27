import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../nucleo/modulos/modulo.dart';
import '../../nucleo/sesion/sesion.dart';
import '../../nucleo/widgets/pantalla_proximamente.dart';

/// Paititi: lo arma su equipo. Ver docs/AGREGAR-MODULO.md.
class ModuloPaititi extends ModuloSistema {
  @override
  String get id => 'paititi';

  @override
  String get nombre => 'Paititi';

  // TODO(equipo Paititi): institución y descripción reales.
  @override
  String get institucion => 'Gobernación del Beni';

  @override
  String get descripcion => 'Servicios del sistema Paititi.';

  @override
  Color get color => const Color(0xFFB45309);

  @override
  IconData get icono => Icons.account_balance_outlined;

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
