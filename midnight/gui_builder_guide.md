# Guía y Referencia Técnica Completa: Motor GUI Builder Basado en Esquemas (`gui_builder`)

Esta documentación sirve como guía técnica y de desarrollo completa para el motor de interfaz de usuario de **BetterBlizzFrames** (`midnight/gui_builder.lua`).

El objetivo principal de esta arquitectura es **separar completamente el diseño de la lógica**:
- **Los archivos de esquema** (`gui_general.lua`, `gui_audio.lua`, etc.) son tablas de datos puras y limpias.
- **El motor** (`gui_builder.lua`) ejecuta todo el código imperativo de la API de WoW, las matemáticas de diseño, la gestión de temas, las jerarquías de dependencia y el posicionamiento en cuadrícula.

---

## Índice

1. [Estructura del Esquema: Ventanas Principales (`tabs`) vs Ventanas Emergentes (`popups`)](#1-estructura-del-esquema-ventanas-principales-tabs-vs-ventanas-emergentes-popups)
2. [Tipos de Componentes (`type`)](#2-tipos-de-componentes-type)
3. [Componente `slider` (Barras Deslizantes Numericas)](#3-componente-slider-barras-deslizantes-numericas)
4. [Callbacks de Actualización en Vivo (`onChange`)](#4-callbacks-de-actualización-en-vivo-onchange)
5. [Enriquecimiento de Tooltips con Iconos de WoW (`|A:...|a`)](#5-enriquecimiento-de-tooltips-con-iconos-de-wow-aa)
6. [Interacciones con Clic Derecho (`onRightClick` y `HandleRightClick`)](#6-interacciones-con-clic-derecho-onrightclick-y-handlerightclick)
7. [Relaciones Padre e Hijo (`parent`, `parents`, `children`)](#7-relaciones-padre-e-hijo-parent-parents-children)
8. [Posicionamiento en Cuadrícula (`colorGrid`, `cols`, `col`, `rows`, `row`)](#8-posicionamiento-en-cuadrícula-colorgrid-cols-col-rows-row)
9. [Matemáticas del Salto de Fila y Auto-Acomodo](#9-matemáticas-del-salto-de-fila-y-auto-acomodo)
10. [Diseño en la Misma Línea (`inline` y Centrado Vertical)](#10-diseño-en-la-misma-línea-inline-y-centrado-vertical)
11. [Control de Espaciados y Márgenes (`margin`, `marginTop`, `marginBottom`)](#11-control-de-espaciados-y-márgenes-margin-margintop-marginbottom)
12. [Normalización Inteligente de Claves (`key`)](#12-normalización-inteligente-de-claves-key)
13. [Componentes Dinámicos (`allClassSwatches` y `allPowerSwatches`)](#13-componentes-dinámicos-allclassswatches-y-allpowerswatches)
14. [Ejemplos Completos y Casos de Uso](#14-ejemplos-completos-y-casos-de-uso)

---

## 1. Estructura del Esquema: Ventanas Principales (`tabs`) vs Ventanas Emergentes (`popups`)

Todo archivo de esquema exporta una tabla con dos registros principales: `tabs` y `popups`.

### A. Pestañas de la Ventana Principal (`tabs`)
`tabs` define las pestañas de navegación lateral izquierda en la ventana principal del addon.

```lua
tabs = {
    {
        id          = "party",
        label       = L["Party_Frame"],
        atlas       = "groupfinder-icon-friend",
        size        = {20, 20},
        desaturated = true,
        color       = {0.1, 0.6, 1},
        overlays    = {
            { atlas="groupfinder-icon-friend", size={16,16}, offset={4,3}, desaturated=true, color={0,1,0} },
        },
        cards = {
            {
                title = L["Frame_Layout"],
                options = { ... }
            }
        }
    }
}
```

#### Atributos de Pestaña (`tabs`):
- **`id`**: Identificador único de la pestaña (ej. `"party"`, `"general"`).
- **`label`**: Texto visible en el botón lateral.
- **`atlas` / `icon`**: Icono o atlas nativo de WoW para la pestaña.
- **`size`**: Tamaño `{ ancho, alto }` del icono (ej. `{20, 20}`).
- **`desaturated`**: `true` para desaturar (escala de grises) la textura del icono.
- **`color`**: Color RGB `{ r, g, b }` aplicado al icono mediante `SetVertexColor`.
- **`overlays`**: Lista de capas de iconos superpuestos (*icon layering*) para crear iconos compuestos avanzados (soporta `atlas`, `size`, `offset={x,y}`, `desaturated` y `color`).
- **`cards`**: Contenedores visuales tipo tarjeta (*Cards*) dentro de la pestaña. Cada tarjeta tiene un `title` y una lista de `options`.

---

### B. Ventanas Emergentes (`popups`)
`popups` define ventanas flotantes secundarias (ej. Opciones específicas de clase, Opciones de colores personalizados).

```lua
popups = {
    customColors = {
        id         = "BBFCustomColorOptionsFrame",
        title      = L["Custom_Health_Colors"],
        width      = 360,
        height     = 560,
        scrollable = true,
        options    = { ... }
    }
}
```

#### Atributos de Ventana Emergente (`popups`):
- **`id`**: Identificador del marco emergente (ej. `"BBFCustomColorOptionsFrame"`).
- **`title`**: Título del marco emergente visible en la barra superior.
- **`width` / `height`**: Dimensiones fijas de la ventana flotante en píxeles.
- **`scrollable`**: `true` si la ventana emergente incluye una barra de desplazamiento (*ScrollFrame*).
- **`options`**: Lista directa de opciones (sin necesidad de dividirse en `cards`).

---

## 2. Tipos de Componentes (`type`)

| `type` | Descripción | Exclusivo / Compartido |
| :--- | :--- | :--- |
| **`checkbox`** | Casilla de verificación estándar (soporta `parent`, `parents`, `children`). | Compartido |
| **`classCheckbox`** | Casilla de clase con nombre formateado y color de clase automático por `classID`. | Compartido |
| **`slider`** | Barra deslizante numérica con `min`, `max`, `step`. | Compartido |
| **`dualchild`** | Fila compacta con 2 casillas hijas lado a lado. | Compartido |
| **`header`** | Título/encabezado de sección visual. | Compartido |
| **`preview`** | Vista previa de textura o atlas (ej. marco de salud desaturado). | Compartido |
| **`colorGrid`** | Cuadrícula flexible de botones de muestra de color (*color swatches*). | Compartido |
| **`colorSwatchDual`** | Par de muestras de color en una fila (ej. Color Vida y Color Mana). | Compartido |
| **`allClassSwatches`** | Genera muestras de color para las 13 clases de WoW. | Compartido |
| **`allPowerSwatches`** | Genera muestras de color para los tipos de recurso/poder de WoW. | Compartido |

---

## 3. Componente `slider` (Barras Deslizantes Numéricas)

El componente `slider` se utiliza para valores numéricos continuos (escalas, opacidades, tamaños, contadores).

```lua
-- Modo Estándar (Valores Numéricos)
{ type="slider", key="partyFrameScale", label=L["Party_Frame_Scale"], tooltip=L["Tooltip_Scale"], min=0.7, max=1.7, step=0.01 }

-- Modo Porcentaje (percent = true)
{ type="slider", key="castbarAlpha", label=L["Opacity"], percent=true }
```

### Atributo `percent` en Deslizadores (`slider`):
- **`percent = true`**: Transforma el deslizador a modo **Porcentaje (`0%` a `100%`)**.
  - Si omites `min` y `max`, se asignan automáticamente los valores por defecto de `0` a `100`.
  - El motor formatea y añade automáticamente el símbolo `%` al valor mostrado (ej. `75%`, `100%`).
- **`percent = false` (Predeterminado):** Si omites la propiedad `percent` o la estableces en `false`, el deslizador se mide en **números puros estándares** (ej. `1.5`, `30`, `0.7`).

### Atributos de `slider`:
- **`key`**: Variable guardada en `BetterBlizzFramesDB` (ej. `BetterBlizzFramesDB["partyFrameScale"]`).
- **`label`**: Texto descriptivo visible al lado del deslizador.
- **`tooltip`**: Explicación detallada al pasar el ratón.
- **`min`**: Valor mínimo del deslizador (ej. `0.7` para 70% de escala, o `0` para 0% de opacidad).
- **`max`**: Valor máximo del deslizador (ej. `1.7` para 170% de escala, o `1` para 100% de opacidad).
- **`step`**: Incremento/Paso del deslizador (ej. `0.01` para decimales precisos o `1` para números enteros).
- **`onChange`**: (Opcional) Función que se ejecuta inmediatamente al mover el deslizador.

---

## 4. Callbacks de Actualización en Vivo (`onChange`)

### ¿Qué es `onChange`?
Es un puntero a una función de Lua que se ejecuta **inmediatamente cuando el usuario interactúa con la opción** (al marcar/desmarcar una casilla o mover un deslizador).

### Ejemplo:
```lua
{ type="checkbox", key="hidePartyFramesInArena", label=L["Hide_Party_in_Arena"], onChange=BBF.HidePartyInArena }
{ type="checkbox", key="darkModeUi", label=L["Dark_Mode"], onChange=function() BBF.DarkmodeFrames(true) end }
```

### ¿Por qué se usa y cómo funciona?
1. **Sin `onChange`:** El valor se guarda en `BetterBlizzFramesDB`, pero el cambio no se refleja en pantalla hasta que el usuario reinicie la interfaz (`/reload`).
2. **Con `onChange`:** En cuanto el usuario cambia la opción, el motor actualiza la base de datos y ejecuta la función especificada en `onChange` (ej. `BBF.HidePartyInArena()`), forzando el rediseño o la ocultación del marco en tiempo real sin recargar la interfaz.

---

## 5. Enriquecimiento de Tooltips con Iconos de WoW (`|A:...|a`)

### ¿Qué es la sintaxis `|A:atlasName:height:width|a`?
Es la sintaxis nativa de formateo de cadenas de texto en World of Warcraft para **incrustar texturas y atlas de la interfaz directamente dentro del texto**.

### Ejemplo en el Esquema:
```lua
tooltip = L["Tooltip_Add_Reputation_Color"] .. " |A:UI-HUD-UnitFrame-Target-PortraitOn-Type:14:76|a"
```

### Explicación de los Parámetros:
- **`|A:`**: Inicio de la secuencia de comandos de atlas.
- **`UI-HUD-UnitFrame-Target-PortraitOn-Type`**: Nombre del atlas nativo en los archivos de interfaz de Blizzard.
- **`14`**: Altura en píxeles con la que se dibujará la textura en el tooltip.
- **`76`**: Ancho en píxeles de la textura.
- **`|a`**: Cierre de la secuencia de comandos.

### ¿Para qué se usa?
Permite enriquecer los tooltips mostrando vistas previas de iconos nativos del juego (iconos de rol, iconos de dragón de élite, iconos de combate) dentro del propio texto del tooltip.

---

## 6. Interacciones con Clic Derecho (`onRightClick` y `HandleRightClick`)

El motor permite vincular acciones al hacer **clic derecho** sobre cualquier opción o título de la interfaz.

### Ejemplo de Vinculación en el Esquema:
```lua
{ type="checkbox", key="classColorFrames", label=L["Class_Color_Health"], onRightClick=BBF.ToggleClassColorRightClick }
```

O abriendo una ventana emergente:
```lua
{ type="checkbox", key="hidePlayerPower", label=L["Hide_Player_Power"], onRightClick=function(isShift, isCtrl, isAlt, widget)
    if BBF.OpenClassSpecificWindow then BBF.OpenClassSpecificWindow() end
end }
```

### ¿Cómo funciona internamente?
1. Al hacer clic derecho sobre una casilla o título, el motor intercepta el evento `OnMouseDown` con `btn == "RightButton"`.
2. Ejecuta la función `onRightClick` pasando los modificadores del teclado (`isShift`, `isCtrl`, `isAlt`) y la referencia del marco (`widget`).
3. Esto permite abrir ventanas secundarias de configuración (ej. `OpenClassSpecificWindow`), alternar modos de omisión (ej. `Skip Friendly` / `Skip Player`) o cambiar colores rápidamente sin ensuciar la interfaz principal.

---

## 7. Relaciones Padre e Hijo (`parent`, `parents`, `children`)

El motor soporta **dos formas equivalentes** de declarar dependencias entre opciones:

### Opción A: Referencia Plana Limpia (`parent="clave"`)
Recomendada para mantener la tabla de opciones plana y evitar anidamientos de llaves profundos (`{{{ ... }}}`):

```lua
{ type="checkbox", key="overrideClassColors", label=L["Override_Class_Colors"] },
{ type="checkbox", key="useOneClassColor",    label=L["Use_One_Color"], parent="overrideClassColors" },
```

- **Padre Múltiple (`parents`):** Para casillas que dependen de varias opciones a la vez:
```lua
{ type="checkbox", key="showSpecName", label=L["Show_Spec_Name"], parents={"cbTF", "cbParty"} }
```

### Opción B: Estructura Árbol Anidada (`children = { ... }`)
Para declarar sub-opciones como una lista anidada:

```lua
{ type="checkbox", key="overrideClassColors", label=L["Override_Class_Colors"],
  children = {
      { type="checkbox", key="useOneClassColor", label=L["Use_One_Color"] },
      { type="allClassSwatches" },
  }
}
```

*Comportamiento del Motor:*
Al desmarcar la casilla padre (`overrideClassColors`), el motor atenúa (opacidad `0.4`) y deshabilita automáticamente todas las opciones hijas vinculadas.

---

## 8. Posicionamiento en Cuadrícula (`colorGrid`, `cols`, `col`, `rows`, `row`)

El componente `colorGrid` permite crear cuadrículas de muestra de colores extremadamente flexibles.

### Alias Soportados:
- **Columnas Totales:** `cols` o `columns` (ej. `cols = 4` o `columns = 4`).
- **Filas Totales:** `rows` o `row` (ej. `rows = 3` o `row = 3`).
- **Columna Individual:** `col` o `column` (ej. `col = 1` o `column = 1`).
- **Fila Individual:** `row` o `row` (ej. `row = 2`).

### Ejemplo con Alias Cortos (`cols` y `col`):
```lua
{ type="colorGrid", cols=3, options = {
    { key="enemyHealthColor",    label=_G["ENEMY"] or L["Enemy"],      col=1, default={r=1, g=0.2, b=0.2} },
    { key="friendlyHealthColor", label=_G["FRIENDLY"] or L["Friendly"],col=2, default={r=0.2, g=1, b=0.2} },
    { key="neutralHealthColor",  label=_G["NEUTRAL"] or L["Neutral"],  col=3, default={r=1, g=1, b=0.2} },
}}
```

---

## 9. Matemáticas del Salto de Fila y Auto-Acomodo

Si no especificas la fila o la columna en un elemento, el motor utiliza una **fórmula matemática fluida** para distribuir los elementos automáticamente:

1. **Columnas por Defecto:** Asume **3 columnas** (`numCols = 3`) por defecto.
2. **Cálculo de Columna (Módulo `%`):**
   $$	ext{colIndex} = (cIdx - 1) \pmod{	ext{numCols}}$$
3. **Cálculo de Fila (División Entera `/`):**
   $$	ext{rowIndex} = \lfloor (cIdx - 1) / 	ext{numCols} 
floor$$

### Auto-Salto de Fila al omitir `row`:
```lua
{ type = "allClassSwatches", cols = 3, options = {
    { key = "DRUID",   col = 1 }, -- Fila 1, Columna 1
    { key = "ROGUE",   col = 2 }, -- Fila 1, Columna 2
    { key = "WARLOCK", col = 3 }, -- Fila 1, Columna 3
    { key = "PALADIN", col = 1 }, -- Fila 2, Columna 1 (¡Auto-salto de fila!)
}}
```

---

## 10. Diseño en la Misma Línea (`inline` y Centrado Vertical)

Cuando quieres colocar una muestra de color o widget **en la misma fila horizontal** que su casilla de verificación padre, utilizas **`inline = true`** (o `inline = "clavePadre"`).

```lua
{ type="checkbox", key="useOneClassColor", label=L["Use_One_Color"], parent="overrideClassColors" },
{ type="colorGrid", parent="useOneClassColor", inline=true, options = {
    { key="singleClassColor", label=L["All_Classes"], default={r=0.8, g=0.8, b=0.8} }
}},
```

### Centrado Vertical por Punto Medio:
El motor calcula automáticamente el punto medio de la fila de la casilla y centra verticalmente el widget inline:
$$	ext{vMidOffset} = \lfloor (	ext{refHeight} - 	ext{itemHeight}) / 2 
floor$$

Además, el motor **guarda y restaura la posición `currentY`**, de modo que las opciones siguientes continúan hacia abajo sin dejar espacios vacíos.

---

## 11. Control de Espaciados y Márgenes (`margin`, `marginTop`, `marginBottom`)

Para darle espacio personalizado por encima, abajo o a los costados de cualquier elemento, se utilizan las propiedades de **`margin`**:

- **`marginTop`**: Empuja la posición vertical hacia abajo **antes** de dibujar el elemento (espacio superior).
- **`marginBottom`**: Empuja la posición vertical hacia abajo **después** de dibujar el elemento (espacio inferior).
- **`marginLeft`**: Añade sangría hacia la derecha (espacio izquierdo).
- **`marginRight`**: Ajusta el margen derecho.
- **`margin`**: Acepta un número o tabla `{ top, right, bottom, left }`.

```lua
{ type="header", label=L["Reaction_Colors"], marginTop=8, marginBottom=4 },
{ type="checkbox", key="overrideClassColors", label=L["Override_Class_Colors"], marginTop=4 },
```

---

## 12. Normalización Inteligente de Claves (`key`)

El motor reconoce automáticamente claves cortas de clases o poderes de WoW y las traduce al nombre de variable oficial de la base de datos:

- **Clases:** Si escribes `key = "DRUID"`, el motor lo convierte automáticamente a `classColorDRUID` para guardar en `BetterBlizzFramesDB["classColorDRUID"]`.
- **Color Predeterminado:** Si omites el parámetro `default`, el motor toma el color oficial de WoW nativo (`RAID_CLASS_COLORS["DRUID"]`).

Ambas declaraciones son 100% equivalentes:

```lua
-- Forma A: Clave completa de DB
{ type = "colorGrid", cols = 3, options = {
    { key = "classColorDRUID",   label = "Druida",   col = 1 },
    { key = "classColorROGUE",   label = "Pícaro",   col = 2 },
    { key = "classColorWARLOCK", label = "Brujo",    col = 3 },
}}

-- Forma B: Tag corto de clase (Auto-normalizado)
{ type = "colorGrid", cols = 3, options = {
    { key = "DRUID",   label = "Druida",   col = 1 },
    { key = "ROGUE",   label = "Pícaro",   col = 2 },
    { key = "WARLOCK", label = "Brujo",    col = 3 },
}}
```

---

## 13. Componentes Dinámicos (`allClassSwatches` y `allPowerSwatches`)

Por defecto, `{ type = "allClassSwatches" }` genera automáticamente los 13 colores de clase ordenados por su **`classID` oficial de Blizzard (1 al 13)**:

1. Guerrero (`classID = 1`)
2. Paladín (`classID = 2`)
3. Cazador (`classID = 3`)
4. Pícaro (`classID = 4`)
5. Sacerdote (`classID = 5`)
6. Caballero de la Muerte (`classID = 6`)
7. Chamán (`classID = 7`)
8. Mago (`classID = 8`)
9. Brujo (`classID = 9`)
10. Monje (`classID = 10`)
11. Druida (`classID = 11`)
12. Cazador de Demonios (`classID = 12`)
13. Evocador (`classID = 13`)

### Personalizaciones en `allClassSwatches`:

#### 1. Cambiar el número de filas (auto-calcula columnas):
```lua
{ type = "allClassSwatches", rows = 3 }
```

#### 2. Cambiar columnas con auto-salto de fila:
```lua
{ type = "allClassSwatches", cols = 3, options = {
    { key = "DRUID",   col = 1 }, -- Fila 1, Columna 1
    { key = "ROGUE",   col = 2 }, -- Fila 1, Columna 2
    { key = "WARLOCK", col = 3 }, -- Fila 1, Columna 3
    { key = "PALADIN", col = 1 }, -- Fila 2, Columna 1
}}
```

#### 3. Especificar fila y columna exactas:
```lua
{ type = "allClassSwatches", cols = 3, options = {
    { key = "DRUID",   col = 1, row = 1 },
    { key = "ROGUE",   col = 2, row = 1 },
    { key = "WARLOCK", col = 3, row = 1 },
    { key = "PALADIN", col = 1, row = 2 },
}}
```

---


### Desglose Detallado de un Esquema de Ventana Emergente (`customColors`)

A continuación se explica línea por línea qué hace cada atributo dentro del esquema de la ventana emergente de colores personalizados:

```lua
customColors = {
    id         = "BBFCustomColorOptionsFrame",
    title      = L["Custom_Health_Colors"],
    width      = 360,
    height     = 560,
    scrollable = true,
    options    = {
        { type="header", label=L["Custom_Colors"] },
        { type="checkbox", key="customColorsUnitFrames", label=L["Enable_On_UnitFrames"], tooltip=L["Tooltip_Enable_On_UnitFrames_Desc"], onChange=BBF.UpdateFrames },
        { type="checkbox", key="customColorsRaidFrames", label=L["Enable_On_Raid_Party_Frames"], tooltip=L["Tooltip_Enable_On_Raid_Party_Frames_Desc"], onChange=BBF.UpdateFrames },

        { type="header", label=L["Reaction_Colors"] },
        { type="colorGrid", columns=3, options = {
            { key="enemyHealthColor",    label=_G["ENEMY"] or L["Enemy"],      default={r=1, g=0.2, b=0.2} },
            { key="friendlyHealthColor", label=_G["FRIENDLY"] or L["Friendly"],default={r=0.2, g=1, b=0.2} },
            { key="neutralHealthColor",  label=_G["NEUTRAL"] or L["Neutral"],  default={r=1, g=1, b=0.2} },
        }},
    },
}
```

#### Explicación Campo por Campo:

1. **`customColors = { ... }`**: Nombre del identificador del popup dentro del registro `popups = { ... }`. Permite abrir esta ventana desde Lua llamando a `BBF.GUI.OpenPopup("customColors")`.
2. **`id = "BBFCustomColorOptionsFrame"`**: Nombre global del marco nativo en la API de WoW (`CreateFrame("Frame", "BBFCustomColorOptionsFrame", ...)`).
3. **`title = L["Custom_Health_Colors"]`**: Título traducible que aparece en la barra superior de la ventana emergente.
4. **`width = 360, height = 560`**: Dimensiones físicas en píxeles de la ventana emergente (360px de ancho por 560px de alto).
5. **`scrollable = true`**: Activa el contenedor desplazable (*ScrollFrame*). Permite incluir decenas de opciones sin desbordar el tamaño de la ventana, permitiendo hacer scroll con la rueda del ratón.
6. **`options = { ... }`**: Lista ordenada de controles que el motor construirá dentro del panel.
7. **`{ type="header", label=L["Custom_Colors"] }`**: Encabezado visual para separar el grupo de opciones de activación.
8. **`{ type="checkbox", key="customColorsUnitFrames", ..., onChange=BBF.UpdateFrames }`**: Casilla para activar colores en UnitFrames. Al cambiar, ejecuta inmediatamente `BBF.UpdateFrames()` para repintar marcos en tiempo real.
9. **`{ type="checkbox", key="customColorsRaidFrames", ..., onChange=BBF.UpdateFrames }`**: Casilla para activar colores en marcos de grupo y banda.
10. **`{ type="header", label=L["Reaction_Colors"] }`**: Encabezado visual para la sección de colores por facción/reacción.
11. **`{ type="colorGrid", columns=3, options = { ... } }`**: Crea una cuadrícula de 3 columnas para seleccionar colores de enemigos, aliados y neutrales.
    - **`default = {r=1, g=0.2, b=0.2}`**: Color inicial predeterminado si el usuario no ha personalizado la opción.
    - **`label = _G["ENEMY"] or L["Enemy"]`**: Usa la variable global nativa de Blizzard `_G["ENEMY"]` para obtener la traducción oficial de WoW en cualquier idioma.


### Componente Dinámico `allPowerSwatches` (Muestras de Poder/Recurso)

El componente `{ type = "allPowerSwatches" }` genera automáticamente la lista completa de barras de recursos y poderes del juego (Maná, Rabia, Enfoque, Energía, Poder Rúnico, etc.).

```lua
{ type = "allPowerSwatches" }
```

#### 1. ¿Cómo sabe el motor cuáles son los poderes?
El motor `gui_builder.lua` incluye una **lista maestra predefinida** con los 13 recursos principales de WoW y sus colores nativos oficiales:

```lua
powerTypes = {
    { key = "MANA",        color = {r = 0,     g = 0.5,   b = 1} },
    { key = "RAGE",        color = {r = 1,     g = 0,     b = 0} },
    { key = "FOCUS",       color = {r = 1,     g = 0.5,   b = 0.25} },
    { key = "ENERGY",      color = {r = 1,     g = 1,     b = 0} },
    { key = "RUNIC_POWER", color = {r = 0,     g = 0.82,  b = 1} },
    { key = "LUNAR_POWER", color = {r = 0,     g = 0.9,   b = 1} },
    { key = "MAELSTROM",   color = {r = 0,     g = 0.5,   b = 1} },
    { key = "INSANITY",    color = {r = 0.4,   g = 0,     b = 0.8} },
    { key = "CHI",         color = {r = 0.71,  g = 1,     b = 0.92} },
    { key = "FURY",        color = {r = 0.788, g = 0.259, b = 0.992} },
    { key = "EBON_MIGHT",  spellID = 395152, color = {r = 0.2,  g = 0.58, b = 0.5} },
    { key = "STAGGER",     color = {r = 0.52,  g = 1,     b = 0.52} },
    { key = "SOUL_SHARDS", spellID = 246985, color = {r = 0.64, g = 0.2,  b = 0.93} },
}
```

#### 2. ¿Cómo se identifican en la Base de Datos?
Cada recurso usa una clave interna (`key`). El motor les concatena automáticamente el prefijo `"powerColor"` para guardar el valor en `BetterBlizzFramesDB`:
- `BetterBlizzFramesDB["powerColorMANA"]`
- `BetterBlizzFramesDB["powerColorRAGE"]`
- `BetterBlizzFramesDB["powerColorEBON_MIGHT"]`

#### 3. ¿Cómo resuelve sus nombres traducidos?
Para mostrar el nombre en el idioma actual del juego (Español, Inglés, etc.), el motor utiliza una **cascada de resolución inteligente en 3 niveles**:
1. Busca la traducción nativa en las globales de Blizzard `_G[key]` (ej. `_G["MANA"]` devuelve *"Maná"*).
2. Busca `_G["POWER_TYPE_" .. key]`.
3. Si la clave incluye un `spellID` (ej. 395152 para *Ebon Might* o 246985 para *Soul Shards*), consulta el nombre del hechizo oficial mediante `C_Spell.GetSpellName(spellID)`.

#### 4. Personalizaciones en `allPowerSwatches`:
Al igual que con las clases, puedes cambiar el número de columnas o personalizar la lista:

```lua
-- Genera los poderes en 4 columnas
{ type = "allPowerSwatches", cols = 4 }

-- O limita la cuadrícula a 3 filas
{ type = "allPowerSwatches", rows = 3 }
```


### Alias de Color Predeterminado (`color` y `default`)

El motor acepta de forma **100% equivalente** tanto el atributo **`color = {r, g, b}`** como **`default = {r, g, b}`** para especificar el color inicial predeterminado en `colorGrid`, `allClassSwatches` y `allPowerSwatches`:

```lua
-- Usando 'color'
{ key = "enemyHealthColor", label = "Enemigo", color = {r=1, g=0.2, b=0.2} }

-- Usando 'default' (Equivalente)
{ key = "enemyHealthColor", label = "Enemigo", default = {r=1, g=0.2, b=0.2} }
```

---

### Muestras de Poder/Recurso Manuales (`allPowerSwatches` y `colorGrid`)

Al igual que con las clases, puedes definir manualmente el orden de los poderes o usar `colorGrid` directamente con los tags de recurso (`MANA`, `RAGE`, `ENERGY`, etc.):

#### 1. Usando `allPowerSwatches` con lista `options` personalizada:
```lua
{ type = "allPowerSwatches", cols = 3, options = {
    { key = "MANA",   color = {r=0, g=0.5, b=1} },
    { key = "RAGE",   color = {r=1, g=0, b=0} },
    { key = "ENERGY", color = {r=1, g=1, b=0} },
}}
```

#### 2. Usando `colorGrid` directamente para recursos de poder:
```lua
{ type = "colorGrid", cols = 3, options = {
    { key = "MANA",        label = "Maná",   color = {r=0, g=0.5, b=1} },
    { key = "RAGE",        label = "Rabia",  color = {r=1, g=0, b=0} },
    { key = "RUNIC_POWER", label = "Rúnico", color = {r=0, g=0.82, b=1} },
}}
```

## 14. Ejemplos Completos y Casos de Uso

### Ejemplo A: Sección de Ajustes con Sub-Casillas y Muestras Inline

```lua
{ type="header", label=L["Class_Colors"], marginTop=6, marginBottom=4 },
{ type="checkbox", key="overrideClassColors", label=L["Override_Class_Colors"] },
{ type="checkbox", key="useOneClassColor", label=L["Use_One_Color"], parent="overrideClassColors" },
{ type="colorGrid", parent="useOneClassColor", inline=true, options = {
    { key="singleClassColor", label=L["All_Classes"], default={r=0.8, g=0.8, b=0.8} }
}},
{ type="allClassSwatches", parent="overrideClassColors", cols=3, marginTop=4 },
```

---

### Ejemplo B: Casilla Especial Dual (`dualchild`)

```lua
{ type="dualchild",
  parent = "classColorFrames",
  key1   = "classColorFramesSkipFriendly", label1 = L["Class_Color_Skip_Friendly"], tooltip1 = L["Tooltip_Class_Color_Skip_Friendly_Desc"],
  key2   = "classColorFramesSkipPlayer",   label2 = L["Class_Color_Skip_Player"],   tooltip2 = L["Tooltip_Class_Color_Skip_Player_Desc"]
}
```

---

### Resumen de Reglas de Diseño

1. **Usa `parent` para dependencias planas**: Mantiene el archivo de esquema limpio y legible.
2. **Usa `inline=true` para controles en la misma fila**: Ahorra espacio vertical centrando los elementos.
3. **Usa `cols` y `col` / `rows` y `row`**: El motor calculará y acomodará los elementos automáticamente.
4. **Usa `marginTop` y `marginBottom`**: Da espaciado visual respirable entre secciones sin tocar código imperativo.


## 15. Arquitectura y Construcción de Tooltips

### Centralización del Tema Visual de Tooltips (`GUI.Theme.Tooltip`)

Toda la especificación de diseño de los tooltips (fuentes, colores RGB, anclajes y atlas por defecto) está centralizada en la tabla de tema **`GUI.Theme.Tooltip`** dentro de [`gui_builder.lua`](file:///d:/Application%20Files/Battle.net/World%20of%20Warcraft/_retail_/Interface/AddOns/BetterBlizzFrames/midnight/gui_builder.lua):

```lua
GUI.Theme.Tooltip = {
    anchor          = "ANCHOR_RIGHT",
    titleFont       = "GameTooltipHeaderText", -- Fuente del Título (~14px negrita)
    titleColor      = { 1, 0.82, 0, 1 },       -- Color Dorado de Título
    bodyFont        = "GameTooltipText",       -- Fuente del Cuerpo (~12px)
    bodyColor       = { 1, 1, 1, 1 },          -- Color Blanco Puro de Cuerpo
    subtextFont     = "GameTooltipTextSmall",  -- Fuente de Notas al Pie (~11px)
    subtextColor    = { 0.8, 0.8, 0.8, 1 },    -- Color Gris Claro de Subtexto
    cvarColor       = { 0.2, 1, 0.6, 1 },      -- Color Verde Turquesa para CVars
    dividerColor    = { 0.8, 0.8, 0.8, 1 },    -- Color de Línea Divisoria
    defaultIconSize = { 16, 16 },              -- Tamaño Estándar de Iconos (16x16px)
    starAtlas       = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star",
    noStarAtlas     = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-IconRing",
    checkmarkAtlas  = "ParagonReputation_Checkmark",
}
```
 (`CreateTooltipTwo`)

El motor de `gui_builder.lua` utiliza el constructor imperativo `BBF.CreateTooltipTwo` para generar tooltips informativos extremadamente ricos y dinámicos.

### 1. Estructura y Parámetros de `CreateTooltipTwo`

```lua
BBF.CreateTooltipTwo(widget, title, mainText, subText, anchor, cvarName, cpuUsage, category)
```

| Parámetro | Tipo | Descripción |
| :--- | :---: | :--- |
| **`widget`** | `Frame` / `Button` | El elemento de la interfaz al que se vincula el tooltip. |
| **`title`** | `string` | Título principal en negrita (resaltado en la parte superior). |
| **`mainText`** | `string` | Cuerpo de la descripción principal en **blanco puro `(RGB: 1, 1, 1)`** con salto de línea automático (*wrap*). |
| **`subText`** | `string` | (Opcional) Texto secundario o notas al pie en **gris claro `(RGB: 0.8, 0.8, 0.8)`**, separado automáticamente por una línea divisoria `____________________________`. |
| **`anchor`** | `string` | (Opcional) Punto de anclaje visual (por defecto `"ANCHOR_RIGHT"`, o `"ANCHOR_TOPRIGHT"`, `"ANCHOR_TOP"`). |
| **`cvarName`** | `string` | (Opcional) Nombre de la CVar nativa de WoW que modifica la opción (formateado en verde turquesa). |
| **`cpuUsage`** | `number` | (Opcional) Impacto de rendimiento (0 a 5 estrellas dibujadas con atlas de estrellas nativas). |

---

### 2. Sistema de Colores y Formateo Hexadecimal

Los textos de los tooltips utilizan códigos de color hexadecimales nativos de WoW para jerarquizar la información:

| Código de Color | Tono Visual | Caso de Uso |
| :--- | :---: | :--- |
| **`(1, 1, 1)`** | Blanco Puro | Descripción principal del cuerpo del tooltip. |
| **`(0.8, 0.8, 0.8)`** | Gris Claro | Subtextos y notas explicativas al pie. |
| **`|cff32f795`** | Verde Neón | Opciones activas, accesos rápidos de clic derecho y marcas de verificación. |
| **`|cff7fc6ff`** | Azul Claro (*Baby Blue*) | Modos de omisión secundarios y configuraciones alternas. |
| **`|cffffff00`** | Amarillo Brillante | Instrucciones de uso e información relevante. |
| **`|cffffaa00`** | Naranja | Modificadores del teclado (Shift + Clic / Ctrl + Clic). |
| **`|r`** | Reset | Restaura el color del texto al tono blanco predeterminado. |

---

### 3. Incrustación de Imágenes y Atlas en Tooltips (`|A:...|a`)

WoW permite incrustar imágenes nativas y atlas directamente en las cadenas de texto del tooltip mediante la sintaxis:

$$	ext{Sintaxis: } 	exttt{\|A:nombreAtlas:alto:ancho\|a}$$

#### Ejemplos de Imágenes y Tamaños Nativos:
- **Flechas de Transición:** `|A:glueannouncementpopup-arrow:20:20|a` *(20px de alto por 20px de ancho)*.
- **Marca de Verificación Verde (*Checkmark*):** `|A:ParagonReputation_Checkmark:15:15|a` *(15px por 15px)*.
- **Borde de Disipación de Grupo:** `|A:RaidFrame-DispelHighlight:15:30|a` *(15px de alto por 30px de ancho)*.
- **Iconos de Pases de Botín:** `|A:lootroll-toast-icon-pass-up:22:22|a` *(22px por 22px)*.
- **Estrellas de Rendimiento CPU:** `|A:UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star:16:16|a` *(16px por 16px)*.

---

### 4. Tooltips Dinámicos con Verificación de Estado en Tiempo Real

Cuando una opción soporta interacciones de clic derecho o Shift/Ctrl + clic, el motor **inspecciona `BetterBlizzFramesDB` en tiempo real durante el evento `OnEnter`** y añade dinámicamente marcas de verificación verdes (`|A:ParagonReputation_Checkmark:15:15|a`) junto a los modos activos:

```lua
-- Ejemplo de construcción dinámica dentro del motor
if BetterBlizzFramesDB.classColorFramesSkipPlayer then
    tooltipText = tooltipText .. " |A:ParagonReputation_Checkmark:15:15|a"
end
```
