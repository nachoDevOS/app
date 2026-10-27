import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../nucleo/formato.dart';
import '../../../nucleo/modulos/modulo.dart';
import '../../../nucleo/widgets/componentes.dart';
import '../datos_jichi.dart';
import '../modelos_jichi.dart';

/// La ficha de un papel: su QR de verificación, el pago pendiente y los datos.
class PantallaDocumentoJichi extends StatefulWidget {
  const PantallaDocumentoJichi({super.key, required this.codigo});

  final String codigo;

  @override
  State<PantallaDocumentoJichi> createState() => _PantallaDocumentoJichiState();
}

class _PantallaDocumentoJichiState extends State<PantallaDocumentoJichi> {
  late final Future<DocumentoJichi> _documento = const DatosJichi().documento(widget.codigo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documento')),
      body: FutureBuilder(
        future: _documento,
        builder: (context, foto) {
          if (foto.hasError) {
            return const EstadoVacio(icono: Icons.search_off, titulo: 'No se encontró el documento');
          }
          if (!foto.hasData) return const Center(child: CircularProgressIndicator());
          final d = foto.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Encabezado(documento: d),
              if (d.pago != null) ...[const SizedBox(height: 16), _TarjetaPago(pago: d.pago!)],
              if (d.kilosAutorizados != null && d.kilosDisponibles != null) ...[
                const SizedBox(height: 16),
                _Kilos(autorizados: d.kilosAutorizados!, disponibles: d.kilosDisponibles!),
              ],
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    for (final (rotulo, valor) in d.datos)
                      ListTile(dense: true, title: Text(rotulo), trailing: Text(valor)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.documento});

  final DocumentoJichi documento;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final d = documento;
    // Solo lo entregado se verifica: un papel en trámite todavía no vale en un control.
    final conQr = d.situacion == SituacionDocumento.vigente;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              d.titulo,
              style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              d.vence == null ? d.situacion.etiqueta : '${d.situacion.etiqueta} · vence el ${fechaDia(d.vence)}',
              style: TextStyle(color: d.situacion.color, fontWeight: FontWeight.w600),
            ),
            if (conQr) ...[
              const SizedBox(height: 16),
              // Fondo blanco siempre: en modo oscuro un QR invertido no lo lee cualquier cámara.
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: QrImageView(
                  data: '${DatosJichi.urlPublica}/verificar/${d.codigo.replaceAll('-', '')}',
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text('Muéstrelo en un control para verificarlo.', style: t.textTheme.bodySmall),
            ],
            const SizedBox(height: 8),
            SelectableText(
              d.codigo,
              style: t.textTheme.titleLarge?.copyWith(fontFamily: 'monospace', letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaPago extends StatelessWidget {
  const _TarjetaPago({required this.pago});

  final PagoPendiente pago;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final (fondo, acento) = coloresDeNivel(context, NivelTarjeta.atencion);

    return Material(
      color: fondo,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Por pagar en Recaudaciones', style: t.textTheme.labelLarge?.copyWith(color: acento)),
            const SizedBox(height: 4),
            Text(bs(pago.monto), style: t.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            Text('Hasta el ${fechaDia(pago.vence)}', style: t.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('Código de pago: ${pago.codigo}', style: t.textTheme.titleSmall)),
                IconButton(
                  tooltip: 'Copiar',
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: pago.codigo));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código copiado')));
                  },
                ),
              ],
            ),
            Text(
              'Páguelo en el banco o por QR con este código. Al confirmarse el pago, el documento se aprueba solo.',
              style: t.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Cuánto le queda del cupo de la autorización.
class _Kilos extends StatelessWidget {
  const _Kilos({required this.autorizados, required this.disponibles});

  final double autorizados;
  final double disponibles;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final parte = autorizados == 0 ? 0.0 : (disponibles / autorizados).clamp(0.0, 1.0);
    // Mismos umbrales que el panel de Jichi: amarillo ≤ 50 %, rojo ≤ 20 %.
    final color = parte <= .2
        ? const Color(0xFFBE123C)
        : (parte <= .5 ? const Color(0xFFB45309) : const Color(0xFF15803D));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Disponible para vender', style: t.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              '${kg(disponibles)} de ${kg(autorizados)}',
              style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(value: parte, minHeight: 10, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
