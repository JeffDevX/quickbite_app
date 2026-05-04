# QuickBite App

Una aplicación móvil de delivery de comida desarrollada en Flutter con arquitectura BLoC, Firebase backend y autenticación de usuarios.

## 🚀 Características

- **🍔 Menú Interactivo**: Navegación por categorías de comida (Combos, Hamburguesas, Pizzas, Bebidas)
- **👤 Autenticación de Usuarios**: Sistema de login y registro con Firebase Auth
- **🛒 Carrito de Compras**: Gestión de productos seleccionados
- **📱 Dashboard Admin**: Panel de administración para gestión de pedidos
- **🔥 Tiempo Real**: Sincronización en tiempo real con Firestore
- **📊 Reportes**: Visualización de estadísticas y métricas
- **🎨 UI/UX Moderna**: Diseño responsivo con Material Design

## 📱 Screenshots

_(Agrega capturas de pantalla de la aplicación)_

## 🛠️ Stack Tecnológico

### Frontend

- **Flutter** - Framework de desarrollo multiplataforma
- **Dart** - Lenguaje de programación
- **Material Design** - Sistema de diseño UI

### Arquitectura

- **BLoC Pattern** - Gestión de estado
- **GoRouter** - Navegación y routing
- **Repository Pattern** - Capa de datos

### Backend & Servicios

- **Firebase Auth** - Autenticación de usuarios
- **Cloud Firestore** - Base de datos NoSQL
- **Cloud Functions** - Backend serverless
- **Firebase Crashlytics** - Reporte de errores

## 📁 Estructura del Proyecto

```
lib/
├── core/                    # Configuración global y utilidades
│   └── repositories/       # Repositorios principales
├── features/               # Módulos de funcionalidades
│   ├── cart/              # Carrito de compras
│   │   ├── bloc/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── screens/
│   ├── dashboard/         # Panel administrativo
│   │   ├── orders_bloc/
│   │   └── screens/
│   ├── home/              # Pantalla principal
│   │   ├── bloc/
│   │   ├── models/
│   │   ├── repository/
│   │   ├── screens/
│   │   └── widgets/
│   ├── login/             # Autenticación
│   │   ├── auth/bloc/
│   │   ├── bloc/
│   │   └── screens/
│   └── register/          # Registro de usuarios
│       ├── bloc/
│       └── screens/
├── routes/                # Configuración de rutas
├── firebase_options.dart  # Configuración Firebase
└── main.dart             # Punto de entrada
```

## 🚀 Instalación

### Prerrequisitos

- Flutter SDK (versión 3.7.2 o superior)
- Dart SDK
- Android Studio / Xcode
- Firebase project configurado

### Pasos

1. **Clonar el repositorio**

   ```bash
   git clone <repository-url>
   cd quickbite_app
   ```

2. **Instalar dependencias**

   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - Crear proyecto en Firebase Console
   - Configurar Android/iOS apps
   - Descargar archivos de configuración:
     - Android: `google-services.json` → `android/app/`
     - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Habilitar servicios: Auth, Firestore, Functions, Crashlytics

4. **Configurar Firestore Rules**

   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /products/{document} {
         allow read: if true;
         allow write: if request.auth != null;
       }
       match /orders/{document} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

5. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 🔧 Configuración

### Variables de Entorno

El proyecto utiliza configuración automática de Firebase a través de `firebase_options.dart`.

### Assets

Las imágenes están ubicadas en `assets/images/` y configuradas en `pubspec.yaml`.

## 📦 Dependencias Principales

- `flutter_bloc: ^9.1.1` - Gestión de estado BLoC
- `go_router: ^17.1.0` - Navegación declarativa
- `firebase_auth: ^6.4.0` - Autenticación
- `cloud_firestore: ^6.1.2` - Base de datos
- `cloud_functions: ^6.1.0` - Funciones backend
- `cached_network_image: ^3.4.1` - Caché de imágenes
- `equatable: ^2.0.8` - Comparación de objetos

## 🏗️ Arquitectura

### BLoC Pattern

La aplicación sigue el patrón BLoC para la gestión de estado:

- **Events**: Acciones del usuario (ej. `LoadProducts`, `AddToCart`)
- **States**: Estados de la UI (ej. `ProductLoading`, `ProductLoaded`)
- **BLoCs**: Conectan events con states

### Navegación

- **GoRouter** para routing declarativo
- **Guardias de autenticación** para rutas protegidas
- **Redirección basada en roles** (admin/user)

### Repositorios

- **ProductsRepository**: Gestión de productos desde Firestore
- **AuthRepository**: Manejo de autenticación

## 🔐 Autenticación y Roles

### Flujo de Autenticación

1. Login/Registro → Firebase Auth
2. Verificación de email
3. Obtención de rol desde Firestore
4. Redirección según rol:
   - `admin` → `/dashboard`
   - `user` → `/home`

### Roles de Usuario

- **Admin**: Acceso completo al dashboard
- **User**: Acceso limitado al menú y carrito

## 📊 Funcionalidades Principales

### Home Screen

- Búsqueda de productos
- Filtrado por categorías
- Grid de productos con imágenes cacheadas

### Carrito de Compras

- Agregar/eliminar productos
- Actualización de cantidades
- Cálculo de totales

### Dashboard Admin

- Gestión de pedidos
- Estadísticas de ventas
- Gestión de productos

### Perfil de Usuario

- Información personal
- Historial de pedidos
- Configuración

## 🧪 Testing

```bash
# Ejecutar tests unitarios
flutter test

# Ejecutar tests con cobertura
flutter test --coverage
```

## 📱 Build & Deploy

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 🔥 Firebase Functions

El proyecto incluye funciones backend en la carpeta `functions/`:

- Procesamiento de pedidos
- Envío de notificaciones
- Generación de reportes

Deploy de funciones:

```bash
cd functions
npm run deploy
```

## 🐛 Debugging y Logs

### Crashlytics

La aplicación está configurada para enviar errores a Firebase Crashlytics automáticamente.

### Logs de Debug

- Logs de autenticación en consola
- Errores de Firestore detallados
- Estado de BLoC en desarrollo

## 🤝 Contribución

1. Fork del proyecto
2. Crear feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit de cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo licencia MIT - ver archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

- **Desarrollador**: Jeffrey DevX
- **Email**: [tu-email@example.com]
- **Proyecto**: QuickBite App

## 🙏 Agradecimientos

- Equipo Flutter por el framework increíble
- Firebase por los servicios backend
- Comunidad de desarrollo Flutter

---

**QuickBite** - Tu delivery de comida favorito, al alcance de tu mano. 🍔📱
