import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../nucleo/modulos/consulta.dart';
import '../nucleo/modulos/modulo.dart';
import '../nucleo/sesion/sesion.dart';
import '../nucleo/widgets/componentes.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  Future<List<RespuestaModulo<List<TarjetaResumen>>>>? _resumen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resumen ??= _cargar();
  }

  Future<List<RespuestaModulo<List<TarjetaResumen>>>> _cargar() {
    final sesion = AlcanceSesion.de(context);
    return consultarTodos((m) => m.resumen(sesion));
  }

  Future<void> _recargar() async {
    final nuevo = _cargar();
    setState(() => _resumen = nuevo);
    await nuevo;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final sesion = AlcanceSesion.de(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _recargar,
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text('Hola, ${sesion.usuario?.primerNombre ?? ''}'),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Chip(label: Text('Prototipo'), visualDensity: VisualDensity.compact),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Lo que tiene pendiente en la Gobernación.',
                  style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            FutureBuilder(
              future: _resumen,
              builder: (context, foto) {
                if (!foto.hasData) {
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList.separated(
                    itemCount: foto.data!.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 24),
                    itemBuilder: (_, i) => _BloqueModulo(respuesta: foto.data![i]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// El encabezado de un sistema y sus tarjetas, o el aviso de que no respondió.
class _BloqueModulo extends StatelessWidget {
  const _BloqueModulo({required this.respuesta});

  final RespuestaModulo<List<TarjetaResumen>> respuesta;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final m = respuesta.modulo;
    final tarjetas = respuesta.datos ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.push(m.rutaInicio),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(m.icono, color: m.color, size: 20),
                const SizedBox(width: 8),
                Text(m.nombre, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(width: 6),
                Text(m.institucion, style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                const Spacer(),
                Icon(Icons.chevron_right, color: t.colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (respuesta.error != null)
          _Tarjeta(
            tarjeta: TarjetaResumen(titulo: 'No se pudo consultar', detalle: respuesta.error!),
            nivelForzado: NivelTarjeta.atencion,
          )
        else if (tarjetas.isEmpty)
          const _Tarjeta(
            tarjeta: TarjetaResumen(titulo: 'Todo en orden', detalle: 'No tiene nada pendiente.'),
          )
        else
          for (final tarjeta in tarjetas) ...[_Tarjeta(tarjeta: tarjeta), const SizedBox(height: 8)],
      ],
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.tarjeta, this.nivelForzado});

  final TarjetaResumen tarjeta;
  final NivelTarjeta? nivelForzado;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final nivel = nivelForzado ?? tarjeta.nivel;
    final (fondo, acento) = coloresDeNivel(context, nivel);

    return Material(
      color: fondo,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: tarjeta.ruta == null ? null : () => context.push(tarjeta.ruta!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(iconoDeNivel(nivel), color: acento),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tarjeta.titulo, style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(tarjeta.detalle, style: t.textTheme.bodyMedium),
                  ],
                ),
              ),
              if (tarjeta.ruta != null) Icon(Icons.chevron_right, color: acento),
            ],
          ),
        ),
      ),
    );
  }
}
