# Templates

Plantillas y herramientas para generación de documentos.

---

## Curriculum Vitae

Generador de CV en PDF usando **LuaLaTeX** y datos en JSON.

> **Orientado a:** perfiles sin experiencia laboral (estudiantes, egresados recientes).
> Incluye secciones de proyectos, habilidades técnicas, formación y participación en eventos.

### Estructura

```
curriculum/
├── main.tex              # Template LaTeX
├── data.json             # Tus datos reales (privado)
├── data-template.json    # Plantilla con datos genéricos
├── lua/
│   ├── build.lua         # Script que genera el PDF desde JSON
│   └── dkjson.lua        # Librería JSON para Lua
└── .gitignore
```

### Uso

```bash
cd curriculum

# 1. Copiar la plantilla como base
cp data-template.json data.json

# 2. Editar data.json con tus datos

# 3. Compilar
latexmk --lualatex

# 4. Limpiar archivos intermedios
latexmk -c
```

### Notas

- El script `lua/build.lua` busca automáticamente `data.json` primero.
  Si no tiene campo `name` en `contact`, usa `data-template.json`.
- **No subas `data.json`** a repositorios públicos.
- Fuente Inter se usa por defecto.

---

## APA Universidad del Quindío

Template para trabajos académicos con formato APA según normativas de la Universidad del Quindío.

### Estructura

```
apa_uniquindio/
├── main.tex      # Template principal
├── ref.bib       # Referencias bibliográficas
├── images/       # Imágenes y recursos
└── .gitignore
```

### Uso

```bash
cd apa_uniquindio

# Compilar
latexmk --lualatex

# Limpiar
latexmk -c
```

### Notas

- Incluye logo institucional de la UQ
- Formato APA 7ma edición
- Soporta BibTeX para referencias

---

## Compilación

Para ambos templates se recomienda usar **latexmk**:

```bash
# Compilar (detecta cambios y compila las veces necesarias)
latexmk --lualatex

# Limpiar archivos intermedios
latexmk -c

# Compilar manualmente (sin latexmk)
lualatex main.tex
```
