# MeepleMeet API

Backend REST de **MeepleMeet**, una aplicación social para personas aficionadas a los juegos de mesa. La API proporcionará el catálogo de juegos, las ludotecas personales y las quedadas para jugar.

Este servidor forma parte del proyecto final del Swift Mastery Program. El objetivo es conectarlo con una aplicación SwiftUI para iPhone, iPad y macOS, usando persistencia real, autenticación segura y reglas de negocio verificables.

## Estado actual

La base del servidor está creada con Vapor y Fluent, con SQLite para desarrollo local. Incluye:

- `GET /health` para comprobar que la API responde.
- `GET /api/v1/games` para listar el catálogo y `GET /api/v1/games/:gameID` para consultar un juego.
- Búsqueda parcial por título mediante `GET /api/v1/games?q=azul`.
- Modelos y migraciones iniciales para usuarios, juegos, ludotecas, quedadas y participantes.
- Una migración de desarrollo que carga juegos de muestra con enlaces a sus reglas.

El catálogo ya tiene su primera ruta y persistencia modeladas. El siguiente paso es arrancar la aplicación localmente y confirmar que las migraciones y las consultas funcionan en SQLite; después se añadirá una prueba automatizada del endpoint de salud o del catálogo.

## Tecnologías

- Swift 6.2+
- Vapor 4
- Fluent
- SQLite para desarrollo local
- Swift Concurrency (`async`/`await`)

## Requisitos

- macOS y Swift 6.2 o superior.
- Swift Package Manager, incluido con Swift.

## Ejecutar en local

Desde la raíz de este paquete:

```sh
swift run
```

Vapor aplica las migraciones registradas al iniciar. En desarrollo, la base SQLite se crea por defecto como `meeplemeet.sqlite` en el directorio de trabajo del servidor. Si defines `DATABASE_PATH`, SQLite usará esa ruta.

En otra terminal, comprueba el servidor y consulta el catálogo:

```sh
curl -i http://localhost:8080/health
curl -i http://localhost:8080/api/v1/games
curl -i 'http://localhost:8080/api/v1/games?q=azul'
```

La búsqueda devuelve juegos cuyo título contiene la consulta. La semilla de muestra solo se registra en el entorno de desarrollo.

## Primer sprint: cierre del catálogo vertical

- [x] Crear el paquete Vapor y configurar Fluent con SQLite.
- [x] Definir el modelo `Game` y su migración.
- [x] Implementar las rutas de salud y consulta del catálogo.
- [x] Añadir juegos de muestra y búsqueda parcial por título.
- [ ] Arrancar el servidor y verificar que la migración crea las tablas correctamente.
- [ ] Confirmar con `curl` que la lista y la búsqueda devuelven datos persistidos en SQLite.
- [ ] Añadir una prueba automatizada para `/health` o el catálogo.
- [ ] Mantener estos pasos y cualquier incidencia documentados para poder repetir la puesta en marcha.

## Siguientes pasos del MVP

1. **Terminar y verificar el catálogo:** validar respuestas, errores, persistencia y búsqueda; documentar los campos que devuelve la API.
2. **Autenticación:** implementar registro, inicio y cierre de sesión, almacenamiento de contraseñas con hash seguro y protección de rutas privadas.
3. **Ludoteca personal:** permitir consultar, añadir y quitar juegos del usuario autenticado, respetando la unicidad usuario/juego.
4. **Quedadas:** crear y consultar partidas, permitir apuntarse o cancelar la asistencia y comprobar el aforo de forma segura.
5. **Calidad e integración:** cubrir reglas críticas con pruebas, documentar los endpoints y conectar la API con el cliente SwiftUI mediante DTOs y `async`/`await`.

El chat en tiempo real y las notificaciones push quedan fuera del MVP inicial.

## Estructura

```text
Sources/MeepleMeetAPI/
├── Controllers/   # Endpoints HTTP
├── Migrations/    # Esquemas y datos iniciales
├── Models/        # Modelos Fluent
├── configure.swift
├── entrypoint.swift
└── routes.swift
```

## Alcance de datos de muestra

En desarrollo, `SeedSampleGames` carga Catán, Wingspan, Azul, Ark Nova, Dixit y La Tripulación. Esta migración borra y recrea únicamente esos títulos de muestra cuando se aplica; no elimina otros juegos del catálogo. Los enlaces apuntan a reglas en castellano cuando se localizó una descarga pública. Para Ark Nova se usa la ficha oficial española de Maldito Games.

No se incluyen credenciales ni claves privadas en el repositorio. Los secretos para autenticación y despliegue se configurarán mediante variables de entorno cuando se implemente esa parte.
