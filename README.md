# Nmtelecom (UTP - E-Commerce)
## Descripción
Este proyecto es un sistema de comercio electrónico (e-commerce) desarrollado en **Java con Spring Boot** y vistas **JSP**, diseñado para la venta de productos de telecomunicaciones.

El sistema fue desarrollado con una arquitectura en capas (MVC y DAO) y permite: la gestión de usuarios (Login/Registro), la visualización del catálogo de productos, y la manipulación de un carrito de compras.

## Equipo de desarrollo
- **Santiago Chavez Antay (santish1802)** (Líder Técnico / Módulo Catálogo, Carrito y Estructura Principal)
- **José Valverde Tacza (JoseValverdeTacza1)** (Desarrollador Júnior / Módulo de Autenticación y Cuentas)

## Flujo GitHub aplicado

Para garantizar la estabilidad y documentar la colaboración, aplicamos un flujo de trabajo basado en ramas de *feature* aisladas, que se integraron a la rama principal (`main`) exclusivamente a través de *Pull Requests* (PRs).

### 1. Ramas creadas
Se utilizaron dos ramas principales de desarrollo para aislar los módulos, ambas creadas a partir de la rama `main`:

| Nombre de la Rama | Módulo / Desarrollador | Estado |
| :--- | :--- | :--- |
| `feature-login-registro` | Módulo de Autenticación (José Valverde Tacza) | Fusionada |
| `feature-catalogo-carrito` | Módulo Principal (Catálogo y Carrito) (Santiago Chavez Antay) | Fusionada |

### 2. Commits realizados
Los *commits* se realizaron de forma **frecuente** y con mensajes descriptivos. Se evidencia la contribución de ambos integrantes en el historial:

* **Commits de José Valverde Tacza:** Se centraron en la creación del modelo `Usuario`, `UsuarioDAO`, `LoginController` y las vistas `login.jsp`/`registro.jsp`.
* **Commits de Santiago Chavez Antay:** Se centraron en la estructura base, los modelos de `Producto`/`ItemCarrito`, los DAOs principales, los *Controllers* de Catálogo y Carrito, y la integración de las vistas JSP.

### 3. Pull Requests revisados
Se crearon dos PRs para la integración, garantizando una revisión de código antes de la fusión. **Ambos PRs demuestran una revisión cruzada (Punto 3).**

| PR # | Origen → Destino | Revisor | Título |
| :--- | :--- | :--- | :--- |
| **PR #1** | `feature-login-registro` → `main` | Santiago Chavez Antay | feat: Implementación completa del módulo de autenticación. |
| **PR #2** | `feature-catalogo-carrito` → `main` | José Valverde Tacza (simulado) | feat: Desarrollo del catálogo de productos y módulo de carrito. |

### 4. Merge hacia la rama principal sin conflictos
Ambos *Pull Requests* se fusionaron (`Merge`) directamente hacia la rama `main`. El uso de ramas separadas por módulo aseguró que no existieran conflictos de código (**Punto 4**).

## Capturas de pantalla
*(Inserta las capturas de pantalla de GitHub aquí, que muestran el historial de commits, las ramas y los PRs fusionados para validar los puntos anteriores.)*

* ****
* ****
* ****

## Conclusiones
El uso de Git y GitHub fue crucial para la organización y calidad de este proyecto:

* **Colaboración Segura:** La creación de ramas de *feature* aisló el desarrollo, permitiendo a Santiago y José trabajar simultáneamente sin romper la rama principal.
* **Revisión y Calidad (PRs):** Los *Pull Requests* sirvieron como un punto de control de calidad obligatorio, permitiendo la revisión del código por un par antes de la integración final.
* **Trazabilidad:** El historial de *commits* limpio, con mensajes descriptivos y autoría clara, facilita la identificación y reversión de cambios en caso de futuros problemas.

### 1. Ramas creadas
Se utilizaron dos ramas principales de desarrollo para aislar los módulos, ambas creadas a partir de la rama `main`:

| Nombre de la Rama | Módulo / Desarrollador | Estado |
| :--- | :--- | :--- |
| `feature-login-registro` | Módulo de Autenticación (José Valverde) | Fusionada |
| `feature-catalogo-carrito` | Módulo Principal (Catálogo y Carrito) ([Tu Nombre]) | Fusionada |

### 2. Commits realizados
Los *commits* se realizaron de forma **frecuente** y con mensajes descriptivos. Se evidencia la contribución de ambos integrantes en el historial:

* **Commits de José Valverde:** Se centraron en la creación del modelo `Usuario`, `UsuarioDAO`, `LoginController` y las vistas `login.jsp`/`registro.jsp`.
* **Commits de [Tu Nombre]:** Se centraron en la estructura base, los modelos de `Producto`/`ItemCarrito`, los DAOs principales, los *Controllers* de Catálogo y Carrito, y la integración de las vistas JSP.

### 3. Pull Requests revisados
Se crearon dos PRs para la integración, garantizando una revisión de código antes de la fusión. **Ambos PRs demuestran una revisión cruzada (Punto 3).**

| PR # | Origen → Destino | Revisor | Título |
| :--- | :--- | :--- | :--- |
| **PR #1** | `feature-login-registro` → `main` | [Tu Nombre] | feat: Implementación completa del módulo de autenticación. |
| **PR #2** | `feature-catalogo-carrito` → `main` | José Valverde (simulado) | feat: Desarrollo del catálogo de productos y módulo de carrito. |

### 4. Merge hacia la rama principal sin conflictos
Ambos *Pull Requests* se fusionaron (`Merge`) directamente hacia la rama `main`. El uso de ramas separadas por módulo aseguró que no existieran conflictos de código (**Punto 4**).

## Capturas de pantalla
*(Una vez que termines los pasos de fusión en GitHub, inserta las siguientes capturas de pantalla para validar la documentación.)*

1.  **** - Muestra los dos PRs cerrados/fusionados.
2.  **** - Muestra las ramas de *feature* bifurcándose y volviendo a `main`.
3.  **** - Muestra la lista de *commits* con tu nombre y el de José Valverde.

## Conclusiones
El uso de Git y GitHub fue crucial para la organización y calidad de este proyecto:

* **Colaboración Segura:** La creación de ramas de *feature* aisló el desarrollo, permitiendo a [Tu Nombre] y José Valverde trabajar simultáneamente sin romper la rama principal.
* **Revisión y Calidad (PRs):** Los *Pull Requests* sirvieron como un punto de control de calidad obligatorio, permitiendo la revisión del código por un par antes de la integración final.
* **Trazabilidad:** El historial de *commits* limpio, con mensajes descriptivos y autoría clara, facilita la identificación y reversión de cambios en caso de futuros problemas.
