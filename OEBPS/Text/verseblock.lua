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

local notes = {
  ["nota1"] = "Expresión que se suele traducir por «abandono de cuerpo y mente» a través de ella el maestro Dôgen Zenji realizó la Vía",
 ["nota2"] = "Eihei Dōgen (永平道元) también Dōgen Zenji (道元禅師) o Dōgen Kigen (道元希玄) o Koso Joyo Daishi (literalmente Ancestro Eminente, Sustentador de Luz, Gran Maestro) (Kioto, 26 de enero de 1200 Ib., 29 de septiembre de 1253) fue el maestro zen fundador de la escuela Sōtō del Zen en Japón.",
 ["nota3"] = "",
 ["nota4"] = "",
 ["nota5"] = "",
 ["nota14"] = "Blas Pascal (1623-1662) fue un filósofo y matemático francés conocido por sus contribuciones a la teoría de la probabilidad y la filosofía.",
    ["nota7"] = "La identificación con un yo autónomo e independiente se considera una ilusión en el budismo.",
    -- Añade más notas aquí
}

function Link(el)
    if el.target:match("^#nota") then
        local note_id = el.target:match("#(nota%d+)")
        local note_content = notes[note_id] or "Nota no encontrada."
        return pandoc.RawInline('latex', '\\footnote{' .. note_content .. '}')
    end
end

