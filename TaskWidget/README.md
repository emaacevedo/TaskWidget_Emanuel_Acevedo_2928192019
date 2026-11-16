# TaskWidget — Tema 20: WidgetKit + App Intents

Proyecto SwiftUI para iOS 17+, con app de tareas y widget interactivo.

## Requisitos
- Mac con **macOS Ventura 13.5 o posterior** y **Xcode 15 o posterior** (recomendado Xcode 16+).
- Simulador iOS 17+ o iPhone compatible.
- Para ejecutar en dispositivo real: cuenta de desarrollo y firma configurada.
- **macOS Monterey no ejecuta Xcode 15**. Se debe actualizar el Mac/VM.

## Abrir
1. Descomprime el ZIP y abre `TaskWidget.xcodeproj` con Xcode.
2. Selecciona el proyecto azul **TaskWidget** y, para **ambos targets** (TaskWidget y TaskWidgetExtension), entra en **Signing & Capabilities**.
3. Cambia los **Bundle Identifiers** por identificadores únicos, por ejemplo `sv.tunombre.taskwidget` y `sv.tunombre.taskwidget.extension`.
4. En ambos targets configura el mismo **App Group**, por ejemplo `group.sv.tunombre.taskwidget` (en Signing & Capabilities > + Capability > App Groups). Cambia también `groupID` en `Shared/TaskStore.swift` y el valor en ambos archivos `.entitlements`. Es indispensable que los tres valores coincidan. Si Xcode requiere equipo de desarrollo, selecciona tu Team. El uso de App Groups puede requerir una cuenta/equipo con capacidades de aprovisionamiento adecuadas.
5. Selecciona el scheme **TaskWidget** y un simulador iOS 17+, y pulsa **Run**.
6. Agrega tareas. Ve a la pantalla de inicio del simulador, mantén pulsado, selecciona **Añadir widget**, busca **TaskWidget** y agrega el widget mediano.
7. Pulsa el círculo junto a una tarea del widget para completarla sin abrir la app. Regresa a la app para comprobar el cambio.

## Solución de problemas
- Si las tareas no aparecen en el widget, comprueba que ambos targets tengan exactamente el mismo App Group y que `TaskStore.groupID` coincida.
- Si aparece un error de firma/provisioning, revisa Team, Bundle IDs y la capacidad App Groups de ambos targets.
- Si el widget no aparece, ejecuta la app al menos una vez y reinicia el simulador si hace falta.
- No se ha compilado aquí: se entrega el código y proyecto preparados, pero la compilación y firma deben verificarse en Xcode sobre macOS.

## Estructura
- `TaskWidgetApp`: app principal SwiftUI.
- `TaskWidgetExtension`: widget interactivo y `ToggleTaskIntent`.
- `Shared`: modelo y persistencia compartida en UserDefaults de App Group.

## Guion breve para la demostración
1. Introducción a WidgetKit y App Intents (2 min).
2. Estructura de targets y almacenamiento compartido (3 min).
3. Crear, completar y eliminar tareas en la app (3 min).
4. Agregar el widget y completar una tarea desde él (4 min).
5. Explicar `ToggleTaskIntent` y conclusiones (3 min).
