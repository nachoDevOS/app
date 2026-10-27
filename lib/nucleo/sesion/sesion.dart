import 'package:flutter/widgets.dart';

import 'usuario.dart';

/// La sesión del PROTOTIPO: acepta cualquier cédula y contraseña y vive en
/// memoria. El login real será con Ibare (ver docs/PENDIENTES.md).
/// El enrutador la escucha: al cerrarla vuelve al login solo.
class Sesion extends ChangeNotifier {
  static const nombreDemostracion = 'Ignacio Molina Guzmán';

  Usuario? _usuario;

  bool get iniciada => _usuario != null;
  Usuario? get usuario => _usuario;

  /// Simula la demora de un servidor para que el prototipo se sienta real.
  Future<void> ingresar({required String ci}) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _usuario = Usuario(ci: ci.trim(), nombre: nombreDemostracion);
    notifyListeners();
  }

  void salir() {
    _usuario = null;
    notifyListeners();
  }
}

/// Deja la sesión al alcance de cualquier pantalla: `AlcanceSesion.de(context)`.
class AlcanceSesion extends InheritedNotifier<Sesion> {
  const AlcanceSesion({super.key, required Sesion sesion, required super.child}) : super(notifier: sesion);

  static Sesion de(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AlcanceSesion>()!.notifier!;
}
