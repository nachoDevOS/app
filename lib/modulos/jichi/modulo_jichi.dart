import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../nucleo/modulos/modulo.dart';
import '../../nucleo/sesion/sesion.dart';
import 'datos_jichi.dart';
import 'pantallas/documento_jichi.dart';
import 'pantallas/inicio_jichi.dart';

/// Jichi: carnets, autorizaciones de pesca, permisos de faena y guías (SEDAG).
class ModuloJichi extends ModuloSistema {
  @override
  String get id => 'jichi';

  @override
  String get nombre => 'Jichi';

  @override
  String get institucion => 'SEDAG · Pesca';

  @override
  String get descripcion => 'Su autorización de pesca, carnet, permisos de faena y guías de transporte.';

  @override
  Color get color => const Color(0xFF0E7490);

  @override
  IconData get icono => Icons.set_meal_outlined;

  @override
  Future<List<TarjetaResumen>> resumen(Sesion sesion) => const DatosJichi().resumen();

  @override
  Future<List<Aviso>> avisos(Sesion sesion) => const DatosJichi().avisos();

  @override
  List<RouteBase> rutas() => [
    GoRoute(
      path: rutaInicio,
      builder: (_, _) => const PantallaInicioJichi(),
      routes: [
        GoRoute(
          path: 'documento/:codigo',
          builder: (_, estado) => PantallaDocumentoJichi(codigo: estado.pathParameters['codigo']!),
        ),
      ],
    ),
  ];
}
