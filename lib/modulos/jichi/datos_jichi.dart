import '../../nucleo/modulos/modulo.dart';
import 'modelos_jichi.dart';

/// Datos FICTICIOS del prototipo: un pescador con todo en regla y un permiso
/// por pagar. Cuando exista la API de Jichi, esta clase se reemplaza por la que
/// la consulta, con los mismos métodos (ver docs/CONTRATO-API.md).
class DatosJichi {
  const DatosJichi();

  /// URL pública de Jichi, para el QR de verificación.
  static const urlPublica = 'https://jichi.beni.gob.bo';

  static final _documentos = [
    const DocumentoJichi(
      tipo: TipoDocumentoJichi.autorizacion,
      codigo: 'X3P9-2LMA',
      titulo: 'Autorización de Pesca para Aprovechamiento Pesquero',
      situacion: SituacionDocumento.vigente,
      vence: '2026-12-31',
      kilosAutorizados: 2000,
      kilosDisponibles: 1350,
      datos: [
        ('N°', '000041'),
        ('Capacidad autorizada', '2.000 kg'),
        ('Asociación', 'Asociación de Pescadores San Pedro'),
        ('Embarcación', 'Esperanza II'),
      ],
    ),
    const DocumentoJichi(
      tipo: TipoDocumentoJichi.carnet,
      codigo: 'A7K2-9QXM',
      titulo: 'Carnet de pescador',
      situacion: SituacionDocumento.vigente,
      vence: '2026-12-31',
      datos: [
        ('N°', '000087'),
        ('Actividad', 'Pescador'),
        ('Asociación', 'Asociación de Pescadores San Pedro'),
        ('Emitido', '14/03/2026'),
      ],
    ),
    const DocumentoJichi(
      tipo: TipoDocumentoJichi.faena,
      codigo: 'F4N8-7TRC',
      titulo: 'Permiso de faena N° 000123',
      situacion: SituacionDocumento.vigente,
      vence: '2026-11-14',
      datos: [('Salida', '15/10/2026'), ('Lugar de pesca', 'Río Mamoré'), ('Disponible al salir', '1.350 kg')],
    ),
    const DocumentoJichi(
      tipo: TipoDocumentoJichi.faena,
      codigo: 'H2Q5-8WEB',
      titulo: 'Permiso de faena (por pagar)',
      situacion: SituacionDocumento.enTramite,
      datos: [('Salida prevista', '01/11/2026'), ('Lugar de pesca', 'Río Ibare')],
      pago: PagoPendiente(monto: 50, codigo: '2026-118734', vence: '2026-10-30'),
    ),
  ];

  Future<List<DocumentoJichi>> documentos() async {
    await _demora();
    return _documentos;
  }

  Future<DocumentoJichi> documento(String codigo) async {
    await _demora();
    return _documentos.firstWhere((d) => d.codigo == codigo);
  }

  /// Como si viniera de un servidor: el prototipo muestra sus estados de carga.
  static Future<void> _demora() => Future<void>.delayed(const Duration(milliseconds: 400));

  Future<List<TarjetaResumen>> resumen() async => const [
    TarjetaResumen(
      titulo: 'Pago pendiente: Bs 50,00',
      detalle: 'Permiso de faena. Pague hasta el 30/10/2026.',
      nivel: NivelTarjeta.atencion,
      ruta: '/jichi/documento/H2Q5-8WEB',
    ),
    TarjetaResumen(
      titulo: 'Le quedan 1.350 kg de 2.000 kg',
      detalle: 'Autorización de Pesca vigente hasta el 31/12/2026.',
      nivel: NivelTarjeta.info,
      ruta: '/jichi/documento/X3P9-2LMA',
    ),
    TarjetaResumen(
      titulo: 'Carnet de pescador vigente',
      detalle: 'Vence el 31/12/2026.',
      nivel: NivelTarjeta.exito,
      ruta: '/jichi/documento/A7K2-9QXM',
    ),
  ];

  Future<List<Aviso>> avisos() async => [
    Aviso(
      id: 'pago-H2Q5-8WEB',
      titulo: 'Tiene un pago pendiente',
      detalle: 'Permiso de faena: Bs 50,00 hasta el 30/10/2026.',
      fecha: DateTime.parse('2026-10-25T09:15:00-04:00'),
      ruta: '/jichi/documento/H2Q5-8WEB',
    ),
    Aviso(
      id: 'faena-F4N8-7TRC',
      titulo: 'Permiso de faena aprobado',
      detalle: 'Ya puede salir a pescar hasta el 14/11/2026.',
      fecha: DateTime.parse('2026-10-15T08:00:00-04:00'),
      ruta: '/jichi/documento/F4N8-7TRC',
    ),
  ];
}
