/// Formatos de pantalla compartidos por todos los módulos.
library;

/// Un DÍA (`2026-12-31`) a `31/12/2026`. No pasa por DateTime: en UTC-4 un
/// `DateTime.parse(...).toLocal()` lo corre al día anterior.
String fechaDia(String? dia) {
  if (dia == null || dia.length < 10) return '—';
  final partes = dia.substring(0, 10).split('-');
  if (partes.length != 3) return dia;
  return '${partes[2]}/${partes[1]}/${partes[0]}';
}

/// Un MOMENTO, en la hora del teléfono: `25/10/2026 10:30`.
String fechaHora(DateTime momento) {
  final m = momento.toLocal();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${dos(m.day)}/${dos(m.month)}/${m.year} ${dos(m.hour)}:${dos(m.minute)}';
}

/// Bolivianos con coma decimal y punto de miles: `Bs 1.250,50`.
String bs(num monto) => 'Bs ${_conMiles(monto, 2)}';

/// Kilos sin decimales si son enteros: `1.350 kg`.
String kg(num kilos) => '${_conMiles(kilos, kilos % 1 == 0 ? 0 : 1)} kg';

/// Días que faltan hasta un DÍA, contando desde hoy (negativo si ya pasó).
int diasHasta(String dia, {DateTime? hoy}) {
  final p = dia.substring(0, 10).split('-').map(int.parse).toList();
  final h = hoy ?? DateTime.now();
  return DateTime(p[0], p[1], p[2]).difference(DateTime(h.year, h.month, h.day)).inDays;
}

String _conMiles(num valor, int decimales) {
  final texto = valor.abs().toStringAsFixed(decimales);
  final partes = texto.split('.');
  final entero = partes[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  final signo = valor < 0 ? '-' : '';
  return decimales == 0 ? '$signo$entero' : '$signo$entero,${partes[1]}';
}
