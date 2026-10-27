import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'nucleo/rutas/enrutador.dart';
import 'nucleo/sesion/sesion.dart';
import 'nucleo/tema.dart';

class BeniDigital extends StatefulWidget {
  const BeniDigital({super.key, required this.sesion});

  final Sesion sesion;

  @override
  State<BeniDigital> createState() => _BeniDigitalState();
}

class _BeniDigitalState extends State<BeniDigital> {
  // Se crea una sola vez: rearmarlo en cada build perdería la pila de pantallas.
  late final GoRouter _enrutador = crearEnrutador(widget.sesion);

  @override
  Widget build(BuildContext context) {
    return AlcanceSesion(
      sesion: widget.sesion,
      child: MaterialApp.router(
        title: 'Beni Digital',
        debugShowCheckedModeBanner: false,
        theme: temaClaro(),
        darkTheme: temaOscuro(),
        routerConfig: _enrutador,
      ),
    );
  }
}
