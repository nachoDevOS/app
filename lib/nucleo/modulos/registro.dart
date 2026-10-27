import '../../modulos/jichi/modulo_jichi.dart';
import '../../modulos/paititi/modulo_paititi.dart';
import '../../modulos/sedede/modulo_sedede.dart';
import 'modulo.dart';

/// LA lista de sistemas de la app, en el orden en que se muestran. Es el único
/// archivo del cascarón que importa módulos: sumar uno es agregarlo acá.
final List<ModuloSistema> modulosRegistrados = [ModuloJichi(), ModuloPaititi(), ModuloSedede()];

ModuloSistema? moduloPorRuta(String ruta) {
  for (final m in modulosRegistrados) {
    if (ruta == m.rutaInicio || ruta.startsWith('${m.rutaInicio}/')) return m;
  }
  return null;
}
