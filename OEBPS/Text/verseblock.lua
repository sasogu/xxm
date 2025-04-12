function Div(el)
    if el.classes:includes('verse2') then
      if FORMAT:match('latex') then
        return {
          pandoc.RawBlock('latex', '\\begin{center}'),
          el,
          pandoc.RawBlock('latex', '\\end{center}')
        }
      end
    end
  end

  function Div(el)
    if el.classes:includes('verse') then
        if FORMAT:match('latex') then
            local content = pandoc.write(pandoc.Pandoc(el.content), "latex")
            return {
                pandoc.RawBlock('latex', '\\clearpage'),
                pandoc.RawBlock('latex', '\\vspace*{\\fill}'),
                pandoc.RawBlock('latex', '\\noindent\\begin{minipage}{\\textwidth}\\centering'),
                pandoc.RawBlock('latex', '\\Large'), -- << Añadido: tamaño de fuente
                pandoc.RawBlock('latex', '\\setlength{\\parskip}{1em}'), -- Espacio entre párrafos
                pandoc.RawBlock('latex', content),
                pandoc.RawBlock('latex', '\\end{minipage}'),
                pandoc.RawBlock('latex', '\\vspace*{\\fill}'),
                pandoc.RawBlock('latex', '\\clearpage')
            }
        end
    end
end


  
  function Header(el)
    if el.level == 1 and FORMAT:match('latex') then
      -- Salto de página + centrar encabezados h1
      return {
        pandoc.RawBlock('latex', '\\clearpage'),
        pandoc.RawBlock('latex', '\\begin{center}\\Huge\\textbf{' .. pandoc.utils.stringify(el.content) .. '}\\end{center}')
      }
    end
  end

-- Tabla de notas locales
local notes = {
    ["nota1"] = "Expresión que se suele traducir por «abandono de cuerpo y mente» a través de ella el maestro Dôgen Zenji realizó la Vía.",
    ["nota2"] = "Eihei Dōgen (永平道元) también Dōgen Zenji (道元禅師) o Dōgen Kigen (道元希玄) o Koso Joyo Daishi (literalmente Ancestro Eminente, Sustentador de Luz, Gran Maestro) (Kioto, 26 de enero de 1200 Ib., 29 de septiembre de 1253) fue el maestro zen fundador de la escuela Sōtō del Zen en Japón.",
    ["nota3"] = "Según la RAE.",
    ["nota4"] = "El Dàodé jīng (Chino: 道德經, Wade-Giles: Tao Te Ching, también llamado Tao Te King), también llamado Laozi (老子), es un texto clásico chino atribuido al sabio Lao-Tse del siglo VI a. C.",
    ["nota5"] = "Mahāyāna (sánscrito: «Gran Vehículo», o Bodhisattvayāna, «Vehículo del Bodhisattva») es, junto con el Theravada, una de las dos ramas principales del budismo.",
    ["nota14"] = "Blas Pascal (1623-1662) fue un filósofo y matemático francés conocido por sus contribuciones a la teoría de la probabilidad y la filosofía.",
    ["nota7"] = "La identificación con un yo autónomo e independiente se considera una ilusión en el budismo."
}

-- Función para procesar enlaces y convertirlos en notas al pie
function Link(el)
    if el.target:match("^#nota") then
        -- Extraer el identificador de la nota (por ejemplo, "nota1")
        local note_id = el.target:match("#(nota%d+)")
        -- Buscar el contenido de la nota en la tabla
        local note_content = notes[note_id] or "Nota no encontrada."
        -- Generar una nota al pie en LaTeX
        return pandoc.RawInline('latex', '\\footnote{' .. note_content .. '}')
    end
end

