import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../nucleo/formato.dart';
import '../../../nucleo/widgets/componentes.dart';
import '../datos_jichi.dart';
import '../modelos_jichi.dart';

/// «Mis documentos» de Jichi: primero lo que hay que pagar, después lo vigente.
class PantallaInicioJichi extends StatefulWidget {
  const PantallaInicioJichi({super.key});

  @override
  State<PantallaInicioJichi> createState() => _PantallaInicioJichiState();
}

class _PantallaInicioJichiState extends State<PantallaInicioJichi> {
  final Future<List<DocumentoJichi>> _documentos = const DatosJichi().documentos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jichi · Mis documentos')),
      body: FutureBuilder(
        future: _documentos,
        builder: (context, foto) {
          if (foto.hasError) {
            return EstadoVacio(icono: Icons.cloud_off, titulo: 'No se pudo consultar Jichi', detalle: '${foto.error}');
          }
          if (!foto.hasData) return const Center(child: CircularProgressIndicator());

          final docs = [...foto.data!]..sort((a, b) => (a.pago == null ? 1 : 0).compareTo(b.pago == null ? 1 : 0));
          if (docs.isEmpty) {
            return const EstadoVacio(
              icono: Icons.description_outlined,
              titulo: 'Todavía no tiene documentos',
              detalle: 'Acérquese a ventanilla del SEDAG para tramitar su autorización o su carnet.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _TarjetaDocumento(documento: docs[i]),
          );
        },
      ),
    );
  }
}

class _TarjetaDocumento extends StatelessWidget {
  const _TarjetaDocumento({required this.documento});

  final DocumentoJichi documento;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final d = documento;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/jichi/documento/${d.codigo}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(d.tipo.icono, color: const Color(0xFF0E7490), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.titulo, style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _Situacion(situacion: d.situacion),
                        if (d.vence != null) Text('Vence el ${fechaDia(d.vence)}', style: t.textTheme.bodySmall),
                      ],
                    ),
                    if (d.pago != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Por pagar: ${bs(d.pago!.monto)} hasta el ${fechaDia(d.pago!.vence)}',
                        style: t.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFB45309),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _Situacion extends StatelessWidget {
  const _Situacion({required this.situacion});

  final SituacionDocumento situacion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: situacion.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        situacion.etiqueta,
        style: TextStyle(color: situacion.color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
