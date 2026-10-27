import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../sesion/sesion.dart';

enum EstadoModulo { disponible, proximamente }

/// Urgencia de una tarjeta del inicio; decide el color.
enum NivelTarjeta { info, exito, atencion, urgente }

/// Una tarjeta del inicio («Su carnet vence en 12 días»). Ver CONTRATO-API.md.
class TarjetaResumen {
  const TarjetaResumen({required this.titulo, required this.detalle, this.nivel = NivelTarjeta.info, this.ruta});

  final String titulo;
  final String detalle;
  final NivelTarjeta nivel;

  /// Adónde lleva el toque, dentro del módulo.
  final String? ruta;

  factory TarjetaResumen.desdeJson(Map<String, dynamic> j) => TarjetaResumen(
    titulo: j['titulo'] as String,
    detalle: j['detalle'] as String,
    nivel: NivelTarjeta.values.asNameMap()[j['nivel']] ?? NivelTarjeta.info,
    ruta: j['ruta'] as String?,
  );
}

class Aviso {
  const Aviso({required this.id, required this.titulo, required this.detalle, required this.fecha, this.ruta});

  final String id;
  final String titulo;
  final String detalle;
  final DateTime fecha;
  final String? ruta;

  factory Aviso.desdeJson(Map<String, dynamic> j) => Aviso(
    id: j['id'] as String,
    titulo: j['titulo'] as String,
    detalle: j['detalle'] as String,
    fecha: DateTime.parse(j['fecha'] as String),
    ruta: j['ruta'] as String?,
  );
}

/// El contrato de un sistema dentro de la app. El cascarón solo conoce esto.
abstract class ModuloSistema {
  /// Corto y sin espacios: es el prefijo de sus rutas (`/jichi/...`).
  String get id;
  String get nombre;

  /// Quién lo atiende: «SEDAG · Pesca».
  String get institucion;
  String get descripcion;
  Color get color;
  IconData get icono;
  EstadoModulo get estado => EstadoModulo.disponible;

  String get rutaInicio => '/$id';

  /// Hasta tres tarjetas, la más urgente primero.
  Future<List<TarjetaResumen>> resumen(Sesion sesion);

  Future<List<Aviso>> avisos(Sesion sesion);

  /// Sus pantallas, todas bajo `rutaInicio`. Se abren encima de las pestañas.
  List<RouteBase> rutas();
}
