import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../nucleo/formato.dart';
import '../nucleo/modulos/consulta.dart';
import '../nucleo/modulos/modulo.dart';
import '../nucleo/sesion/sesion.dart';
import '../nucleo/widgets/componentes.dart';

/// Los avisos de todos los sistemas en una sola lista, del más nuevo al más viejo.
class PantallaAvisos extends StatefulWidget {
  const PantallaAvisos({super.key});

  @override
  State<PantallaAvisos> createState() => _PantallaAvisosState();
}

class _PantallaAvisosState extends State<PantallaAvisos> {
  Future<List<RespuestaModulo<List<Aviso>>>>? _avisos;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _avisos ??= _cargar();
  }

  Future<List<RespuestaModulo<List<Aviso>>>> _cargar() {
    final sesion = AlcanceSesion.de(context);
    return consultarTodos((m) => m.avisos(sesion));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avisos')),
      body: RefreshIndicator(
        onRefresh: () async {
          final nuevo = _cargar();
          setState(() => _avisos = nuevo);
          await nuevo;
        },
        child: FutureBuilder(
          future: _avisos,
          builder: (context, foto) {
            if (!foto.hasData) return const Center(child: CircularProgressIndicator());

            final filas = [
              for (final r in foto.data!)
                for (final a in r.datos ?? const <Aviso>[]) (r.modulo, a),
            ]..sort((x, y) => y.$2.fecha.compareTo(x.$2.fecha));

            if (filas.isEmpty) {
              return ListView(
                children: const [
                  EstadoVacio(
                    icono: Icons.notifications_none,
                    titulo: 'Sin avisos',
                    detalle: 'Le avisaremos aquí cuando haya novedades.',
                  ),
                ],
              );
            }
            return ListView.separated(
              itemCount: filas.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final (modulo, aviso) = filas[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: modulo.color.withValues(alpha: 0.12),
                    child: Icon(modulo.icono, color: modulo.color),
                  ),
                  title: Text(aviso.titulo),
                  subtitle: Text('${aviso.detalle}\n${modulo.nombre} · ${fechaHora(aviso.fecha)}'),
                  isThreeLine: true,
                  onTap: aviso.ruta == null ? null : () => context.push(aviso.ruta!),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
