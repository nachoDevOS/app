import 'package:beni_digital/nucleo/formato.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('un DÍA se muestra tal cual, sin correrse por la zona horaria', () {
    expect(fechaDia('2026-12-31'), '31/12/2026');
    expect(fechaDia(null), '—');
  });

  test('bolivianos y kilos con separadores de Bolivia', () {
    expect(bs(1250.5), 'Bs 1.250,50');
    expect(bs(50), 'Bs 50,00');
    expect(kg(1350), '1.350 kg');
    expect(kg(12.5), '12,5 kg');
  });

  test('días hasta un vencimiento', () {
    expect(diasHasta('2026-10-30', hoy: DateTime(2026, 10, 25, 23, 59)), 5);
    expect(diasHasta('2026-10-24', hoy: DateTime(2026, 10, 25)), -1);
  });
}
