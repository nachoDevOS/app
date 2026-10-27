# Pendientes

## Bloqueado por Ibare (equipo de Ibare)

1. **Ciudadanos en Ibare.** Hoy Ibare solo emite tokens con
   `tipo_sujeto: funcionario` y `sub` = `mamore_id`. La app es para ciudadanos:
   hace falta `tipo_sujeto: ciudadano` con la **cédula** en el token (en `sub` o
   en un claim `ci`), y un alta o un registro de ciudadanos.
2. **Cliente público.** `ibare:registrar-cliente` solo crea clientes
   confidenciales (`confidencial = true`). El modelo ya soporta `false`: falta
   la opción en el comando. Cliente a registrar:
   - `client_id`: `beni-digital`
   - `redirect_uri`: `bo.gob.beni.digital:/oauth`
   - sin secreto, PKCE S256 obligatorio.

Hasta entonces la app usa el login del prototipo.

## Por hacer en la app

- **Es un prototipo**: datos ficticios en `lib/modulos/jichi/datos_jichi.dart`. Conectar a la API real de Jichi (`/api/app/v1`, por construir) y al login de Ibare.
- La sesión vive en memoria: al cerrar la app hay que volver a ingresar.
- Módulos Paititi y Sedede: los arman sus equipos (ver AGREGAR-MODULO.md).
- Ícono y pantalla de inicio con la imagen de la Gobernación.
- Notificaciones push.
- Cuenta de Google Play y App Store de la Gobernación para publicar.
