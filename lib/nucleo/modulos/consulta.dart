import 'modulo.dart';
import 'registro.dart';

/// Lo que respondió un módulo, o por qué no respondió.
class RespuestaModulo<T> {
  const RespuestaModulo(this.modulo, {this.datos, this.error});

  final ModuloSistema modulo;
  final T? datos;
  final String? error;
}

/// Pregunta a todos los módulos disponibles A LA VEZ. Un sistema caído no tumba
/// a los demás: vuelve con su error y el resto se muestra igual.
Future<List<RespuestaModulo<T>>> consultarTodos<T>(Future<T> Function(ModuloSistema) pedido) {
  final disponibles = modulosRegistrados.where((m) => m.estado == EstadoModulo.disponible);
  return Future.wait(
    disponibles.map((m) async {
      try {
        return RespuestaModulo<T>(m, datos: await pedido(m));
      } catch (_) {
        return RespuestaModulo<T>(m, error: 'No se pudo consultar ${m.nombre}.');
      }
    }),
  );
}
