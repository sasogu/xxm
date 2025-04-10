function Div(el)
    if el.classes:includes('verse') then
        if FORMAT:match('latex') then
            -- Procesar el bloque con clase 'verse'
            return {
                pandoc.RawBlock('latex', '\\begin{verseblock}'),
                el,
                pandoc.RawBlock('latex', '\\end{verseblock}')
            }
        end
    end
end

function Header(el)
    if el.level == 1 and FORMAT:match('latex') then
        -- Añadir un salto de página antes de cada <h1> y centrarlo
        local content = pandoc.utils.stringify(el.content)
        return {
            pandoc.RawBlock('latex', '\\newpage'),
            pandoc.RawBlock('latex', '\\begin{center}\\textbf{' .. content .. '}\\end{center}')
        }
    end
end

\newenvironment{verseblock}
  {\begin{center}\begin{minipage}{0.8\textwidth}}
  {\end{minipage}\end{center}}