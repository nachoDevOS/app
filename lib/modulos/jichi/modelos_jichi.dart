import 'package:flutter/material.dart';

/// Los cuatro papeles que entrega Jichi.
enum TipoDocumentoJichi {
  autorizacion('Autorización de Pesca para Aprovechamiento Pesquero', Icons.waves),
  carnet('Carnet', Icons.badge_outlined),
  faena('Permiso de faena', Icons.sailing_outlined),
  guia('Guía única de transporte', Icons.local_shipping_outlined);

  const TipoDocumentoJichi(this.etiqueta, this.icono);

  final String etiqueta;
  final IconData icono;
}

/// Lo que el ciudadano necesita saber de un papel; el estado técnico no viaja.
enum SituacionDocumento {
  vigente('Vigente', Color(0xFF15803D)),
  enTramite('En trámite', Color(0xFFB45309)),
  vencido('Vencido', Color(0xFF64748B)),
  revocado('Sin efecto', Color(0xFFBE123C));

  const SituacionDocumento(this.etiqueta, this.color);

  final String etiqueta;
  final Color color;

  static SituacionDocumento desde(String? valor) => switch (valor) {
    'vigente' => vigente,
    'en_tramite' => enTramite,
    'revocado' => revocado,
    _ => vencido,
  };
}

/// Un pago por hacer en Recaudaciones (SIREB).
class PagoPendiente {
  const PagoPendiente({required this.monto, required this.codigo, required this.vence});

  final double monto;

  /// El código que se presenta en el banco o se paga por QR.
  final String codigo;

  /// DÍA límite (`AAAA-MM-DD`).
  final String vence;

  factory PagoPendiente.desdeJson(Map<String, dynamic> j) =>
      PagoPendiente(monto: (j['monto'] as num).toDouble(), codigo: j['codigo'] as String, vence: j['vence'] as String);
}

class DocumentoJichi {
  const DocumentoJichi({
    required this.tipo,
    required this.codigo,
    required this.titulo,
    required this.situacion,
    this.vence,
    this.datos = const [],
    this.pago,
    this.kilosAutorizados,
    this.kilosDisponibles,
  });

  final TipoDocumentoJichi tipo;

  /// Código de verificación público (el del QR), no un id interno.
  final String codigo;

  /// «Carnet de pescador», «Permiso de faena N° 000123».
  final String titulo;
  final SituacionDocumento situacion;

  /// DÍA de vencimiento (`AAAA-MM-DD`).
  final String? vence;

  /// Renglones «rótulo: valor» de la ficha, en orden.
  final List<(String, String)> datos;
  final PagoPendiente? pago;
  final double? kilosAutorizados;
  final double? kilosDisponibles;

  factory DocumentoJichi.desdeJson(Map<String, dynamic> j) => DocumentoJichi(
    tipo: TipoDocumentoJichi.values.byName(j['tipo'] as String),
    codigo: j['codigo'] as String,
    titulo: j['titulo'] as String,
    situacion: SituacionDocumento.desde(j['situacion'] as String?),
    vence: j['vence'] as String?,
    datos: [for (final d in (j['datos'] as List? ?? const [])) ((d as Map)['rotulo'] as String, d['valor'] as String)],
    pago: j['pago'] == null ? null : PagoPendiente.desdeJson(j['pago'] as Map<String, dynamic>),
    kilosAutorizados: (j['kilos_autorizados'] as num?)?.toDouble(),
    kilosDisponibles: (j['kilos_disponibles'] as num?)?.toDouble(),
  );
}
