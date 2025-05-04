# Pet Manager

## Descripción

Pet Manager es una aplicación móvil desarrollada con Flutter que ayuda a los dueños de mascotas a gestionar el cuidado diario de sus animales. La aplicación permite:

- **Gestión de mascotas:** Agregar, editar y eliminar mascotas.
- **Registro de vacunas:** Almacenar y visualizar el historial de vacunación.
- **Registro de baños:** Llevar un control de los baños realizados.
- **Configuración de alimentación:** Calcular el consumo diario y total de alimento, con recomendaciones basadas en la fecha de compra y el stock disponible.
- **Autenticación básica:** Páginas de inicio de sesión y registro, utilizando datos estáticos (json) para la validación.

## Características

- Interfaz intuitiva basada en Material Design.
- Uso de la fuente “Inter” para una experiencia visual moderna.
- Múltiples plataformas soportadas (Android, iOS, Web, Escritorio).
- Manejo de datos en memoria (sin persistencia en almacenamiento local).

## Estructura del Proyecto

```
pet_manager_app
├── android
├── ios
├── lib
│   ├── models
│   │   ├── pet.dart
│   │   ├── vaccine.dart
│   │   ├── shower.dart
│   │   └── feed.dart
│   ├── pages
│   │   ├── login_page.dart
│   │   ├── register_page.dart
│   │   ├── home_page.dart
│   │   ├── pets
│   │   │   ├── add_pet_page.dart
│   │   │   ├── pet_page.dart
│   │   │   └── edit_pet_page.dart
│   │   ├── vaccines
│   │   │   └── add_vaccine_page.dart
│   │   └── feed_configuration_page.dart
│   ├── providers
│   │   └── pet_provider.dart
│   ├── services
│   └── widgets
│       ├── pet_card.dart
│       ├── feed_card.dart
│       ├── text_fields.dart
│       └── common_widgets.dart
├── assets
│   ├── images
│   └── data
│       ├── pets.json
│       ├── feeding.json
│       └── users.json
├── pubspec.yaml
└── README.md
```

## Requisitos

- Flutter SDK (>= 3.7.0)
- Dart SDK (compatible con la versión de Flutter)
- Herramientas de desarrollo para cada plataforma:
  - Xcode (iOS y macOS)
  - Android Studio y SDK (Android)
  - Visual Studio (Windows)
  - CMake (para compilaciones en Linux y Windows, en caso de soporte de escritorio)

## Instalación y Configuración

1. **Clonar el repositorio:**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd pet_manager_app
   ```
2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```
3. **Ejecutar la aplicación:**
   - Para dispositivos móviles:
     ```bash
     flutter run
     ```
   - Para web o escritorio, especifica el dispositivo:
     ```bash
     flutter run -d chrome
     flutter run -d windows
     flutter run -d macos
     flutter run -d linux
     ```

## Uso

- **Inicio de Sesión y Registro:** Utiliza la pantalla de login para acceder. Los datos de autenticación se validan con el archivo `assets/data/users.json`.
- **Gestión de Mascotas:** Desde la página de inicio, visualiza la lista de mascotas. Puedes agregar una nueva mascota, editar o eliminar las existentes.
- **Registro de Vacunas y Baños:** En la página de cada mascota, registra eventos relacionados con la vacunación y baños.
- **Configuración de Alimentación:** Define y visualiza la configuración de alimentación, con cálculos automáticos sobre consumo y stock.

## Contribución

Las contribuciones son bienvenidas:

- Realiza un fork del repositorio y crea una rama para tu cambio:
  ```bash
  git checkout -b feature/nueva-funcionalidad
  ```
- Realiza tus commits con mensajes claros.
- Envía un Pull Request describiendo los cambios.
