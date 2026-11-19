# MeepleMeet API

Backend REST de **MeepleMeet**, una aplicación social para personas aficionadas a los juegos de mesa. La API proporcionará el catálogo de juegos, las ludotecas personales y las quedadas para jugar.

Este servidor forma parte del proyecto final del Swift Mastery Program. El objetivo es conectarlo con una aplicación SwiftUI para iPhone, iPad y macOS, usando persistencia real, autenticación segura y reglas de negocio verificables.

## Estado actual

La base del servidor está creada con Vapor y Fluent, con SQLite para desarrollo local. Incluye:

- `GET /health` para comprobar que la API responde.
- `GET /api/v1/games` para listar el catálogo y `GET /api/v1/games/:gameID` para consultar un juego, incluida la URL de portada `image`.
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

Antes del primer arranque, asegúrate de que existen las claves ECDSA (consulta **Registro e inicio de sesión** más abajo). Después, ejecuta desde la raíz de este paquete, es decir, la carpeta que contiene `Package.swift`:

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

### Ejecutar desde Xcode

Al abrir `Package.swift` en Xcode, configura el esquema del ejecutable para que use como directorio de trabajo la raíz del paquete. Así Vapor encontrará la carpeta `keys/` y creará `meeplemeet.sqlite` en una ubicación predecible:

1. Selecciona el esquema ejecutable **MeepleMeetAPI**.
2. Abre **Product > Scheme > Edit Scheme…**.
3. Selecciona la acción **Run** y abre **Options**.
4. Activa **Use custom working directory** y elige la carpeta `MeepleMeetAPI` que contiene `Package.swift`, `Sources/` y `keys/`.
5. Ejecuta el esquema.

Si Xcode muestra el error `meeplemeet_ecdsa-private.pem couldn't be opened`, comprueba que el directorio de trabajo termina en la raíz de `MeepleMeetAPI` y que `keys/meeplemeet_ecdsa-private.pem` existe ahí.

## Registro e inicio de sesión

La autenticación inicial ofrece estos endpoints:

- `POST /api/v1/auth/register` recibe `name`, `email` y `password`; devuelve `201 Created`. La contraseña debe tener al menos 8 caracteres.
- `POST /api/v1/auth/login` recibe el email y la contraseña mediante autenticación HTTP Basic; devuelve un JWT válido durante 24 horas y los datos públicos del usuario.

Ejemplo de registro:

```sh
curl -i -X POST http://localhost:8080/api/v1/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"name":"Ana","email":"ana@example.com","password":"una-clave-segura"}'
```

Ejemplo de login:

```sh
curl -i -X POST http://localhost:8080/api/v1/auth/login \
  -u 'ana@example.com:una-clave-segura'
```

En Postman, selecciona `POST http://localhost:8080/api/v1/auth/login`, abre **Authorization**, elige **Basic Auth** y escribe el email en **Username** y la contraseña en **Password**. No hace falta un body JSON. Pulsa **Send**; si las credenciales son correctas, recibirás `200 OK` con `token` y `user`. Para credenciales incorrectas o ausentes, el servidor responde `401 Unauthorized`.

El middleware `User.authenticator()` consulta el usuario por email y valida la contraseña con BCrypt a través de `User.verify(password:)`. `User.guardMiddleware()` exige que ese proceso haya autenticado a un usuario antes de ejecutar el handler; el handler obtiene ese usuario con `req.auth.require(User.self)` y emite el JWT. El email se compara distinguiendo mayúsculas y minúsculas, por eso se debe enviar en minúsculas tal como se normaliza al registrarse. HTTP Basic codifica las credenciales en Base64, no las cifra: úsalo sobre HTTPS en un servidor accesible por red.

Los tokens se firman con ES256 usando la clave privada `keys/meeplemeet_ecdsa-private.pem`, relativa al directorio de trabajo configurado para el servidor. El par local de claves se genera una vez al clonar/configurar el proyecto (ver abajo); la carpeta `keys/` está excluida de Git. Mantén la clave privada fuera del repositorio y del cliente. La clave pública `keys/meeplemeet_ecdsa-public.pem` se puede distribuir a otros servicios que necesiten verificar tokens. Estos endpoints emiten tokens; las rutas privadas y su middleware de verificación se añadirán al implementar recursos autenticados.

Si aún no existen las claves, desde la raíz de `MeepleMeetAPI` ejecuta:

```sh
mkdir -p keys
openssl ecparam -name prime256v1 -genkey -noout -out keys/meeplemeet_ecdsa-private.pem
openssl ec -in keys/meeplemeet_ecdsa-private.pem -pubout -out keys/meeplemeet_ecdsa-public.pem
```

La clave privada se queda en el servidor para firmar. Para comprobar una firma desde otro servicio basta la pública; no le compartas la privada.

## Primer sprint: cierre del catálogo vertical

- [x] Crear el paquete Vapor y configurar Fluent con SQLite.
- [x] Definir el modelo `Game` y sus migraciones, incluida la URL opcional de imagen.
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
