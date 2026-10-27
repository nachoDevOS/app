import 'package:flutter/material.dart';

import '../modulos/modulo.dart';
import '../tema.dart';

/// El sello de la app: escudo simplificado y nombre.
class MarcaBeni extends StatelessWidget {
  const MarcaBeni({super.key, this.tamano = 56});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [verdeBeni, Color(0xFF14946F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(tamano * 0.28),
      ),
      alignment: Alignment.center,
      child: Text(
        'BD',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: tamano * 0.38, letterSpacing: -1),
      ),
    );
  }
}

/// Lo que se muestra cuando una lista no tiene nada.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key, required this.icono, required this.titulo, this.detalle});

  final IconData icono;
  final String titulo;
  final String? detalle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: t.colorScheme.surfaceContainerHighest,
            child: Icon(icono, color: t.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Text(titulo, style: t.textTheme.titleMedium, textAlign: TextAlign.center),
          if (detalle != null) ...[
            const SizedBox(height: 4),
            Text(
              detalle!,
              style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Colores de una tarjeta según su urgencia: fondo y acento.
(Color, Color) coloresDeNivel(BuildContext context, NivelTarjeta nivel) {
  final oscuro = Theme.of(context).brightness == Brightness.dark;
  final (base, acento) = switch (nivel) {
    NivelTarjeta.info => (const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
    NivelTarjeta.exito => (const Color(0xFFDCFCE7), const Color(0xFF15803D)),
    NivelTarjeta.atencion => (const Color(0xFFFEF3C7), const Color(0xFFB45309)),
    NivelTarjeta.urgente => (const Color(0xFFFFE4E6), const Color(0xFFBE123C)),
  };
  return oscuro ? (acento.withValues(alpha: 0.18), base) : (base, acento);
}

IconData iconoDeNivel(NivelTarjeta nivel) => switch (nivel) {
  NivelTarjeta.info => Icons.info_outline,
  NivelTarjeta.exito => Icons.check_circle_outline,
  NivelTarjeta.atencion => Icons.schedule,
  NivelTarjeta.urgente => Icons.error_outline,
};
