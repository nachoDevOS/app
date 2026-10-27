# Beni Digital — guía para agentes de IA

App móvil del **Gobierno Autónomo Departamental del Beni**. Una sola app que
reúne los sistemas de la Gobernación para el ciudadano: **Jichi** (SEDAG: pesca),
**Paititi** y **Sedede**. Cada sistema es un **módulo** con su propio backend.

**Flutter (estable) · Dart · go_router · qr_flutter**

> **HOY ES UN PROTOTIPO** (25/10/2026): login de mentira (cualquier contraseña) y
> datos ficticios escritos en `datos_<sistema>.dart`. No llama a ningún servidor.

---

## Antes de tocar nada

| Leé esto | Para |
| --- | --- |
| [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md) | Cascarón, módulos, login y por qué así. **Empezá acá** |
| [docs/CONTRATO-API.md](docs/CONTRATO-API.md) | Lo que TODO backend tiene que exponer para entrar a la app |
| [docs/AGREGAR-MODULO.md](docs/AGREGAR-MODULO.md) | Sumar un sistema nuevo, paso a paso |
| [docs/PENDIENTES.md](docs/PENDIENTES.md) | Qué falta y qué está bloqueado |

---

## Reglas que no se rompen

1. **Todo en español**: archivos, clases, variables, comentarios y textos. Excepción:
   lo que exige Flutter o un paquete (`build`, `State`, `main`).
2. **Comentar el porqué, no el qué, en una a tres líneas.** Lo largo va a `docs/`.
3. **El cascarón no conoce a los módulos por dentro.** `lib/nucleo/` y
   `lib/pantallas/` solo hablan con `ModuloSistema` (`lib/nucleo/modulos/modulo.dart`).
   Un `import 'package:beni_digital/modulos/jichi/...'` fuera de `lib/modulos/jichi/`
   o del registro es un error de diseño.
4. **Un módulo no importa a otro módulo.** Lo común sube a `lib/nucleo/`.
5. **Ningún secreto en la app.** Cuando llegue el login real, el cliente de Ibare
   será público (PKCE, sin `client_secret`): lo compilado lo puede leer cualquiera.
6. **Los datos de un módulo salen de UNA clase** (`DatosJichi`): las pantallas no
   tienen datos escritos. Pasar a la API es cambiar esa clase y nada más.
7. **Las fechas**: un DÍA viaja como `AAAA-MM-DD` y se muestra tal cual, sin pasar
   por `DateTime.parse(...).toLocal()` (corre un día en UTC-4); un MOMENTO viaja
   en ISO 8601 con zona. Ver `lib/nucleo/formato.dart`.
8. **Toda sesión de trabajo se registra** en `docs/sesiones/MM-AAAA/AAAA-MM-DD.md`
   copiando [docs/sesiones/_plantilla.md](docs/sesiones/_plantilla.md), con el
   informe para presentación en lenguaje simple al final.

---

## Verificar antes de dar algo por terminado

```sh
flutter analyze
flutter test
flutter build apk --debug     # que compile para Android
```

Flutter está en `~/development/flutter/bin` (agregarlo al `PATH`).

## Trampas conocidas

- **Cuando se sume el login real con `flutter_appauth`**, Android necesita
  `appAuthRedirectScheme` en `android/app/build.gradle.kts` (`manifestPlaceholders`).
  Sin eso el login abre el navegador y nunca vuelve a la app.
