import 'package:beni_digital/nucleo/modulos/registro.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('cada módulo tiene un id único', () {
    final ids = modulosRegistrados.map((m) => m.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('las rutas de un módulo cuelgan de su prefijo: no pisan las de otro', () {
    for (final m in modulosRegistrados) {
      for (final r in m.rutas().whereType<GoRoute>()) {
        expect(r.path == m.rutaInicio || r.path.startsWith('${m.rutaInicio}/'), isTrue, reason: '${m.id}: ${r.path}');
      }
    }
  });

  test('moduloPorRuta encuentra al dueño de una ruta', () {
    expect(moduloPorRuta('/jichi/documento/X3P9-2LMA')?.id, 'jichi');
    expect(moduloPorRuta('/jichiextra'), isNull);
  });
}
