# Agregar un sistema a Beni Digital

> Para los equipos de Paititi y Sedede. Jichi (`lib/modulos/jichi/`) es el ejemplo completo.

## 1. Tu carpeta

```
lib/modulos/<tu_sistema>/
  modulo_<tu_sistema>.dart     ← la clase que extiende ModuloSistema
  datos_<tu_sistema>.dart      ← de dónde salen los datos (hoy, de ejemplo)
  modelos_<tu_sistema>.dart
  pantallas/
```

Todo lo tuyo va ahí adentro. **No importes nada de otro módulo**; lo común está
en `lib/nucleo/`.

## 2. La clase del módulo

Extendé `ModuloSistema` (`lib/nucleo/modulos/modulo.dart`) y completá:

| Qué | Para qué |
| --- | --- |
| `id` | Prefijo de tus rutas: `/paititi/...`. Corto, minúsculas, sin espacios |
| `nombre`, `institucion`, `descripcion`, `color`, `icono` | Cómo te muestra la pestaña Servicios |
| `estado` | `proximamente` mientras armás; `disponible` cuando ya muestra algo |
| `resumen()` | Hasta 3 tarjetas para el Inicio, la más urgente primero |
| `avisos()` | Tus avisos; el cascarón los mezcla con los de los demás |
| `rutas()` | Tus pantallas. **Todas** bajo `rutaInicio` (lo controla una prueba) |

## 3. Registrarte

Una línea en `lib/nucleo/modulos/registro.dart`. Es el único archivo del
cascarón que se toca.

## 4. Verificar

```sh
flutter analyze
flutter test
```

## 5. Cuando haya backend

Reemplazá `datos_<tu_sistema>.dart` por la consulta a tu API, que cumple
[CONTRATO-API.md](CONTRATO-API.md). Las pantallas no cambian: llaman a los
mismos métodos.
