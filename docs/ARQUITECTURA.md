# Arquitectura de Beni Digital

## La idea

Una app de la Gobernación, varios sistemas adentro. El ciudadano entra una vez
y ve todo lo suyo: su carnet de pescador (Jichi), sus trámites de Paititi y de
Sedede. Cada equipo trabaja en su carpeta sin tocar la de los demás.

```
                 Beni Digital (Flutter)
 ┌───────────────────────────────────────────────────────┐
 │ CASCARÓN  lib/nucleo/ + lib/pantallas/                 │
 │ login · inicio · servicios · avisos · perfil · tema    │
 ├──────────────────┬─────────────────┬──────────────────┤
 │ lib/modulos/jichi│ lib/modulos/    │ lib/modulos/     │
 │ (SEDAG)          │ paititi         │ sedede           │
 └────────┬─────────┴────────┬────────┴────────┬─────────┘
          │  token de Ibare  │                 │
          ▼                  ▼                 ▼
      API Jichi         API Paititi       API Sedede
```

## Piezas

| Carpeta | Qué hay |
| --- | --- |
| `lib/nucleo/sesion/` | La sesión (`Sesion`, un `ChangeNotifier`). En el prototipo acepta cualquier contraseña y vive en memoria |
| `lib/nucleo/modulos/` | `ModuloSistema`: el contrato que cumple cada sistema. `registro.dart` es la ÚNICA lista de módulos |
| `lib/nucleo/rutas/` | `go_router`: si no hay sesión, todo va a `/ingresar` |
| `lib/pantallas/` | Las cinco pantallas del cascarón y las pestañas |
| `lib/modulos/<sistema>/` | Todo lo de un sistema: sus datos (hoy ficticios), sus modelos, sus pantallas y sus rutas |

## El contrato del módulo

Cada sistema entrega una clase que extiende `ModuloSistema`:

- **Quién es**: `id`, `nombre`, `descripcion`, `color`, `icono`, `estado`
  (`disponible` o `proximamente`).
- **Qué muestra en el inicio**: `resumen()` devuelve tarjetas («Su carnet vence en 12 días»).
- **Qué avisa**: `avisos()`.
- **Sus pantallas**: `rutas()` devuelve las rutas de `go_router` bajo `/<id>`.

El cascarón junta los `resumen()` y los `avisos()` de todos en paralelo. **Si un
sistema no responde, los demás se muestran igual**: su tarjeta sale con el aviso
de que no se pudo consultar.

## Login

**En el prototipo**: cédula y cualquier contraseña; entra como Ignacio Molina
Guzmán (C.I. 7633685) con datos de ejemplo.

**Lo previsto**: los tres sistemas confían en **Ibare**, el login de la Gobernación. La app hace
Authorization Code + **PKCE** (sin secreto: un cliente móvil no puede guardarlo)
y manda el token a cada API, que lo valida con el JWKS de Ibare.

**Hoy está bloqueado del lado de Ibare** (ver [PENDIENTES.md](PENDIENTES.md)):
solo emite tokens de funcionarios y solo registra clientes confidenciales. Hasta
que lo habiliten, la app sigue con el login del prototipo.

## Por qué Flutter

Decidido por el responsable (25/10/2026). Lo que se resigna frente a React
Native: las actualizaciones al instante sin pasar por las tiendas. Si hace falta,
Shorebird lo ofrece para Flutter.
