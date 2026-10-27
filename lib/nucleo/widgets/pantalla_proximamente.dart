import 'package:flutter/material.dart';

import '../modulos/modulo.dart';
import 'componentes.dart';

/// La entrada de un sistema que su equipo todavía está armando.
class PantallaProximamente extends StatelessWidget {
  const PantallaProximamente({super.key, required this.modulo});

  final ModuloSistema modulo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(modulo.nombre)),
      body: Center(
        child: EstadoVacio(
          icono: modulo.icono,
          titulo: 'Muy pronto',
          detalle: '${modulo.descripcion}\nEstamos preparando este servicio.',
        ),
      ),
    );
  }
}
