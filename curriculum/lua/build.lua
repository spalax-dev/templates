-- build.lua
-- Genera variables LaTeX desde data.json (plantilla genérica)

-- Paths relativos al directorio del .tex
local function datapath(name)
    return name  -- Ya funciona porque lualatex se ejecuta desde el dir del .tex
end

local json = assert(loadfile(datapath("lua/dkjson.lua"))())

-- Busca data.json primero (si tiene contact.name), sino usa data-template.json
local filepath = "data.json"
local f = io.open(filepath, "r")
if not f then
    filepath = "data-template.json"
else
    local content = f:read("*a")
    f:close()
    -- Busca "contact" seguido de "name" para validar que tiene datos de contacto
    if not content:match('"contact".-"name"') then
        filepath = "data-template.json"
    end
end

local file = io.open(filepath, "r")
if not file then
    print("Error: No se encontro data.json ni data-template.json")
    return
end
local data = json.decode(file:read("*a"))
file:close()

local function escape(s)
    if not s then return "" end
    s = s:gsub("\\", "\\\\")
    s = s:gsub("[&%$#_%_{}]", "\\%1")
    return s
end

local function stripProtocol(url)
    if not url then return "" end
    return url:gsub("https?://", "")
end

-- Contacto
NOMBRE = data.contact and data.contact.name or "Tu Nombre"
EMAIL = data.contact and data.contact.email or "email@ejemplo.com"
GITHUB = data.contact and data.contact.github or "https://github.com/user"
LINKEDIN = data.contact and data.contact.linkedin or "https://linkedin.com/in/user"
LOCATION = data.contact and data.contact.location or "Tu Ciudad, Tu País"

-- Display sin protocolo
GITHUB_DISPLAY = stripProtocol(GITHUB)
LINKEDIN_DISPLAY = stripProtocol(LINKEDIN)

-- Perfil profesional
PROFILE = escape(data.profile or "Breve descripción de tu perfil profesional.")

-- Generar proyectos destacados
PROJECTS = ""
for i, p in ipairs(data.projects or {}) do
    local tech = table.concat(p.tech or {}, " · ")
    if i > 1 then
        PROJECTS = PROJECTS .. "\\par\\smallskip"
    end
    PROJECTS = PROJECTS .. string.format("\\noindent\\textbf{%s} · \\emph{%s}\\newline %s \\newline → \\href{%s}{%s}", 
        escape(p.title), escape(tech), escape(p.description), escape(p.repo or ""), escape(stripProtocol(p.repo)))
end

-- Generar habilidades (todas en un párrafo)
SKILLS = ""
if data.skills then
    local all = {}
    if data.skills.main then
        for _, s in ipairs(data.skills.main) do
            table.insert(all, s.name)
        end
    end
    if data.skills.others then
        for _, s in ipairs(data.skills.others) do
            table.insert(all, s.name)
        end
    end
    SKILLS = escape(table.concat(all, " · "))
end

-- Generar eventos/participaciones
EVENTS = ""
for i, e in ipairs(data.events or {}) do
    if i > 1 then
        EVENTS = EVENTS .. "\\par"
    end
    EVENTS = EVENTS .. string.format("\\noindent\\textbf{%s} · %s · %s \\newline %s", 
        escape(e.name or ""), escape(e.organizer or ""), escape(e.year or ""), escape(e.description or ""))
end
if EVENTS == "" then
    EVENTS = "\\textit{Sin eventos registrados}"
end

-- Generar educación
EDUCATION = ""
for i, e in ipairs(data.education or {}) do
    if i > 1 then
        EDUCATION = EDUCATION .. "\\par"
    end
    EDUCATION = EDUCATION .. string.format("\\noindent\\textbf{%s} · %s · %s -- %s\\newline %s", 
        escape(e.degree or ""), escape(e.institution or ""), escape(e.startYear or ""), escape(e.endYear or ""), escape(e.description or ""))
end

-- Generar idiomas
LANGUAGES = ""
for i, l in ipairs(data.languages or {}) do
    if i > 1 then
        LANGUAGES = LANGUAGES .. "\\par"
    end
    LANGUAGES = LANGUAGES .. string.format("\\cvitem{%s}{%s}", escape(l.name or ""), escape(l.level or ""))
end
if LANGUAGES == "" then
    LANGUAGES = "\\cvitem{Español}{Nativo}"
end