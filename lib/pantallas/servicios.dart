import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../nucleo/modulos/modulo.dart';
import '../nucleo/modulos/registro.dart';

/// Los sistemas de la Gobernación que hay en la app.
class PantallaServicios extends StatelessWidget {
  const PantallaServicios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: modulosRegistrados.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _TarjetaSistema(modulo: modulosRegistrados[i]),
      ),
    );
  }
}

class _TarjetaSistema extends StatelessWidget {
  const _TarjetaSistema({required this.modulo});

  final ModuloSistema modulo;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final proximamente = modulo.estado == EstadoModulo.proximamente;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(modulo.rutaInicio),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: modulo.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(modulo.icono, color: modulo.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(modulo.nombre, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        if (proximamente) ...[
                          const SizedBox(width: 8),
                          const Chip(label: Text('Próximamente'), visualDensity: VisualDensity.compact),
                        ],
                      ],
                    ),
                    Text(modulo.institucion, style: t.textTheme.labelMedium?.copyWith(color: modulo.color)),
                    const SizedBox(height: 4),
                    Text(
                      modulo.descripcion,
                      style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
