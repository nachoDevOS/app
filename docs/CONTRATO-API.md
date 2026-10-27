# Contrato de API para los sistemas de Beni Digital

> Para los equipos de **Jichi, Paititi y Sedede**. Lo mínimo que cada backend
> expone para aparecer en la app. Lo demás de cada sistema es libre.

## 1. Autenticación

- Cada pedido trae `Authorization: Bearer <token de Ibare>`.
- El backend valida el JWT con el JWKS de Ibare (`/.well-known/jwks.json`): firma,
  `exp` y que `aud` incluya `beni-digital`.
- Del token sale la persona. **La llave común entre sistemas es la cédula de
  identidad**: cada sistema busca sus propios datos por C.I.
- Sin token o con uno inválido: `401`. La app vuelve al login.

## 2. Prefijo

`/api/app/v1/…` en el dominio de cada sistema.

## 3. Endpoints obligatorios

### `GET /api/app/v1/resumen`

Tarjetas para el inicio de la app. Hasta 3, la más urgente primero.

```json
{
  "tarjetas": [
    {
      "titulo": "Carnet de pescador",
      "detalle": "Vence el 31/12/2026",
      "nivel": "info",
      "ruta": "/jichi/carnets/A7K2-9QXM"
    }
  ]
}
```

`nivel`: `info` · `exito` · `atencion` · `urgente`. `ruta` es opcional: adónde
lleva el toque, dentro del módulo.

### `GET /api/app/v1/avisos`

```json
{
  "avisos": [
    {
      "id": "pago-123",
      "titulo": "Pago pendiente",
      "detalle": "Autorización de Pesca para Aprovechamiento Pesquero: Bs 150,00",
      "fecha": "2026-10-25T10:30:00-04:00",
      "ruta": "/jichi/autorizaciones/X3P9-2LMA"
    }
  ]
}
```

## 4. Formatos

| Qué | Cómo |
| --- | --- |
| Un DÍA (vencimiento, nacimiento) | `"2026-12-31"` |
| Un MOMENTO (cuándo se pagó) | ISO 8601 con zona: `"2026-10-25T10:30:00-04:00"` |
| Dinero | Número en bolivianos, dos decimales: `150.00` |
| Error | `{ "mensaje": "Texto para mostrar al ciudadano", "codigo": "SIN_CARNET" }` |

## 5. Lo que NO va

- Datos de otras personas: todo sale del token, ningún endpoint recibe una C.I.
- Datos internos (ids de base, nombres de tablas, estados técnicos sin traducir).
